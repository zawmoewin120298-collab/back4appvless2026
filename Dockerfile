# Step 1: ပေါ့ပါးတဲ့ Alpine Linux ကို သုံးမယ်
FROM alpine:latest

# Step 2: Environment Variables
ENV PORT=80
ENV TUNNEL_TOKEN=YOUR_TOKEN_HERE

# Step 3: လိုအပ်တဲ့ Tools များနှင့် တည်ငြိမ်မှုအတွက် CA-Certificates များသွင်းခြင်း
RUN apk add --no-cache curl unzip ca-certificates libc6-compat caddy

# Step 4: V2Ray Core ကို မှန်ကန်သော Link ဖြင့် သွင်းယူခြင်း
WORKDIR /v2ray
RUN curl -L -o v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip v2ray.zip && \
    rm v2ray.zip && \
    chmod +x v2ray

# Step 5: Cloudflare Tunnel (cloudflared) ကို Install လုပ်ခြင်း
RUN curl -L -o /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

# Step 6: Config ဖိုင်များနှင့် Caddyfile ကို ဆာဗာထဲ ထည့်သွင်းခြင်း
COPY config.json /v2ray/config.json
COPY Caddyfile /etc/caddy/Caddyfile

# Step 7: Container အပြင်ကို Port 80 ဖွင့်ပေးခြင်း
EXPOSE 80

# Step 8: Service (၃) ခုလုံးကို Background တွင် တစ်ပြိုင်နက် ပေါင်း Run ခြင်း
CMD sh -c "caddy run --config /etc/caddy/Caddyfile & /v2ray/v2ray run -config /v2ray/config.json & cloudflared tunnel --no-autoupdate run --token ${TUNNEL_TOKEN} & wait -n"

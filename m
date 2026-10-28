Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212147;
	b=CrVfElS728zI5QRjWq7nU3YWj/+oZzGZNdbDDlu75Mvrz78M7Ctmq95UaMe8tlIsjGaX
	 t9TvHh/RNSNxPzayukCEW2qU4njwZ+VaMDs8Zy7ESjiCg4D+GklcyRopjv1731AQeKnks
	 ffsWD+6lBEGJgilzbYz1GwODZIzftlImyhrb8Nyk3YVvOS0cs3Yw7PgtAeQv4ViSw2YcP
	 khorXqcaUrXjURDp5KjQ89qggLkyAKGWpZ7AJEhJj8D+zSsUzdKEdWrqX2GvXFHW0gKG1
	 lxNseey9nWTH71HAf2a0x7AFGtPsZ4oZgrmRMan/lpVByZOeMcVlm7m64Ir1CzmqPqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EeX5+u1jhLgiRTX4ti7d9jEZWZ17InGx5CbVOObyaE4=;
	b=UXB5mRRmRdphW2NnuDQSeyvRAGcliExBz7fctaQzm7U3bJ8iagibOpK8nf4VQMB0sgVr
	 6BW0CrSAJ/L09RQzMczn6iS/AVWNramf03AzhuGPbW2KS6uOT/kDrarWlPPxkCeRpyF3c
	 btUhRxbhiMonNUMaN05f8mTJ+pEXD4ApSxZnm1YeCNCyiW3u+2FH1groPpOYScsLG1o1a
	 Sxb5P5kZIyjCLrnSXOgrIft9608e5Ac//3fi/dUXQZRCX5q08iToloneHsI2H9sdPNG03
	 xNp+i2UNssbFfU1po5kHlIJPbCuJvWRIWM9dj92JgcZS4JHHHnp6tlESRibTLO6pLZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iy24rN8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103FD606A31E;
	Wed, 28 Oct 2026 18:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iy24rN8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241B81F031E2;
	Wed, 28 Oct 2026 18:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212146;
	bh=EeX5+u1jhLgiRTX4ti7d9jEZWZ17InGx5CbVOObyaE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iy24rN8zkcyZ3GMkPoYr4uYILSGZHHzNpXJLBJLrLXvJuNRDF+T72J76pWuRsy3I4
	 5sk0hiWkZ46GlLggKXUfJI2JXEMZqSet5NU74KprYKpxEuNWi7veNpw5bjMp4VmSGx
	 5Q+sBjGtg1oqB/codsqZMOsvSWohfE//2Gm0kcmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0053/1887] wifi: libipw: reject TKIP frames without a full MIC
Date: Wed, 28 Oct 2026 17:35:49 +0100
Message-ID: <20261028170500.434091174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 06f42accaf3c6aecab1dcc57f68dde6c06c8b380 ]

libipw_michael_mic_verify() assumes that an skb contains an eight-byte
Michael MIC. A short TKIP frame makes the unsigned payload length wrap,
causing michael_mic() to read past the skb.

Check that the MIC is present before verifying it, and use the existing
MICHAEL_MIC_LEN constant for all MIC lengths in the verifier.

Fixes: b453872c35cf ("[NET] ieee80211 subsystem")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20260909061124.3802517-1-4ncienth@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ adapted libipw changes to the older lib80211 implementation and Michael MIC helper interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/lib80211_crypt_tkip.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 1b4d6c87a5c5d..823274728711a 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -38,6 +38,7 @@ MODULE_DESCRIPTION("lib80211 crypt: TKIP");
 MODULE_LICENSE("GPL");
 
 #define TKIP_HDR_LEN 8
+#define MICHAEL_MIC_LEN 8
 
 struct lib80211_tkip_data {
 #define TKIP_KEY_LEN 32
@@ -585,16 +586,18 @@ static int lib80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 					int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	u8 mic[8];
+	u8 mic[MICHAEL_MIC_LEN];
 
-	if (!tkey->key_set)
+	if (!tkey->key_set || skb->len < hdr_len + MICHAEL_MIC_LEN)
 		return -1;
 
 	michael_mic_hdr(skb, tkey->rx_hdr);
 	if (michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
-			skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
+			skb->data + hdr_len,
+			skb->len - MICHAEL_MIC_LEN - hdr_len, mic))
 		return -1;
-	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
+	if (memcmp(mic, skb->data + skb->len - MICHAEL_MIC_LEN,
+		   MICHAEL_MIC_LEN) != 0) {
 		struct ieee80211_hdr *hdr;
 		hdr = (struct ieee80211_hdr *)skb->data;
 		printk(KERN_DEBUG "%s: Michael MIC verification failed for "
@@ -612,7 +615,7 @@ static int lib80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 	tkey->rx_iv32 = tkey->rx_iv32_new;
 	tkey->rx_iv16 = tkey->rx_iv16_new;
 
-	skb_trim(skb, skb->len - 8);
+	skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
 
 	return 0;
 }
-- 
2.53.0




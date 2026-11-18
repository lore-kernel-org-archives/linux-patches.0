Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050582;
	b=wJ53/5ae9Tx8S1zIIKB7ljalmYH/OKAvDzSYEUXUZkpdM2Omxc7awclNPK+8/d0RFvD2
	 4u5vKQJ3W0485KD8xlfshI7LZvdo5jVEY60Fh9bmgDu9a84iGSA2b4GnMUvAbF0LDtCdk
	 Kk3N2WmjZxNaExJAe4uHWB8rJVlVcDAtFf0gdatq5UJFpV9aNQ/xvgdxGTAVicVp9KvpA
	 47hRpsIUdNLUuAvQlncNRH3ftFRUR2WkcdDoZPHXnrBm56MyEOR0HC8HS/eMHmSh3VdQR
	 0j+bHaH+ViDSeUYhtosrjqczMAJe8n/W78m6adPJ5bqEE+RDNZGRCd+HyKjD/W0HGog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r0p1PTce7uMTLa+r3YSiWGVYq8HK2ym1KDsBAI5f1yI=;
	b=oLyb+Ue9KAQYEbCKVXcqoi1BFpHU49mPHu0Bvcb/8bRn1LLEUYSvONCppA64GZKVCrr4
	 IrsmxXt4T3Nij+Ex5eg09zCO2mzuhYNXqdAROzoIepXqzIs8M6QG7gKtqx2ejYRFCKDlm
	 jJTWldCJ+pKnMHGBwLeqyc5jbEugtTnobIsxQE1HsGJF/WxYHVm9aaaCVGnNZkEbRmQom
	 Qe8TQ6pdG+f+hHGfkoKJ1KmpSjvJ2LTVnp838KRnRBdbdRCOKl+oaF2jrmZgZZOcnkrcq
	 zTztwRG834ouaAIkqP+QJuTKoqemYuKWsypqt5nb0bNFMnQqJGqyb8L2QhLNli3j9jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsCsQ1hA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53060606A32A;
	Thu, 19 Nov 2026 01:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsCsQ1hA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B581F000C4;
	Thu, 19 Nov 2026 01:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050582;
	bh=r0p1PTce7uMTLa+r3YSiWGVYq8HK2ym1KDsBAI5f1yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsCsQ1hATkfT1VMxBWmrHi8QVAS0eMA4w7kvh6WLhtu6Vzt/+0kUDnt9XgZAkZFjq
	 SJeBiCd4cF8oUCiIemjelVnrJlCdah0j3MXSAAqKuiLHkb5rz6eg0JceQrygj0FghI
	 YeEwn8bZga+8WoxQwQirqXHr2aT7aTRz22jSJAms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2718/2857] tls: get crypto_info size from tls_cipher_desc in do_tls_setsockopt_conf
Date: Wed, 18 Nov 2026 16:02:32 +0100
Message-ID: <20261118150339.478800355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 5f309ade49c7068b1149ecf825c4c16e56a3b865 ]

We can simplify do_tls_setsockopt_conf using tls_cipher_desc. Also use
get_cipher_desc's result to check if the cipher_type coming from
userspace is valid.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/e97658eb4c6a5832f8ba20a06c4f36a77763c59e.1692977948.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c43c1c24f3cd ("tls: avoid field-spanning write when copying crypto info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 51fd5c25e968a..42d4266aec70c 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -686,7 +686,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	struct tls_crypto_info *crypto_info;
 	struct tls_crypto_info *alt_crypto_info;
 	struct tls_context *ctx = tls_get_ctx(sk);
-	size_t optsize;
+	const struct tls_cipher_desc *cipher_desc;
 	int rc = 0;
 	int conf;
 
@@ -738,46 +738,23 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 		}
 	}
 
-	switch (crypto_info->cipher_type) {
-	case TLS_CIPHER_AES_GCM_128:
-		optsize = sizeof(struct tls12_crypto_info_aes_gcm_128);
-		break;
-	case TLS_CIPHER_AES_GCM_256: {
-		optsize = sizeof(struct tls12_crypto_info_aes_gcm_256);
-		break;
+	cipher_desc = get_cipher_desc(crypto_info->cipher_type);
+	if (!cipher_desc) {
+		rc = -EINVAL;
+		goto err_crypto_info;
 	}
-	case TLS_CIPHER_AES_CCM_128:
-		optsize = sizeof(struct tls12_crypto_info_aes_ccm_128);
-		break;
-	case TLS_CIPHER_CHACHA20_POLY1305:
-		optsize = sizeof(struct tls12_crypto_info_chacha20_poly1305);
-		break;
-	case TLS_CIPHER_SM4_GCM:
-		optsize = sizeof(struct tls12_crypto_info_sm4_gcm);
-		break;
-	case TLS_CIPHER_SM4_CCM:
-		optsize = sizeof(struct tls12_crypto_info_sm4_ccm);
-		break;
+
+	switch (crypto_info->cipher_type) {
 	case TLS_CIPHER_ARIA_GCM_128:
-		if (crypto_info->version != TLS_1_2_VERSION) {
-			rc = -EINVAL;
-			goto err_crypto_info;
-		}
-		optsize = sizeof(struct tls12_crypto_info_aria_gcm_128);
-		break;
 	case TLS_CIPHER_ARIA_GCM_256:
 		if (crypto_info->version != TLS_1_2_VERSION) {
 			rc = -EINVAL;
 			goto err_crypto_info;
 		}
-		optsize = sizeof(struct tls12_crypto_info_aria_gcm_256);
 		break;
-	default:
-		rc = -EINVAL;
-		goto err_crypto_info;
 	}
 
-	if (optlen != optsize) {
+	if (optlen != cipher_desc->crypto_info) {
 		rc = -EINVAL;
 		goto err_crypto_info;
 	}
-- 
2.53.0




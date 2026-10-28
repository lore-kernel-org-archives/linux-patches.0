Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217398;
	b=l64pJQxaZYT1Rir2Tp8K0bXAJZ3NWEIE5eTjNXuEYiJIj3ZB2cR3VerLPPh214xmDD39
	 BUyVuKA7l9dy1daS8kFxeQTgk9o81kaFAnCH/HbFVtf8JYWzeqBxhKp6gvB1yXUWNJcV4
	 bFb6joCsmVvCXu4GH5PciezqNzx784bu5JbO4vswgXg9RgeZXk0Ez8QOlJQOYuglKWCE4
	 ULdEmI4cSCv05XyKSvfEr16J8zDokZzF5nRqyoPpn798i85qSdSR8ECF2nMJh1Fxwam2S
	 CaAZG9eN2svlYkIAQc/00Wnd1RKk47gjn+9Z2KOZ9msr/N6X6KKUA0Qml9Yf5Jk1ZsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qI+R7K53uCCPfGttklgZbW3RJtRsyQD62lti4Heke1s=;
	b=yfILyOcLHDEG4pdt0AMsOdHDrPJHu3FT+DxcR3Bt9qU2X1fchJsVUD6xdMcPoOTQ3Wxl
	 HDFUgrkGCqV3iOG/lihdZ79GRY6cvsbfsN6Cdqk8NOC75vuYcsA4GeAsPzuSC6Pp1Tvip
	 8IzDtxfSg7ti6ESndZlw0L768aqrikI3w39MqPsAhbtxUu+sXNIlplj9A97NskfdeJ2ql
	 SxUH9vz9amR2dgxs+9M2txvaWwFZbD7rULnp2TGBx+d8HpJa1CQrAYdAGzMHie1LJsRDs
	 Gdy1sdUAxsYgNsYfSJt2KWSnKufWvcR8sLO3iwnQYdPUgvp2WFnUTpMPdslahROUUXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lo2fUsV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A356606A31C;
	Wed, 28 Oct 2026 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lo2fUsV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E9E1F01825;
	Wed, 28 Oct 2026 19:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217397;
	bh=qI+R7K53uCCPfGttklgZbW3RJtRsyQD62lti4Heke1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lo2fUsV0RkmDBdfg3SqW7NK+28tgH7liZcb9nMGqHM3l8HB94SeBqbhwDXykGqwOS
	 Vs+bXAGGT6xx/mKKJU2OLIlPE6jxlhnADb1HXPxhFqH3wHtTD8NY6ZSEgmqesKE9TR
	 v3Ug7e7uAVhuw7TUOyc4G3K/Uqbd5u4GNr79/Uu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1883/1887] Revert "esp: do not unref managed frag pages in esp_ssg_unref()"
Date: Wed, 28 Oct 2026 18:06:19 +0100
Message-ID: <20261028170542.306894866@linuxfoundation.org>
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

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 0fda52de8bbd4ca9a852c8a7ef6536cf82bd71fd ]

This reverts commit 21697720ff43b8dfa25b8e8d9ca7f56f4597fc80.

The patch does not fix the issue completely, so revert for
now and wait for an updated version.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c | 7 -------
 net/ipv6/esp6.c | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 908775cdb8fc6..55b5c890b15a8 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -103,13 +103,6 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	struct aead_request *req;
 	struct scatterlist *sg;
 
-	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
-	 * per-frag page reference, so we must not drop one here.  Mirrors
-	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
-	 */
-	if (skb_zcopy_managed(skb))
-		return;
-
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index a90c9f4c5fd02..72490d27d15f5 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -120,13 +120,6 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp, struct sk_buff *skb)
 	struct aead_request *req;
 	struct scatterlist *sg;
 
-	/* Managed frags are owned by the zerocopy ubuf; the skb holds no
-	 * per-frag page reference, so we must not drop one here.  Mirrors
-	 * the SKBFL_MANAGED_FRAG_REFS handling in skb_release_data().
-	 */
-	if (skb_zcopy_managed(skb))
-		return;
-
 	if (x->props.flags & XFRM_STATE_ESN)
 		extralen += sizeof(struct esp_output_extra);
 
-- 
2.53.0




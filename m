Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021668;
	b=Y7Cq7A3hrznnLZH7R6tMZzvgQyZVzV/HaS7nlBIkI1ow4xHxjL51yRFJ1Okn7S4z9jQ8
	 c6mfjvbun7nXr/L1H6znOCDASgkxI3LYi32yycSPKjYvmNtmEEsM+R+rH2G3mARcWZlTF
	 WwE8K+vLddjaDzy6zYcpzJsblQOyS4RBts3/GgDNFQStBtBeyCHgx6IqdRmqceJlJoQM7
	 b6ol6jVDsiB3EVKTe3SC0Rn+JU5axeOI8+I1QXlyndwle9By0LGDLyfJxj2XrMfjIR1Hr
	 5rsctW3BTmYU9Oa36azzYPBeOOboXMd0LRI9RPw7jIAMD1ZLluwXnUE9cm7fBtiStsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FO2xLzek7fhXPoYtCqmhhgJJa4Y+JkuUyZux1T8m0/4=;
	b=Xwk9UEqWWGTEKahYlgzi7+GZKYkuJy0jshyhqXFyGQraR4BFshUYgBvtFLS6ruudExCJ
	 Db7JBOpz8aDWKwBRckRkFVLmbuyw4K7zhsOv7ocQjMBvp8nn9o+TgRvb5znFPbl/okjNg
	 HVw5sjq5v+SGptaUKRtK6P2L58yVCWrDqVE6qizAPvOatCSZl6lyTV13Fp87jk60/V+yV
	 TOpMZ9N1rH4DmxV25CeHose8+a6vX8O4Hpp3plCU+7+hXC6JngHT6D2gEiCvQ0BUmUV9B
	 El1hjeDXVoQwxrDBfmvNHWGyQeDcBvlvk9UhKsYlryMaBV7O4kKKt6YwLm9763B+WUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzMjhRlo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBF8606A320;
	Wed, 18 Nov 2026 17:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzMjhRlo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD261F000C6;
	Wed, 18 Nov 2026 17:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021668;
	bh=FO2xLzek7fhXPoYtCqmhhgJJa4Y+JkuUyZux1T8m0/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzMjhRlogZ91oDJmDjOuD/cJ+8w0i4pPAKCaDAdpE7WhjoBHsg0q/gmbG6DH+ovBb
	 usi2//PrU4et01M5g3ej/vv0lBpqXpuprCURJk74Zh9+wJcZV06Kd9tf3cbeBxuhcC
	 gyOePNYudriyAs4Yw+z8IdMmuILNzVIZNq4ms+cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2362/2651] ksmbd: select CRYPTO_AES
Date: Wed, 18 Nov 2026 16:00:02 +0100
Message-ID: <20261118150410.586838136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

[ Upstream commit 2c36c4a86104d763ee798d4a89e2d3384b4cd626 ]

ksmbd allocates "gcm(aes)" and "ccm(aes)" AEAD transforms for SMB3
encryption, but SMB_SERVER only selects CRYPTO_GCM and CRYPTO_CCM, not
an AES cipher. With a configuration in which nothing else enables
CRYPTO_AES, ksmbd builds but cannot allocate the transforms, and every
session that uses encryption fails:

  ksmbd: Failed to alloc encrypt aead : -2
  ksmbd: crypto alloc failed

Select CRYPTO_AES, as the SMB client already does.

Fixes: a848c4f15ab6 ("cifsd: add Kconfig and Makefile")
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 221ec9717a834..622d8f4d27735 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -16,6 +16,7 @@ config SMB_SERVER
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
+	select CRYPTO_AES
 	select ASN1
 	select OID_REGISTRY
 	select CRC32
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056760;
	b=X71tgNaPV/mswvfJl1rC6U1uRgFbRpcO5L2giugAV/AUYQAJd6a+wnQFUK/KM53tBywS
	 tMhG4KkOr3G8qkQRssT7UwpUP/Clh7NwDuKe3siaxcdLMZMJDt77K+jpnUYtzdKZxOfmH
	 Y8A9+6fSdevT1DH8ove/rT5a3dxrqW342s9kfnX2FlDVv+Fy1mrO41SFLk2SmoAmeRdgc
	 LMcMXAMKK5S+GcSeBWnz5FdTDM7TWL4Jo9deMcCtwRLJlkNmHj6Xa8GbJyKtfDdKIw1l+
	 8LsR3xsqRe52OX31LsQLXSj/G7qsOXdyL//QwH7NiDgw3GsGp7OYWEhtNdq+IasBUrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LH8c58gUGD2NAilGXIxIaXZljO/0zY8pbe0SMXUy8Qw=;
	b=tQ9lL0AcKpaUjaTdpDItknMCltML5PwRW0/OjWrp/xigOPk3BdrDxxoF5hGqwGr3uT7Y
	 B2YPe0/Dj4Wk5NRuqrgeWuyJ9jXyMsgWo07Kibq5k9i1ybyVOp2/3DyvN8fX9KwUuDdVK
	 ZqhVh1iBGHT+EWCWXYY04+1SQiYNl5PlSPmS3Swj0v78Y5d+7f8yenuWv3zRFajZi1c0U
	 jH7uz0scnmwoDbnvQMgO9lAQSpY18naDxto2MrgDfUc8RRY2J+Gjhcq4VmsHJ8vJwPlMs
	 wWKV+YfiZ3SofBrK9llIWz+0iKehzHIFo1EBuLD/X/axf03QHt0BrTQDQDPylpxNy9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4Tu9n8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE00606A31C;
	Thu, 19 Nov 2026 02:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4Tu9n8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157BC1F000C4;
	Thu, 19 Nov 2026 02:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056760;
	bh=LH8c58gUGD2NAilGXIxIaXZljO/0zY8pbe0SMXUy8Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4Tu9n8erhuJIGNLq2dsJGsT6TazED8Jux3a7ZdY9ETqM5J1SsSohzsKjL1OaipUI
	 95C+1kH3QH+OBP4GM35yn0MM0zheveuZd5RTt5TnplnPdOBifAm980oaTrUbnLYFw1
	 2/Yi29fLTa0dO5qzsIJ8xAep4fGpbeZthKC45iqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2103/2214] ksmbd: select CRYPTO_AES
Date: Wed, 18 Nov 2026 16:02:59 +0100
Message-ID: <20261118150134.778532319@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/Kconfig b/fs/ksmbd/Kconfig
index d036ab80fec35..f8973aeb3518a 100644
--- a/fs/ksmbd/Kconfig
+++ b/fs/ksmbd/Kconfig
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




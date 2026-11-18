Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032754;
	b=RNSGjqKXwymQBAg+0VGvqfefnHYcj0AqxFTLKATkoZbiDEnadPbK6p+Faz8eend7UdyT
	 qbZDlVBBrfHqMLTiQO6hpRfTmKXPMWTZQeglQdvRTR7XLFaFZu8QdGIhcUa23iODrkCAB
	 OS/IIlO9eHATR6fIRWqQKGRbTJy0c8t0gU36c8PhKPiTqutrlpRcOHrbIrcZC17EakkDA
	 mNdcxuLrNgedRNdp/3M87Io8QtZQUAQHMLoypDhTDqBgGNQkVYkxrbwufrQrT0cwaikYf
	 rn7xDt5l9A1RyqtfOsvi/q4Xi6hbUkpRmaqJy3TsYE2zfE8Yxxd5ohe6I/NQ+lXZXtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OxV/FLwFQ92ZL6SVsRjpJTbgPCE8BW7kdLVrMV/nZng=;
	b=nTHskdiHS0ODHgqQDZrg4FkmkHA5bQzecd4kvRxXCEObGnaK7LzawPn8vlyDzQE55LcT
	 qfqSGGtWx1gOjaD13lN1DEnKiiZhqV00ibhpKq1muboq5SI8BMLAX+fCytH9tn8MKBRgM
	 zAyDleNDe/3fmh1keFWuaRzh+U0jW0PntZOiZDkzeuazU9wZbdzD3EEDK4MADyFkOQEao
	 ai5xc/nSJfnZYrfjtDRuA7b3Z/0tbKEGkQ/F8H25yoCdjIY4ko8XCutwBfx4aNp7bCmw1
	 dZxY/nXZekxGYTaf8wDKzqRAM22lPSDR+G1l0fWyfbFS6A7VYz7f049j7Zt/DgItEAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RJdk9UJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6586F606A325;
	Wed, 18 Nov 2026 20:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RJdk9UJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1291F000C4;
	Wed, 18 Nov 2026 20:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032754;
	bh=OxV/FLwFQ92ZL6SVsRjpJTbgPCE8BW7kdLVrMV/nZng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RJdk9UJMJnDy/BuRT9yr/7FVhKm51Cuu83PtZ64tYKnqn7v3a9mTrRzopukdfmOn
	 +baRKkA2ZJmYss7CXQrhD+kjkvsr97WShm+NBhkQVh3DvW6KNyyCdnj2CwIPZddaBI
	 IjLIc0+tOkWKaKWU0fxy4/V7nq36O1I2YlyUiMYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1525/1756] ksmbd: select CRYPTO_AES
Date: Wed, 18 Nov 2026 16:00:52 +0100
Message-ID: <20261118150109.555016365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index da0187e76cf1c..57aab102675e2 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -18,6 +18,7 @@ config SMB_SERVER
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
+	select CRYPTO_AES
 	select ASN1
 	select OID_REGISTRY
 	select CRC32
-- 
2.53.0




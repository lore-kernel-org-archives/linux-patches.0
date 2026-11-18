Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027922;
	b=q2BLc7O0jPk6QicS+M1JM3thJKEpLBPaUANCl+L4dtsanpBzLJ2G6nWIYFrxGprGWY78
	 a5GwnAwmimNcIiKsIiPC21ljzAz58+EpwiIVd6ylr2YNk1cvUdlZtHOPXqez6udpvswVL
	 sW8EOvfy40plbkqQ8GKUMre5DcqoUvla+lA8vrwIqAdAdml9SYWJSqZ0e6Wp/C6C5yKjW
	 6JNNuj2qYbpBtY28stO/Z1TZZ1PK9QWrUpkZWxaiiH3Wl1dUzrRRb1txe+a62MfR3k6co
	 N1O2OgLw7E3DNENo5IWlUhfFCjJGHBxi6GFVcTc8sbTXuzxYbVNwX/BKrYt4XPjlXdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ShKgzbsrdtvTyOCD73qZaSNYN4/MmhsGeZF3hIZWzMU=;
	b=OdPGiQnX4YIu6mcW8k/6kx61qKMjUWNIh+Rw7FIGSfPtbfaiYn3HLN9Chg/kT36QGM7w
	 fjj+l8oTtrP8tfHUCDOxvPlbQV1xj7/8J0bOijaz4cC6+XYq/T/wkT5SbObKQonAYIJJd
	 L0bSvczy4tmy2oYk4IbKZjNMGQtKggrnPN5MMso8TA+YQk7rWRvwnVKnI6Sjzpsbb0TVQ
	 BM1+0ttiYldgX1YtsOSVw9KQdXdMf2Hp6zX9l4xmA71UirRtUyiQWoami0zZQW/n1ifcC
	 +mHXKmbFqgnteYKFyYp/MrR8NenTFzBBY+OOnRrP4f2mAvBRh0rYDTZTyMsvOjlty1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjVTOp9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE67606A320;
	Wed, 18 Nov 2026 18:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjVTOp9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E101F000C4;
	Wed, 18 Nov 2026 18:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027922;
	bh=ShKgzbsrdtvTyOCD73qZaSNYN4/MmhsGeZF3hIZWzMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjVTOp9VPWt2m/EUKkZyj4nZIIn1jEG9Jw2vnmU5sXjcBpm11XdON2HUp01ebaOC+
	 loL5SRpCdBnGPzH4YyfuFd7W9Kwe3tvv8Rn3rGTCQXFfP4iK1l0Ve66bLtUEO+bkUo
	 OvBYDNrJz/QEQQNpaeMQqY7G6Nd2O2iBgXs4mfXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1909/2151] ksmbd: select CRYPTO_AES
Date: Wed, 18 Nov 2026 16:00:44 +0100
Message-ID: <20261118150231.327881270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8b91a6323d936..4273783a3b4c5 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -17,6 +17,7 @@ config SMB_SERVER
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
+	select CRYPTO_AES
 	select ASN1
 	select OID_REGISTRY
 	select CRC32
-- 
2.53.0




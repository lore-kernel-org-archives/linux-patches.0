Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052AE2DC792;
	Sat, 12 Sep 2026 11:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211880; cv=none; b=NmDiRQYvgoRrShm2X4816FKzV3WURMB9azqJBWyE6AJueE5ODhAa+QKo0ZSDHe/CdIgMc1wwi5iqKa2fPX5jTHalE4O090tgvplmjjpbRgijvMH5PcaNJZZ0PIqLY2E8qozLyOxK9AYURiNeL+ThuC0p/VUE86zkl90uAYiK5nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211880; c=relaxed/simple;
	bh=WGDqMazBPZJJwVsDdeQKU1gbQIKWcZ3S+/ngLWApc8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ocx1ZGg0NKCkIRkG8hMwkyrP6pultZa49gYf6WcrcyzfMFZtD5z0G2Vph8DDQ1vDb9ddR4bid3aHUrT6GwoDGCV5iRCvK0nRtc1FkvbsZagfjhooqs3xKH1C6SBCnbM9UtqgU6TGCMRvzN3B1bOjLXuEMRO6hIvi9/M8ayi3xrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUNVu9rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUNVu9rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7DA1F000FF;
	Sat, 12 Sep 2026 11:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211878;
	bh=QtZ1lEwKKVsLzkK8Ndy7EskSgtYsrt4Ovztd/WQYIwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUNVu9rhcp49p/+hsOUDCi5IPOhr4M7OTdGwYLiHXPvgFjwUDwptxCS3hbYDelMGu
	 wGSWxFddRnCARulsAeGD2zFaMB7KnA25xUDYKr7kKylEuqlKtahVoMjOKSexlCsKDZ
	 NOmqWbFPBqF2q3w2wwoPUvg53sPZa+sj1oKVB5m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1321/1518] smb: server: Remove obsolete "select CRYPTO_LIB_DES" from Kconfig file
Date: Sat, 12 Sep 2026 08:58:10 +0200
Message-ID: <20260912065653.412944553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit ed91d80242358ffdf127a34e3b7c9fc445c9e5d1 ]

The DES encryption in the smb server code has been removed in 2021
with the removal of the insecure NTLMv1 authentication code. Thus
we don't need this "select" statement here anymore.

Fixes: ce812992f239f ("ksmbd: remove NTLMv1 authentication")
Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 12594879cb640..8b91a6323d936 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -9,7 +9,6 @@ config SMB_SERVER
 	select CRYPTO
 	select CRYPTO_ECB
 	select CRYPTO_LIB_ARC4
-	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
-- 
2.53.0




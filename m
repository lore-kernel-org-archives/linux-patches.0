Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E578437CD32;
	Sat, 12 Sep 2026 09:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204670; cv=none; b=JlJd/kUgq41m/HCOPYLUeRw/WiTo8Ipnt0RcbKwPVMdE5phP6pHyQaK1/DMhiFD2B6iHv32i147ljQQY4OVE9FxIyHEdtT854iMoIukycZNn9YAHUvgvuTGy4LJ9Yh3yZc2Q4y2lqPw6RF84IeJJL8lvWirhmn4yVa2RdZxz3S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204670; c=relaxed/simple;
	bh=1tcFMhBU1C5+FA65Tiq6ETT2952P+0PLIHKNTAJJjIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sh9p82v00+La6gqqHfsK9MMtYoevCot6sXZmiQhbub7F+Ym6b/gtU+GJbFzbNf9HmPHl7D+zadYbXGeimDFWBywu48Y/Vs74tFSdLfNJTVwQEOx6xHR7WELkcF0JvLPLhcmFq2/9GdU7PYw3OyzDRcrMI16SYVcibJad1IyzXvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0VFfknI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0VFfknI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F761F000FF;
	Sat, 12 Sep 2026 09:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204668;
	bh=pWSM3ikYj0AsQmHtudRgBD1F4i8hEEzl7iwcrx+8AUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0VFfknIwYyZs4WWSyB2qhNVH8Hxl8m2CoKV08MypPhtbB3I4Q2vE/jyBoTiY0oNh
	 VXp1uN1ey6hmR5lZFD3yU8QdPRE2KcbERGIvb1PruUaw5NWRbci2tSNXwB3tDWFiLs
	 FsiOGpsLx5xGAZuBruukt39kdzU2ySo/DIrTYvJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1661/1815] smb: server: Remove obsolete "select CRYPTO_LIB_DES" from Kconfig file
Date: Sat, 12 Sep 2026 08:56:51 +0200
Message-ID: <20260912065727.984599386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 08d8b7a965a64..221ec9717a834 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -9,7 +9,6 @@ config SMB_SERVER
 	select CRYPTO
 	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_LIB_ARC4
-	select CRYPTO_LIB_DES
 	select CRYPTO_LIB_MD5
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
-- 
2.53.0




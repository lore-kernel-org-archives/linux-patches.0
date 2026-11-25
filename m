Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620905;
	b=kBbdc0KOQGi4yFUscC9ovUKVCsxecGVjILkEGCMN1Wrr2+R4OSmN5baKoYRZJzdFG8uV
	 660PjYfnjxb7k6IHD6eHZ7P+Vcduk5s6/DvRd0eIddVtHoJyvCLF06nSYkaKYFRVpXZQz
	 Fb9SJrjOVJ6EmWnk9trZCXccdhXwJXRTeFH3mBxX08/XUdIWsl1ko78JSjAc1Zqprfs95
	 HEqYZhOyRuQvK0o6NaS6jZs97Omhog1MSIs+wdUsnlBxT99AeK0L5OLD0YkDVzYtz25vK
	 2WXAUYZPDgsZYyUwmzYpCSaP/VAfzgiKi3JoAwigLcwLhctFOrPAG0NM4IE44oU3iIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lCV67VZQ0xVttn2G5s0BMHBmbytW5bwU9N5sGd4ZOL8=;
	b=gGYJcr/Jihd3EjlVb1GjtIonYtzY+FASY4a0KTftUW3EB3wGeohlbBjfbqLK5/jhE8yt
	 1GApGT+u2sHeCKITTkdgRQC2Opt9bWiiUFb4Bkp3d4sOLePYYF8ZnlwnJ21rZoQlwMzRb
	 yqqM/jowf6xoLehCMPqZfJfznT7gzwlkLxo12qgEu1TUJz3CiXdPb2lzqgJ9Bm+imELJ6
	 Q0+QWyIfJMjp3Z/ILk7XRjkt8PDAeNqK9xUnVnOlTKwrXNN1Vye0nht2Y4totQLuf+7wC
	 55sJs1FnSIPaVT7RMUu/pMdjGACSqfhZsZtktEXlNXRD5dL98MPTD/3A2vrF32H/agw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpfBiqEV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3DF606A323;
	Wed, 25 Nov 2026 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpfBiqEV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332F91F000D1;
	Wed, 25 Nov 2026 15:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620904;
	bh=lCV67VZQ0xVttn2G5s0BMHBmbytW5bwU9N5sGd4ZOL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpfBiqEVFVMDHCMZnPDBysgTyA4trt+EqMkPJpMY8rpIKUMfHT/XmO5bKT7r/5bqt
	 BMUMe5R3g68hrEZozcMYMsChF4Y/ntFjt+WiC1JAoxqucTGGTJkVqeH8xwmgzZbogW
	 1/ZCeXBEvIa36OJl76sUD/UHaBRPhyfa3jp2vZIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/990] fs/fs_parse: add back fsparam_u32hex
Date: Wed, 25 Nov 2026 15:23:45 +0100
Message-ID: <20261125143823.445383629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit 695f2ca1b4247724576d57eae7b74b90dc69ba3c ]

296b67059 removed fsparam_u32hex because there were no callers
(yet) and it didn't build due to using the nonexistent symbol
fs_param_is_u32_hex.

fs/9p will need this parser, so add it back with the appropriate
fix (use fs_param_is_u32).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Message-ID: <20251010214222.1347785-2-sandeen@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Stable-dep-of: 37dce65a0b43 ("9p: use fc->net_ns for network namespace in RDMA and socket transports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs_parser.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fs_parser.h b/include/linux/fs_parser.h
index 5a0e897cae807..5e8a3b5460331 100644
--- a/include/linux/fs_parser.h
+++ b/include/linux/fs_parser.h
@@ -120,6 +120,8 @@ static inline bool fs_validate_description(const char *name,
 #define fsparam_u32(NAME, OPT)	__fsparam(fs_param_is_u32, NAME, OPT, 0, NULL)
 #define fsparam_u32oct(NAME, OPT) \
 			__fsparam(fs_param_is_u32, NAME, OPT, 0, (void *)8)
+#define fsparam_u32hex(NAME, OPT) \
+			__fsparam(fs_param_is_u32, NAME, OPT, 0, (void *)16)
 #define fsparam_s32(NAME, OPT)	__fsparam(fs_param_is_s32, NAME, OPT, 0, NULL)
 #define fsparam_u64(NAME, OPT)	__fsparam(fs_param_is_u64, NAME, OPT, 0, NULL)
 #define fsparam_enum(NAME, OPT, array)	__fsparam(fs_param_is_enum, NAME, OPT, 0, array)
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054438;
	b=u0tygDoVodoiuWYNlKtb1jSVgBVg/ArPT0trSo01OON1jfR9ST6U5p9CjbRrv8orv9Ez
	 /ytTUEDbfKK2IBs+FjcrieJ+TfhHgGYSBohm5eK0/LgIUtPBudCxp25B5TbSJsggrba4A
	 YhuV72J14bFyU6nWATlMNFfxD7lY6p/R1sJ2dWEa+myUN6uRPWkEyyDPqPEjmXIuCtZjN
	 Y//sbCdHhzyI9Ou/W5HaO4tW4/HB0kZVjJ2pPX6B6+06Nqd316n4ELR6G7kt83Iqed4mS
	 m5ocQ7wmVHMeVm5Ln2F834sOVk4Boac9lUQrDa1BfjWbo0vsGHethshC1UfUiCpg3hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KjlEmd8CZJu696aGimHknx+zzZa53j0zJpXY8Ba1+8g=;
	b=1jETJQWSKWuRBUlaQl3GXnyhzzKTeuxXt/BosWdtIvaOz5qMvWJXTLZ4Y5rgKKNmPjyt
	 IU21dCsWRSbvH6U8TLhvEaqbIdsfKG+oZwkkYJQalRJsJ6diQ7Eqc2btxAz8AoEelHoK7
	 +MYZ6vr+Ybtsk9AoUR64FwWltFFgDOOoY3hIgyJdGNKZ2BZBfYMsk32b6bcrfO0tjf3jZ
	 yHQT9bsQ4gjiXXJN5cRhhKo5XYVBdKqEVYtPbhCncrpilEP3UzOYEfVb4qbMKxFjv17CG
	 wbA3BJ91kKvyJ12AuGW0emxIdxjmCF9LyV/rpZJk91rCO84uWVdmc0XCk+HisIVLb/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGMxv19e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715C7606A31C;
	Thu, 19 Nov 2026 02:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GGMxv19e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808C51F000C4;
	Thu, 19 Nov 2026 02:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054438;
	bh=KjlEmd8CZJu696aGimHknx+zzZa53j0zJpXY8Ba1+8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGMxv19eORtXEijPPiBia+OvPrbJ2Axiq7KM6Je5RClPQatKMrX41TtHgz4RyIuat
	 KxSDg1AFM+iv+VNgtsLT2HHEKjR0SlrVHv30CUK1YrO+w2Ux+asZLlRvYDSJwUNCCW
	 bpHFIuJTUXYVhOqCBUdbi9pRJ0kZlE90/dWUY3AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1247/2214] tools: linux/types.h: Add 128-bit integer types for arm64 UAPI structures
Date: Wed, 18 Nov 2026 15:48:43 +0100
Message-ID: <20261118150101.583164536@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit 10a47fb67340bca274276faf855d7d460afd9a7a ]

The arm64 UAPI exposes some 128-bit integer types to represent things
such as fpsimd registers in the sigcontext. In preparation for defining
these using the '__u128' typedef implemented by uapi/linux/types.h, copy
that typedef over to the private linux/types.h header used by the tools
directory.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/linux/types.h b/tools/include/linux/types.h
index 6e14a533ab4e1..ea28a5b5d4979 100644
--- a/tools/include/linux/types.h
+++ b/tools/include/linux/types.h
@@ -23,6 +23,11 @@ typedef enum {
 	__GFP_HIGH
 } gfp_t;
 
+#ifdef __SIZEOF_INT128__
+typedef __signed__ __int128 __s128 __attribute__((aligned(16)));
+typedef unsigned __int128 __u128 __attribute__((aligned(16)));
+#endif
+
 /*
  * We define u64 as uint64_t for every architecture
  * so that we can print it with "%"PRIx64 without getting warnings.
-- 
2.53.0




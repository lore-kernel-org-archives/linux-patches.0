Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064494;
	b=hk/wdHJNRJ2aQR923CXerMx/yGpuDI2UjrqNho0H49U3hLzfWVY+zTDmUYUZ5xtr1Zr/
	 LqhS35MPt4wkq7Co5DF/QaP0IgW9XSJYvg2C6Jqmj/HANiYrjohRzv9XqFKxdC8WKdU4G
	 aATzpBBvgK7pMeE+o0xWM29N3w8wrOq7pu2Q6Lmn+zutKxwVLFX1iEd95+l420+BHEdD5
	 Y5cCZ18GiY54XiyouWSCEOEQcyx5tY79qT0s0yMZVPnP8mnW8L2loWtNtHc+M2H0GI798
	 lgmtpwB9tp7HxiOQs4UYZg6pnP350oltk5gFAyEFzQ92N3QaaaLsVXsz9S2u5cmxoZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=roIujy7e8uhMk7YfHwAwxSEaKuHxbfb33Csgq+qOOxc=;
	b=cIIZnke9OgJtJXsdAP/c7VezTQAPaSeq+W/CgX+2wLyrWwToPVZkcvxgT/aNPMHJMfR5
	 HcBqdbEBMlyK5L18ft2hVwH6+IXHC6jA3dmYyCkY5Q4qyI5IUgGJwrXNCqUcrhZBW3uD/
	 aYfRXyufGAbr4pzbddCFl6DHXEcM7FBB6tIRJ7AIe7ZaaZwyPbhbk/nvVUQCdsPCh98gq
	 cd7dE+EXG/6zPPQpevJj4B5WL42giPl7KwQBChr79BGMjv8H0H3aWEye1476eLWZA2ock
	 PDOXIJGdTz7rgTE6T3/tLi759/bUzhc2H9s8zc3vsz5nAdhgQYQpl5JLalyU4YpOR9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axXAQolK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C088606A336;
	Sat,  7 Nov 2026 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axXAQolK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1161F0089F;
	Sat,  7 Nov 2026 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064494;
	bh=roIujy7e8uhMk7YfHwAwxSEaKuHxbfb33Csgq+qOOxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axXAQolKOz0sbr0z7TcbvSGS0+xMDSVHvq88PvDDotlEzELt0amcbAyHlvaA9k/4M
	 FFjoJKO/O3Elm4CURLECKduM1SVhOYCDmBc6LiXqhW0JEdQkCjQ3GcruBVpRd49I8M
	 QD979zNfu/h5LS3D3V6LPmhfNDRadv3bPzXn66HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0529/1257] raid6: add missing vzeroupper to AVX2 code
Date: Sat,  7 Nov 2026 08:47:05 -0500
Message-ID: <20261107134954.021213951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 24f1241cdb056fd630e6710a916e0f7c8c910a70 ]

Since the AVX2 optimized RAID6 code uses YMM registers, execute vzeroupper
before returning from it.  This is needed to avoid degrading the
performance of any later SSE code that may happen to be executed.

Link: https://lore.kernel.org/20260831212308.213855-1-ebiggers@kernel.org
Fixes: 2c935842bdb4 ("lib/raid6: Add AVX2 optimized gen_syndrome functions")
Fixes: 7056741fd9fc ("lib/raid6: Add AVX2 optimized recovery functions")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid/raid6/x86/avx2.c       | 6 ++++++
 lib/raid/raid6/x86/recov_avx2.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/lib/raid/raid6/x86/avx2.c b/lib/raid/raid6/x86/avx2.c
index 7d829c669ea79..3cc2fe7ac42c5 100644
--- a/lib/raid/raid6/x86/avx2.c
+++ b/lib/raid/raid6/x86/avx2.c
@@ -67,6 +67,7 @@ static void raid6_avx21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -115,6 +116,7 @@ static void raid6_avx21_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -175,6 +177,7 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -243,6 +246,7 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -334,6 +338,7 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -444,6 +449,7 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
diff --git a/lib/raid/raid6/x86/recov_avx2.c b/lib/raid/raid6/x86/recov_avx2.c
index a714a780a2d8f..820871046e305 100644
--- a/lib/raid/raid6/x86/recov_avx2.c
+++ b/lib/raid/raid6/x86/recov_avx2.c
@@ -176,6 +176,7 @@ static void raid6_2data_recov_avx2(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -293,6 +294,7 @@ static void raid6_datap_recov_avx2(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0




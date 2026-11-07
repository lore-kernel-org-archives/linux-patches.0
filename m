Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064495;
	b=iQob/nc3Jgaua7vrnK0bxpwIb0waFygjr6uEzl+LLc1h+A4nlfDPyPfgDmwiyjR+9gb1
	 NlXPZXCZX6Ovz2dg4s8Ox3hwI0GqRr4GthTXA3zAQv1FFOBCVQk2BtvZ1LhW2sMn+NS6v
	 fDJaqlj5H7xK6PZI4AMpAWjtty6j3a58JbQqIfqEXgDXR5Hf8MPzc9IO5Vagph48cdli0
	 /0E60bUOZSegB2pdyFoz7PkfHXDA3LlH4B8gdZU+SXZP7zVicmOU5aqCx0YOiZseUFvdh
	 orBFN2TKkLtdoCDzfhQmyrEayylTpdyBcFzBgV0SXcp08Hl6qoA90xw8gQvAhmcHq3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5u8sF58vE4oWkBJhRE2RGCXEU0MpffrZgtBCpQPjltg=;
	b=fTZPCYPngF56x4rdiFXmPKECmfrcb09pWmtAJNHzJ9Z9/qmclLjD/Ey8OWWEgSFsZmpv
	 mEIslDnrvTDl6GrnUjWWc/Y0Edga0NKEy3zyXOnqdBGJZpJxbL2A4v1eRswKMw56wv70p
	 qGIWsPkv1tQtenghThSzMapt+Z1exL9JdBzpJDTjho5Kqtq7avNk9pM0t6bgLLMizfjGH
	 hgHhdrizug9sIsxUs0pyKhjnR1grfMikJN4tacYQ5L7G8SrzkkzvamOrptxDi3XaNxPzo
	 QjeNauLykiPBe+pyRkODgjGpsdX7Za3xLpVCySxM5UBPCvHg3WD65H9t+cFDG/wGCSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjuISdFQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B646606A9EE;
	Sat,  7 Nov 2026 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UjuISdFQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC191F0089F;
	Sat,  7 Nov 2026 15:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064495;
	bh=5u8sF58vE4oWkBJhRE2RGCXEU0MpffrZgtBCpQPjltg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjuISdFQqscrn/edmhgwPUm366zRQ2//rSe9t6Z9B5SugEEHLcclILFnipQX58Go6
	 7xs3YFE4XZQI9qqq68Y2qt1RYVjd0ec8M29y8i5aeSK1fvI/KuVsgjrIfCOv2Dr5L9
	 dDdAAou9gkg2uup2l614TvZiJ0qWVimBdsFE5+28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0530/1257] raid6: add missing vzeroupper to AVX-512 code
Date: Sat,  7 Nov 2026 08:47:06 -0500
Message-ID: <20261107134954.046941534@linuxfoundation.org>
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

[ Upstream commit b82cf9e49c1be7cf1fd8e1bd806b0cdd25ab8127 ]

Since the AVX-512 optimized RAID6 code uses ZMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Link: https://lore.kernel.org/20260831212316.213896-1-ebiggers@kernel.org
Fixes: e0a491c12968 ("lib/raid6: Add AVX512 optimized gen_syndrome functions")
Fixes: 13c520b2993c ("lib/raid6: Add AVX512 optimized recovery functions")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid/raid6/x86/avx512.c       | 6 ++++++
 lib/raid/raid6/x86/recov_avx512.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index e671eb5bde63e..772bfc4af6dfd 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -78,6 +78,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -137,6 +138,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -208,6 +210,7 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -292,6 +295,7 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -396,6 +400,7 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -529,6 +534,7 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			       "m" (q[d+128]), "m" (q[d+192]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 const struct raid6_calls raid6_avx512x4 = {
diff --git a/lib/raid/raid6/x86/recov_avx512.c b/lib/raid/raid6/x86/recov_avx512.c
index ec72d5a30c01e..299a3f044d616 100644
--- a/lib/raid/raid6/x86/recov_avx512.c
+++ b/lib/raid/raid6/x86/recov_avx512.c
@@ -211,6 +211,7 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -353,6 +354,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590885;
	b=kZhrOrS7P90IV3emXlBahoACg8NXXiS8Ffxwx04IcNPHm+49EWZjjiXngdpc/kvimSI+
	 v8dLd3ewT/kmHyttC1cMtrH+UARl1VXncgL12J66khuBvkOZq+T34L8LLGNxlR0BPSAAp
	 z/29LWlnqUp+63hpRCnTywdMZk4advP0G5nLUB8MJRvXDfm6QopADgQkTm7f9j4QP9J8S
	 /Ozg0R2luUJDGvgWYVgKNEQBIMDnGOA8M53elgvk+U9E/RpkIcB20AUiy1SEVhJ8Hb6s1
	 I2AGZBQtAbuI+Xf6i8/ZfiOIlGC7aGAKR1aSxZdUf/UPoGb2UGl6oQnioIyyFqf31FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a4KA6noQtw3sh95VcR3Iakzy4/qrMRHGWVRkPLXpnCY=;
	b=2CbNC9Cd8j/I/lqXv2k+DwB2OpvHgbOTna2ta6F+K0aKPn05G9N+dnCdawegNtGBS60L
	 9Tq3g1YVaVGbr+FCoaQjEop13NdxXTlX9sQLE0xQBTYtjps/DiqiCckx38EzxU8B2Vxwo
	 KN+DJ6yVNQO0GfE8EPRt4PYDo9xZRDEMgv/GgMvFKA3W+whLjA3QKm5xlf4YVlqXY3k0C
	 EfYnX1JVgYYVdWGj9taG2/VnKy4w8buXcI7VrIOXV2T6camNlAhmrcwn5PwULCHBBllhV
	 Krp/sQkM5NNSzDtC1jBNUVLCt6jqhbJhoOYaBiMMjs2eGIxokN//5ELzzqwJPINV9VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHQiH7Du;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C94A606D875;
	Fri, 13 Nov 2026 17:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHQiH7Du
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDD91F000C6;
	Fri, 13 Nov 2026 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590885;
	bh=a4KA6noQtw3sh95VcR3Iakzy4/qrMRHGWVRkPLXpnCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHQiH7DuoMxgMDkQNQoAnJX0S8SN5t2TvHDiyD1NEu0M7dejWcuKb9cbbh6YwoPrf
	 VsMoHhFHEuKX7bnXbxftLGLqlAQbV2i7Ff+ejog76E02hfo61PpyG0sa8AT2eG8stO
	 pc1W0S1+bw6HKKGmqYgxcTwNiRHgiQSnu8oAgkDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/670] raid6: add missing vzeroupper to AVX2 code
Date: Fri, 13 Nov 2026 10:44:03 -0500
Message-ID: <20261113153814.345145677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 24f1241cdb056fd630e6710a916e0f7c8c910a70 upstream.

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
 lib/raid6/avx2.c       | 6 ++++++
 lib/raid6/recov_avx2.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
index 059024234dce1..2d03ce97f655d 100644
--- a/lib/raid6/avx2.c
+++ b/lib/raid6/avx2.c
@@ -76,6 +76,7 @@ static void raid6_avx21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -124,6 +125,7 @@ static void raid6_avx21_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -186,6 +188,7 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -254,6 +257,7 @@ static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -347,6 +351,7 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -457,6 +462,7 @@ static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
 		asm volatile("vmovntdq %%ymm14,%0" : "=m" (q[d+96]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
diff --git a/lib/raid6/recov_avx2.c b/lib/raid6/recov_avx2.c
index 4e8095403ee28..a7fd1ba177f1b 100644
--- a/lib/raid6/recov_avx2.c
+++ b/lib/raid6/recov_avx2.c
@@ -180,6 +180,7 @@ static void raid6_2data_recov_avx2(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -297,6 +298,7 @@ static void raid6_datap_recov_avx2(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053118;
	b=lI+T9iRiZyLTcbgL2G/uldJLDEEHvUgUBULSLCJwoFiW/XVk1Pveol0w4ERSqQgKI7fU
	 8WF98a2CkqFC4XyDCG2uT8N9gh3VQ6jxQT2//V6MOHWAtSWYvaZY5uYiyv7FV47Rl+BnQ
	 O7/sTZZRpQSrbmB0N9hVBmlCcTee/pW4+PnBUbmfu8nEGgRaJGI0yHSuHJBvpD+PP7LYb
	 owlU38PPhC6YAyh/NOGcz/j7kbX5Eficx/P1dvY1XAsg0E3SyaA+LgNzSgU8bWvlIDTuy
	 +IBwBty8ooTbEcE2sDvl/9Ae3Z9WpPgg3Pj8QMqsNAu0F8ww+14B+P9Jt5zng5161EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UcO1hQElMh4rcuLvpJm7gfFkSnmSsa9lqRvoWLVWFms=;
	b=Eovw0yC/qh5uxZspfGaDPO9/x9X42w4b04t6jxMtqfHJay4KVmXsVs9G+uHl7CGKGuDt
	 z/QRe0yNFuaMh03acVhc46rKqEmJcgtwpjsmvm4Q/qArwKf8Rg04HO422yJK/hpgMz7ED
	 ZfgiliRoyeVvBV3EJGVuq86krTOFerAskzmSc0KGdzyKdqJUd90iAWL985vFr5b/+W5Bu
	 o2nkmkr8TNYS00L1W4jV7ijVVju1lk9BSOjnKKd1rlpGQRSd565XbATcvonzyyyhp7s+C
	 LJpBoCfRWI5GVAOhfHWrq4o7Sm47umYoCFfdyQuRy7zyxVghZSdLCe+C0s0V23HNMOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbh9RJWB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F1B606A32A;
	Thu, 19 Nov 2026 01:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbh9RJWB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD151F000C5;
	Thu, 19 Nov 2026 01:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053118;
	bh=UcO1hQElMh4rcuLvpJm7gfFkSnmSsa9lqRvoWLVWFms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbh9RJWByio+HHDaYRq2wTvb9fuSWNCrxyh3bMYV/OtsSW10ytUs8IL+yAFCmwDKE
	 rdCZPYHtXv4rD8PEbz2Po2wb9S4ZuKjWcE93r2lGqNdpsLAydtyUuHFwGrcuPJFGNw
	 Iq8nBV1m1ae1OlcS3xO0A5srX6EwDK0p+yopL4G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0806/2214] raid6: add missing vzeroupper to AVX2 code
Date: Wed, 18 Nov 2026 15:41:22 +0100
Message-ID: <20261118150043.731611304@linuxfoundation.org>
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
index f299476e1d764..10f2b1b4d6a69 100644
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




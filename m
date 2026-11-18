Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046237;
	b=sT9q6uMPUeYB24+YnYenR9MgiG4RKleOM1C6/jhhoS2l8/oIgLMKXKTNuewGbApjOhrn
	 8wvIGSv44sqXB4Hi+bx7Q0aWNkgoqD7pCoUebScJsFX9WwLRTlLu/a8n+BjPZFooUXfL5
	 Q+p0cFVQcJWlm7H0bMSVVdN47yOJlEr2SwkGQ5UHPtWLFJHFqikCYw30ijDVXA1Ob9ZoO
	 FkjsEfXQYJ587goRJO4ly19puLoOrfMkIXLnoCEXNiZw6qFvm2TeWCYt5Uaivwqi+DSW/
	 Pg6zp4namceZupu8Y5g+I9f7b1h4o8pRbZ/PxGrDeIXvbY4xJwR0ckR5LraNYYxC4Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DqZ1o6xrCzFSlRTe8TaDSkJSuUB/4a4GwtdWlaPu5S0=;
	b=3o7fN9i9af6KcE/0gzgeF3wtI6un1I19hdZMLtvFiZqLsr62htA41GiGkhSC9f6XCm5x
	 /swnORHucOG4v9beq3ER5xONbXX+O970VUuvnolVeQKHoGfFXeOL1cKBzsidQmw+WIQmi
	 aTWijSKwanR6xVMuPmA8hLCoblQYrb85Ix64MWnlolzw5IANJ0oEkBT8LJfNRZVZRsGhD
	 SvA00gMYpk7mLsefQkRvUpSYlet5duMaAMUnSyXMT2JUIkjjBFg8sRTaHEgNqimyQ4qoF
	 xB546GMe8sFe67xPqYS/A7Ce42etjbp4w89NMHPZVu+SQ0fNvYW6oYIzFnykMjbsemQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mCoupnM/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0E4606A320;
	Wed, 18 Nov 2026 23:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCoupnM/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8928B1F000C5;
	Wed, 18 Nov 2026 23:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046237;
	bh=DqZ1o6xrCzFSlRTe8TaDSkJSuUB/4a4GwtdWlaPu5S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCoupnM/7d4lDpP4pDFl2aX4Kqhqajo6zIvEL8jl//3y4R3fUCR+9Oo+QRQ5jjsj7
	 qZ9XMfuWzO8EyB4O+8WY64vYWECSUYcQOW4qUh0xEtZWUoGmlsVYec2+iVn2H0YHkS
	 vKTku/bTXg6VPhuQfx6QlsAVn34RMxz1Q/u7CXaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1159/2857] raid6: add missing vzeroupper to AVX2 code
Date: Wed, 18 Nov 2026 15:36:33 +0100
Message-ID: <20261118150243.316617991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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




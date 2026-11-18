Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058909;
	b=lvMUEF3XjZoiU4bRduUus8aLHqTpFio96q+j8XWhPnAKfKNkDsH6bWeQk+5bn0b8q94L
	 YEPYmfafpveKAOvyOznZUB9FuxUBEnUlGPSTEQr4iWS/+c8pgJTM/gdLI6NJSUlxlJOsV
	 iSfdnx5CO47/p68o8dSnAKuADOCFYnFynggIHLEgRcjsnVt+DzUzAGQFmdIo6opnGfXlC
	 0jVPNKnwbJGxCGHlQHzasagBh1keR2NWZG/RUwL6zyRmU+WFMh5bqfLlh5CUltJW8H0p1
	 V48VPbNtPw4ScbpYXB8Wz5iqN7GVQ/LXIMINgfOtY48M1AFRUosW5xEG1AwQd/uNL6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hb22LrHRzVtYMoJ6dgSoRDS7nKdYQovkN5w+CQzoyT8=;
	b=k0JdrJ/xBJpm5vq8rE7Gkmmmts5MaCzDvlNB3ByEqg034BMN8qMEy4yAfuGC3Zq4ksij
	 dCZq95A9CyftSiitrmir+NC4QxdTfQA0ul8JnZqaSYJ9ijsch+eLNt4WznvVVhFdEUgG6
	 54QHIWWgq7SIpTbkPfDvhIi/tMVU/LjFfZeDZ9zoti+X2njWKhDL+veOeKUbZP7bc9nA4
	 pRzDmwn0VG3QN2LYaaS2rKJh68el/0FtlIkS1kVh5+qR5Dc+FladkPC+3XLJV+AuqzoFw
	 npYqSySmPwX28H4b17vrZbxu+MRAdTx2aDSuQuHQpVXMKHhUnGP9nmVfMADnCSD1rgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syFLIW3a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161DD606A32A;
	Thu, 19 Nov 2026 03:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syFLIW3a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FEC1F000C5;
	Thu, 19 Nov 2026 03:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058908;
	bh=hb22LrHRzVtYMoJ6dgSoRDS7nKdYQovkN5w+CQzoyT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syFLIW3aoeVLj6F4EpGhnw0Jq79ALI6uKCjDd3EldD0nSv1eSG8QICmgSgCbm4kvD
	 uWp0IgNXAAJopDsUn8PNuprGZsRxiaT3dgPVlZSZ7SAq4rHp+L2mKcTLx1zKLlqznQ
	 ctbvtLJHvxPQXUZG6dmhtL6S1R8LjCxbj0Cqqz/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0653/1848] raid6: add missing vzeroupper to AVX2 code
Date: Wed, 18 Nov 2026 15:44:51 +0100
Message-ID: <20261118145943.136370967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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




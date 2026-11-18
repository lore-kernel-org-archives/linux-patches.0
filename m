Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058883;
	b=th8+g2uAfM5038gdKxYiF70lTsQd31X0lwl+VMNTpHkb0rYBxqIMV3A4a7nMLYUmufoV
	 FbDSrwK9V1DWkBu0okwPZrs60bGMe6t5RmSx50Q3VXfn0u5+tk64PFP+S3McKrbPsTnsP
	 /JtGimXyIjagsyCss5hy2ZqzvzBT/rViWBF3X4TouKhG0kkhwwnWjEXn6LFMAOWGUQLke
	 598AThh87FZH1Qv+BlYwZDzVTVr7cW8sm8DZdtIIl+BpxzFtZl9LyLW+aqJSspBJlFg5z
	 OsZcgeOYtxeTFYyTvoY1O8C3TA1BexQ2VNMQrjjmdmi9bxWifgjBSIC8B5w/hcDXQxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RD747E4rgsWqnbZ8+XDBicyA6mOQN+vlq1k03UKBJgU=;
	b=GoHaw2RQlyFWqSX7r7IgXbAZcxq4fZJt1QRFHvclr/8BAwMFbjCpcIj2c4Z/taSujlZ0
	 pXC0Ns8xVsjQIc5X84vp+UlX2LRJew4YBIpdgNPSKERDANTP2u40y7mLYh3S9WkDp5R7F
	 dMSAa+I6+pZGEbZTGVXeiLbMJfVLiBSlEpnZaZx383K+Z9NmFdNiu9n9A4EYIDbsKCnbr
	 0U/uc1bX2e+q56XfuDp6rFADGZqcT0AHpgzp2r4ZAAqTuFfYzDFyqcQ8y1KoliMu8QKWT
	 UXtFz6OfYL855K1TfOople5wTMidu//wwviDiznsHcJJuBdJJFVIWbCTd/3aOailOfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYCXv29r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D486606A326;
	Thu, 19 Nov 2026 03:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYCXv29r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAFC1F000C4;
	Thu, 19 Nov 2026 03:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058883;
	bh=RD747E4rgsWqnbZ8+XDBicyA6mOQN+vlq1k03UKBJgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYCXv29rhfOeigwx0j0YO0I/n6Koqx8mvOllAOsdL0R3coN3YF4UdN+P+woNcVv2m
	 5NHao6scFby/5RBkyJTvaMvw0eSMjjt3lYjUfG+VV8o4Br4vGY8N8+Ag0lK5VkCMKU
	 tcW/43HS2rTbGxZImP7R0n8vXT0WUm79hMMa0r5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0645/1848] xor: add missing vzeroupper to AVX code
Date: Wed, 18 Nov 2026 15:44:43 +0100
Message-ID: <20261118145942.749907953@linuxfoundation.org>
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

commit 7b8fc26c40d6cf4c6751a045c9e42bbb7e78d81b upstream.

Since the AVX optimized XOR code uses YMM registers, execute vzeroupper
before returning from it.  This is needed to avoid degrading the
performance of any later SSE code that may happen to be executed.

(Backported to the old organization of the XOR code.)

Link: https://lore.kernel.org/20260831212248.213805-1-ebiggers@kernel.org
Fixes: ea4d26ae24e5 ("raid5: add AVX optimized RAID5 checksumming")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/xor_avx.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index 0c4e5b5e3852b..10b703dfc7c43 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -49,6 +49,7 @@ do { \
 		p1 = (unsigned long *)((uintptr_t)p1 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -79,6 +80,7 @@ do { \
 		p2 = (unsigned long *)((uintptr_t)p2 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -112,6 +114,7 @@ do { \
 		p3 = (unsigned long *)((uintptr_t)p3 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -148,6 +151,7 @@ do { \
 		p4 = (unsigned long *)((uintptr_t)p4 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0




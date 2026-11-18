Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037254;
	b=TRbrwz1lkUZznALN8FHTFkKz9fr1Cnh5sXp0wn6GgWUlcvR5jnNqkBNC6IXV1LiZYuzl
	 RLygOeIVDOVhr2UxnhCM0axdbNNXZKlBtkj0b4I4YC1ihGIdpic2Q76zb1yS227/ryU5P
	 OLrvLf7LSwotQZFRLW+51RnHFYY6a9YL2sNOlMV6ICsEO0EKu20ZB7zuTFqrz42+BpNiG
	 UbHxSb/nOzbGCqhEFiT4gp4PvXhEnCRj4Lb2T3OnTEWj13zrGWk6Avf/Mz0ah7Mi0rTPv
	 Zod3ViTzE8THv+qHfF11WFErbdFrrfPZFgk3+o0gZlD5OTmT/NdpnIjWiaeMpnpNr4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9rZgjPOt/n1b3e7PoVUf4RUa5Vod/8QgxQDvNPzDNTU=;
	b=4b+nPmxLLIdyAeMi0PBriMn6qviXqyLRzP8T44D4zqaTNlU6D27LUGVvI3VaLWT/8NZo
	 rboCZv/EJW0/hk16v5UdTrigY4Iaht5wvB81ZfLZ4MmbcazJTb4k/QWDa9+Ne6eV6XAtW
	 nrDVwuqW6Wa9OQBkxgwazOeVN6qrzG83xqeJt6E1sLr33ULO0d+Wde0Zkfk4eysMVQZtr
	 Z9LdcLZKKo3OHMLds1Kg8ZK0k1+Pb2PuAd5ALwRX2k7TpGDIdGzaSHniZOPnyjKuY3teJ
	 n5QKuQFY6LYi2WuEHQ30idnpz3+aXe09kFtGZd1aoKdX+5mGefsXcdv7yrMcQ/r9aBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkkUzDF5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2D7606A325;
	Wed, 18 Nov 2026 21:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkkUzDF5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADDF1F000C5;
	Wed, 18 Nov 2026 21:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037254;
	bh=9rZgjPOt/n1b3e7PoVUf4RUa5Vod/8QgxQDvNPzDNTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkkUzDF5wDG2iJkzzP4SSDtLfEf7nRAD1UwiqUcBh7kTqyl9P5wtHdOppbr9HkdCg
	 nrTnjV6KoMWGRmKnB+FIgg7nGJ9UD8g8i2XLTVX/JDQw3X67GgdZFFQ0uNHgNpWlkK
	 1F0YNxNdW1DIh4PM4i2X+yNtfxWkBS1YJgpyFu38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1345/3318] xor: add missing vzeroupper to AVX code
Date: Wed, 18 Nov 2026 15:32:47 +0100
Message-ID: <20261118150400.735097871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7f81dd5897f41..c6450acd055d1 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -50,6 +50,7 @@ do { \
 		p1 = (unsigned long *)((uintptr_t)p1 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -81,6 +82,7 @@ do { \
 		p2 = (unsigned long *)((uintptr_t)p2 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -116,6 +118,7 @@ do { \
 		p3 = (unsigned long *)((uintptr_t)p3 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -155,6 +158,7 @@ do { \
 		p4 = (unsigned long *)((uintptr_t)p4 + 512);
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0




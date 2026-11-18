Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058886;
	b=tton5u52TZVCyLCMi9zMzguqbiPK2+Q081Qo5e8ChQ2glXWm3a5bk4P521ztrVsCQb4x
	 LNU7SmtHCqbcPKZGvqqEwq94lWgdLW7priUwqmymGmOpOo+9ObeiSdBGWb/NtoZxjpCH8
	 raiW93Y4b2XULkGRCGPbw4+fUSbXLyn72Uk97ULpgQGw94NTSJZvsI5mL44K4xj1TkXDU
	 BqXi93tFi3H2SpFnNjXU7XEi58b9Cvvh0X+uIMBKGG4QimzooNuOlzxRMCy8oIj7n3GIV
	 jf94BCkZCg99LYZxa9t0a+V4ZV4ACctcKG5FHrJcRUbpAoZWDM/FJf2HaTT+b8pvP4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7CmgQwp05sy2kBzZZQJJMArUtLNyx0+izFlmO5/VPK4=;
	b=F/ZtN06K51n9GJcD/O6SjbzXKNhdXCfEpMoooJ/7o0M+KzlVCKMVXVIc+0T8ctpOL2J+
	 W2+IfOORn/k8ltj+fbWsl3D/NC06mvTOPhHptQaOHQyUd+VCMpCl2xBjzkinHRkWX/gcb
	 MPGS3v0tdoOlrGgAByTBQxLz0iod2CYeVHjE5YE7p9vJ+66hLvJmJF6qn1DoDrUnuwXid
	 56+y11uh4IHrcXlMqQ3k4ypgphWZm6gvtRuGliqNzTzovUo7vLTfcgU5FpBq3rJi7Gdqy
	 ToLYyTbGk8YbW20Oh/0haG+5WXSfAp78aMaujPgZ4myNG80Td5zg8Px5u4HZGkHqZKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztls7bDt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB87606A32C;
	Thu, 19 Nov 2026 03:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztls7bDt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86E21F000C5;
	Thu, 19 Nov 2026 03:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058886;
	bh=7CmgQwp05sy2kBzZZQJJMArUtLNyx0+izFlmO5/VPK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztls7bDtCoFZ6ohctPPEeODJA7wU2nKh4NtkYqo6dVt16EJPcS/ulp2FtWlD0I/v5
	 9G7wKhHA8eO4TV+L+j0AqTIX1m7PUoBVSxNcBiipPC3MCk3426/vmWNezfR76NhsEs
	 2R+SGGrE1q3Zvl5B0HTA9E71UPmidgGqkiMEg6dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0646/1848] raid6: add missing vzeroupper to AVX-512 code
Date: Wed, 18 Nov 2026 15:44:44 +0100
Message-ID: <20261118145942.787104428@linuxfoundation.org>
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

commit b82cf9e49c1be7cf1fd8e1bd806b0cdd25ab8127 upstream.

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
 lib/raid6/avx512.c       | 6 ++++++
 lib/raid6/recov_avx512.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/lib/raid6/avx512.c b/lib/raid6/avx512.c
index bb684d144ee2c..1d7eab3723aee 100644
--- a/lib/raid6/avx512.c
+++ b/lib/raid6/avx512.c
@@ -95,6 +95,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -154,6 +155,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -227,6 +229,7 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -311,6 +314,7 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -417,6 +421,7 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -550,6 +555,7 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			       "m" (q[d+128]), "m" (q[d+192]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 const struct raid6_calls raid6_avx512x4 = {
diff --git a/lib/raid6/recov_avx512.c b/lib/raid6/recov_avx512.c
index fd9e15bf3f30f..c8a152d9ab6da 100644
--- a/lib/raid6/recov_avx512.c
+++ b/lib/raid6/recov_avx512.c
@@ -221,6 +221,7 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -363,6 +364,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.53.0




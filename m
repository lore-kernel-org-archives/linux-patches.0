Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590057;
	b=2USYJXCshSBDo5QgPzDQ8Hah4yyZugrJSEkC2fyCNMzb0gUsBWeIIW2gZGlBSyzU9rHX
	 TCuVk2/LmWA/3BR0hy9PJnT9VxosfgtRCj8hogN59itvTAJMaihlgdrwjHE5suratIB5d
	 s7DJu29E8fgk4Pa+AeZrp+0Kr3VXtvOviE5Quln5TgGTVurVd3+o/eOYVBfh69sBqPLMH
	 kMNGdq/mx2fWq6Aus81cSNMP1x1U1duUkps3cEZ5Y8wgIPpd4P3hkyL4nC/MFdV3wYujU
	 GQbol1p5nyqrXq1bk/tBAoWwiE+8Y3rrFiZiulYSC0Y09HUa/hYEkD7XTY+SjHL7ctQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CauuhmbvYtG1I/Tk/Jh32IzcvaLtU7I9L2DnsG18p34=;
	b=dTVSeZHUwcmReq5gYHnu5BeaSQpPVFWDtg+vsa0ZUf1jB8QTraJglbaRXSBVE6wyHZVR
	 kLXtaCTSIDMCk/AUQZGwjB10gx7CaRKU4IRpe6jPuN0QY3VLfmo+deOOFTfWHvd7a+lQy
	 y7MfCY+tgq9uJOeDek777JUTX8fweEtkM4CYitQHFi0fp3JISouzBojVVQz0r+sp2Apl/
	 66TZq5Cc7XcyyPBWTasxxpjOFzTv2wmZjIoSI2dMzzTpelFNA/Hl+mW+jMouWZDeWlvck
	 69magWYOuZm8qlW6vhmo+O5UKupTown3hAYGYfczXLP5uRYz/KxDWat2qc1VroSHByA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roWIxNcI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235D6606A88F;
	Fri, 13 Nov 2026 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roWIxNcI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3ED61F000C4;
	Fri, 13 Nov 2026 17:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590057;
	bh=CauuhmbvYtG1I/Tk/Jh32IzcvaLtU7I9L2DnsG18p34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roWIxNcITpDj80LY/v3vfH3tbUn1yVFYp2eNWyN/6Mp3wanaLOara7i23LYZXbzV+
	 Lxi8Z+Qy+Qnjt5NWWM74wfX6B/2YK8p7VCjn2z//xE6uHYzjPc7kwpj2uHuwA5gGW5
	 mNWyACaopq669Q5r5pIDx6XBh2ehegmOBHrXfVHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/686] raid6: add missing vzeroupper to AVX2 code
Date: Fri, 13 Nov 2026 10:43:41 -0500
Message-ID: <20261113153823.860692136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 97d598d2535ca..0ae0a621538a1 100644
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




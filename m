Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053084;
	b=JCX2EjtDGvlZKA9W7qn1eXWoxBISWiNZ4YY3eQUL4f8zjppyyZZ+gZGG29wVZcrXzFvE
	 ZfKg00Pyg7YMIKB4LcQE/bwT/QALGvqebJNhhwMMQXVSiQFmEP506ETv8jlg7hP2kBI+8
	 NjM4i45YUJlEd4YBUCB9/Paw9lwM5YgQUPn8DbqnKm+4dnZT+HlgKUIBJWQzLgSDBZjFS
	 l2+H6kyiB2Lb5MTypWEnxOTxvmrhm8YN8F1XqrI9T9ztJe5sGI4m4izGacFYahFkKu9RH
	 aiCn4Nv4uyhSFGh39mbWlIOTCu3yrOKqQnT5murza6dp0cTHso+VXcrXRREulBGdVyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gWAeziS+VeZqSgWJVKy5020oySgXgxxnboexun0qz5o=;
	b=n5VN9FyaLLoga0dDS3WGTwUUxFet/3byuDhEOok/ASKFl760UF2t/hWP+CMs4Af4ELWj
	 jHan6rH4NwAyQqBkpJwcttryUImMGfwmnJW0ESfMHeQZgw/kFuVYJz6w67bKPweT9nXI1
	 0mDVITyvpK56iPy2fwJD95Vb/oKnRm4R/VdIF1r9njBp5+E0Rf7CtLSdoxMxwYb0MT4Wo
	 uuaMy+bzO+VI77aOM/9Cv3ouWNYMuJHrr//p5sxXUBq7R0kZkpWppy9Fr2OUr2zXOFBdT
	 X6s9Cv/FHLJPZee25pHNYGC2Ahugg8egaA1cx4ivzTGJ0LilBe3vlvSJgmTcHYkH8fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0XnbUPL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A44606A32A;
	Thu, 19 Nov 2026 01:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0XnbUPL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FCA1F000C4;
	Thu, 19 Nov 2026 01:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053084;
	bh=gWAeziS+VeZqSgWJVKy5020oySgXgxxnboexun0qz5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0XnbUPLtwX+1r72g+WCHGMmpiUnrOxXvXvnmcZtFjCfv7dGhEpwu7fQwmS7qutWY
	 QV6YL+befz86LcVkqz+n60tHm1vv25iJWwy5LkuQFZ56RcK31DLUgpN0iYTB0E5fPt
	 TXrT0mqWqiLgko9JWH6YhtEfKQmSLT2hWRmHboPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0795/2214] xor: add missing vzeroupper to AVX code
Date: Wed, 18 Nov 2026 15:41:11 +0100
Message-ID: <20261118150043.335561089@linuxfoundation.org>
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




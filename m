Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3911DE4CD;
	Tue,  8 Oct 2024 13:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393228; cv=none; b=L4w4CPP6+Aa66fk3IU6zZrw+yDo/cqzyvocbigmV0KQeTC1K35kW2PR2Z9tUeRfEm9wgj2gJYOwepZYEvdPQQcfk3345MZYOqOxawVLkdIzymJc0qk56s3maNYp27vXbyHLX2S7TP+YCT6ZRrbvKzBuNWmqs9uLffHZzx1gdpMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393228; c=relaxed/simple;
	bh=4zS46cu7CqIuzkWYxrzONLTLU20GnOKtcZg1mHWugCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV9qhXnP2N8J1LIYzXcAntyQL1WFwyWuDv6TtM9chdr60Z7qrmjUBjDkxLvQ1PNsI7xTNt5Zb6dPU/dVcIAw0+85+GobSjjS5fuuGJj/RU6MB5gzP4NDH/96KJS9X4DyqWm+inKgv9NDgBSNCVVBkb+zR2q0YBPy2yez0ATAbLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MCBcCkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MCBcCkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B9AC4CEC7;
	Tue,  8 Oct 2024 13:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393227;
	bh=4zS46cu7CqIuzkWYxrzONLTLU20GnOKtcZg1mHWugCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MCBcCkqYPdDD9tbXAN20QOzGEYkyDurULYjpWfoYu1upW3ln350kmefYkmLrutb1
	 9xop7r6W+mvcAH4GfOvoi/IhFIwmzryvEGtLimXdVxJmLlnNdpI6+5tlrFR4GhWJZ6
	 XeN+DrfKl/HLnqV4r79nsQPbBtcT7lej7uYOcm3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangrui Song <maskray@google.com>,
	Jan Beulich <jbeulich@suse.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/386] crypto: x86/sha256 - Add parentheses around macros single arguments
Date: Tue,  8 Oct 2024 14:05:04 +0200
Message-ID: <20241008115631.791244756@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangrui Song <maskray@google.com>

[ Upstream commit 3363c460ef726ba693704dbcd73b7e7214ccc788 ]

The macros FOUR_ROUNDS_AND_SCHED and DO_4ROUNDS rely on an
unexpected/undocumented behavior of the GNU assembler, which might
change in the future
(https://sourceware.org/bugzilla/show_bug.cgi?id=32073).

    M (1) (2) // 1 arg !? Future: 2 args
    M 1 + 2   // 1 arg !? Future: 3 args

    M 1 2     // 2 args

Add parentheses around the single arguments to support future GNU
assembler and LLVM integrated assembler (when the IsOperator hack from
the following link is dropped).

Link: https://github.com/llvm/llvm-project/commit/055006475e22014b28a070db1bff41ca15f322f0
Signed-off-by: Fangrui Song <maskray@google.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha256-avx2-asm.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 0ffb072be9561..0bbec1c75cd0b 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -592,22 +592,22 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	leaq	K256+0*32(%rip), INP		## reuse INP as scratch reg
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
-	FOUR_ROUNDS_AND_SCHED	_XFER + 0*32
+	FOUR_ROUNDS_AND_SCHED	(_XFER + 0*32)
 
 	leaq	K256+1*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
-	FOUR_ROUNDS_AND_SCHED	_XFER + 1*32
+	FOUR_ROUNDS_AND_SCHED	(_XFER + 1*32)
 
 	leaq	K256+2*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 2*32+_XFER(%rsp, SRND)
-	FOUR_ROUNDS_AND_SCHED	_XFER + 2*32
+	FOUR_ROUNDS_AND_SCHED	(_XFER + 2*32)
 
 	leaq	K256+3*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 3*32+_XFER(%rsp, SRND)
-	FOUR_ROUNDS_AND_SCHED	_XFER + 3*32
+	FOUR_ROUNDS_AND_SCHED	(_XFER + 3*32)
 
 	add	$4*32, SRND
 	cmp	$3*4*32, SRND
@@ -618,12 +618,12 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	leaq	K256+0*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
-	DO_4ROUNDS	_XFER + 0*32
+	DO_4ROUNDS	(_XFER + 0*32)
 
 	leaq	K256+1*32(%rip), INP
 	vpaddd	(INP, SRND), X1, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
-	DO_4ROUNDS	_XFER + 1*32
+	DO_4ROUNDS	(_XFER + 1*32)
 	add	$2*32, SRND
 
 	vmovdqa	X2, X0
@@ -651,8 +651,8 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	xor	SRND, SRND
 .align 16
 .Lloop3:
-	DO_4ROUNDS	 _XFER + 0*32 + 16
-	DO_4ROUNDS	 _XFER + 1*32 + 16
+	DO_4ROUNDS	(_XFER + 0*32 + 16)
+	DO_4ROUNDS	(_XFER + 1*32 + 16)
 	add	$2*32, SRND
 	cmp	$4*4*32, SRND
 	jb	.Lloop3
-- 
2.43.0




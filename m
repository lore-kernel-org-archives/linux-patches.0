Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44051D095B;
	Wed,  2 Oct 2024 14:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877802; cv=none; b=IJ8BDX1M0uG6XGgbc/6atZmAfm7HfoTGhNNvmA5pX6+vU7QHiDX2aTEWZzp7u+4mKuFbGhDnJH8w/TShXu7pdVVspdICbas4i3tSHUemxsWHI50zh2hJKA+T2+Pqv+vBui5S38UJb0Eh6jnaS5+vWlxo5xZzHkZ0me4f2I2WHuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877802; c=relaxed/simple;
	bh=v2ptf4IUxkaQU3DMZXupv7gAvBqeaYmtCKItosnjs08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgoZfqvOIa5fbe3bSz7g+7hSJ+Rp9gvC1NdTGHopf8D+8VpPyX9uYVKLxFPQ/6PpGC7XhlTO/F66CGRarAnImRWSUy4WuglVY24ibGPvm03maaoQaXTcJS+142V1IRwflC4y6ErOdBpXqrcWx7kbocKkmDhzot3pTMzUVy1g5IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TFqSPQB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFqSPQB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B623C4CEC2;
	Wed,  2 Oct 2024 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877802;
	bh=v2ptf4IUxkaQU3DMZXupv7gAvBqeaYmtCKItosnjs08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFqSPQB4sj3+3kkwKAtIH0Cq3AlTQFI2phclkD9eu7TcpyshLfnDNC1haogz1YIUK
	 PerkKLL+QeqNEnLOtkgmlLinQLj8uAS9NnnqPPjyflC5luyt61wa917wwVieDyyG6d
	 gK5DJw6WyRbmaW6ROcJx1fnNwvkg7p3KAM4+QTH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 198/634] powerpc/vdso: Inconditionally use CFUNC macro
Date: Wed,  2 Oct 2024 14:54:58 +0200
Message-ID: <20241002125818.921011121@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 65948b0e716a47382731889ee6bbb18642b8b003 ]

During merge of commit 4e991e3c16a3 ("powerpc: add CFUNC assembly
label annotation") a fallback version of CFUNC macro was added at
the last minute, so it can be used inconditionally.

Fixes: 4e991e3c16a3 ("powerpc: add CFUNC assembly label annotation")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/0fa863f2f69b2ca4094ae066fcf1430fb31110c9.1724313540.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vdso/gettimeofday.S | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/kernel/vdso/gettimeofday.S b/arch/powerpc/kernel/vdso/gettimeofday.S
index 48fc6658053aa..894cb939cd2b3 100644
--- a/arch/powerpc/kernel/vdso/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso/gettimeofday.S
@@ -38,11 +38,7 @@
 	.else
 	addi		r4, r5, VDSO_DATA_OFFSET
 	.endif
-#ifdef __powerpc64__
 	bl		CFUNC(DOTSYM(\funct))
-#else
-	bl		\funct
-#endif
 	PPC_LL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
 #ifdef __powerpc64__
 	PPC_LL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
-- 
2.43.0




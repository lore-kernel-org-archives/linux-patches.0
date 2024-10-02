Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57F41CFED1;
	Wed,  2 Oct 2024 14:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879553; cv=none; b=BKvmCtWxI8hQh0z2NHC0i0n8YnY3TTsw4JqaVOZ8klD00h1QuoELbihimKtnbfy2waQYnlb/GBqOGH9JlKrf/8SkEKKstVhY+bEUUAONnuaPWVAA9NJ/8rgMTDsJURFbGc9IFur58pH0jk6/Vi+os4BRwl+itFAWlZ68Ai/qGO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879553; c=relaxed/simple;
	bh=tqSVdVl5tJwpkQ8GgN6hL+cWkxcwNWSfy/GXxsEYhIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxi284W5kgFgzqcOsX+JT8/234SfPWURm3b047GfRVWeZtrIckUm+cBBeF77XZ0gSvbuUsIbop1G/FovyM4DjhojRjgVNXPa6nxZ1ovmDCKTXnRBdnJO+C6XsDmiBji10hy7/dXZPYJcRj4AR26VU9a7GufBMWcyBYS/1xoa4H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4gi+8qP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4gi+8qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3FDC4CEC2;
	Wed,  2 Oct 2024 14:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879552;
	bh=tqSVdVl5tJwpkQ8GgN6hL+cWkxcwNWSfy/GXxsEYhIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4gi+8qPMHBdiPFUOnSRvkOkOq8+hvPDj2jyHR7J6+0rOJC4femf4dS6LiBHPWGjY
	 OoPT0OeuXZeEP6NvGPlHFo/POvwVS+WSmY26+m9WgOvtludiQs1q3dj3vreAQtXyzX
	 mcRyouyVf/I4gRcuTqZ/LOkjU18WW+Dk8oy/hFE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/538] powerpc/vdso: Inconditionally use CFUNC macro
Date: Wed,  2 Oct 2024 14:56:36 +0200
Message-ID: <20241002125758.450456355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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




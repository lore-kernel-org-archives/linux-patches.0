Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803A8148315;
	Tue, 25 Jun 2024 09:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308733; cv=none; b=fu0LKPSdexO+NqU/rjPMdx5migx76t9IRaOuGgRf4R13mhbIWekmM2lK4Vqv5Ubs1k24x5M2uKRpgzdHqfzs7dVa068ldg56mp/CUPTPs+GZhC33j0MqZDg/4+JyrwIuu8Um6vQ/RhJIkG5M9Kel2yHsVb+ai629j4l4y78j5jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308733; c=relaxed/simple;
	bh=jlizqqgTMmgRAVNQ8RZv4jIwXPwVeGiD3od1KXl0evs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8bvKepVdkSEbXAwy+M9G9mK8qiZR6P8vYiYfHPbUn8y03Ah/cthOnAL5s20BqBzc4+bMaFhbOjF54jsLcs3SnRbheLqfu5TvSzt8I1C40QW5hof+JXQ+pV2xKAgg9W0r3cYoi1/K3sfGiXUsZGa3UTvq9a7Gxzyc99jR0N5F84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/R+fN2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/R+fN2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F28C32781;
	Tue, 25 Jun 2024 09:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308733;
	bh=jlizqqgTMmgRAVNQ8RZv4jIwXPwVeGiD3od1KXl0evs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/R+fN2tOgye5FueGfQAGOt/lnF/rU/jz9FVY4l4fNzHbnWjhPEL6dqY5RG30kPzr
	 hlvkHFxw859xlqqtpR57nqYgmyZT8chq6ah5c3AlY6UQ5U21rOOyNHtoxRodudS4fJ
	 kewLzgcmiPs1GdtcoqVbBchHGeP2SqfROuQYrwJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.9 221/250] MIPS: mipsmtregs: Fix target register for MFTC0
Date: Tue, 25 Jun 2024 11:32:59 +0200
Message-ID: <20240625085556.534692522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 4a3e37b3caea817199757a0b13aa53dd7c9376c8 upstream.

Target register of mftc0 should be __res instead of $1, this is
a leftover from old .insn code.

Fixes: dd6d29a61489 ("MIPS: Implement microMIPS MT ASE helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mipsmtregs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mipsmtregs.h b/arch/mips/include/asm/mipsmtregs.h
index 30e86861c206..b1ee3c48e84b 100644
--- a/arch/mips/include/asm/mipsmtregs.h
+++ b/arch/mips/include/asm/mipsmtregs.h
@@ -322,7 +322,7 @@ static inline void ehb(void)
 	"	.set	push				\n"	\
 	"	.set	"MIPS_ISA_LEVEL"		\n"	\
 	_ASM_SET_MFTC0							\
-	"	mftc0	$1, " #rt ", " #sel "		\n"	\
+	"	mftc0	%0, " #rt ", " #sel "		\n"	\
 	_ASM_UNSET_MFTC0						\
 	"	.set	pop				\n"	\
 	: "=r" (__res));						\
-- 
2.45.2




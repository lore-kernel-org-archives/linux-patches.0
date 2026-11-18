Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019892;
	b=vrxgBw1T64xvVpcIcGBl+WJh2I3wHEsr7Vz5FIk0fvpDttsi9z+u40kRSPyfy+5oZn0L
	 yCmBwY+gpqenFiGCDBBypBcOGL6Bw5gezezogSQTBJC9ciO2bcS7LDGfb26emzLZMnsRc
	 jmg2HDKPkiYLW51R5miQ1AEaQHZAxK/91/RLYgeHnYUiLNQmX1qgwD8DVydbO4ySNVgbu
	 lP2DZOSxNC/saiplgx5uwVE3Rx3rKy5McjAP2G7ntosSrlHn2+J0TmKY+IA9kBefdF4ZC
	 /AcPamgsvu9nr9CDZKyxaCVjhKDsPgdIKa8d7SLn/pJz6dCT5Lpj2glRnsjliOwRgxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vlR5rMU7amU0+OD4FzUnYdPIKAQdGvN2afQGdJ8eiXk=;
	b=qXr3Ga8Jpn7YJox1nBi4L99rsts4mScOKGvKO5rJm9kA4lhiD2X7NuFW4u2IdqXz1ERA
	 b1ca0ddDLIW2gGPC9Sx0x0uM8WalP2/qBO+r5O/AOpDHyFV1iLoDtWZK4z7kkXJNcLeTb
	 lDrNAYMN9SZTmvl0yN1dtAGqvXxdGf5iIEEG41UJelgkNBxOtGNc9vAyJZYOZF2XVXoUB
	 2sB8R94wzb6hUyI1lDbT+LItL4OqrA+zbZkf/J1K4xEqMmYpsUcSWi3pmittSjGSZGYAe
	 OJWT7ittTanqOaQ4cHQBomvHrBW/NYMqCS0B66H6pJc4AzOl6JwoENZx3lSiP0Fy6Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyByAxj4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B34A606A32F;
	Wed, 18 Nov 2026 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyByAxj4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE41F000C4;
	Wed, 18 Nov 2026 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019892;
	bh=vlR5rMU7amU0+OD4FzUnYdPIKAQdGvN2afQGdJ8eiXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyByAxj4bLVCFINf6LDSjrMbr+K3ErdgWd9TTp1C9t1BGL0PHtZ2UmPQ1rO20Ghfd
	 XMPEwRjpmsBhX/AlW/yINT/6z37oElQ7x/9GoroCERiO1TOKtVPgB5OrTVY1jlembT
	 O35yIRDxNlZJ+zHzB3ULbrpavXR+fyJYcUhnnpWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1758/2651] s390/percpu: Add sanity check to GEN_MVIY macro
Date: Wed, 18 Nov 2026 15:49:58 +0100
Message-ID: <20261118150350.756824785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 965869bd2a4f2df44c84fc44f2d2038d14b45978 ]

Emit an error if the GEN_MVIY macro fails to parse the passed register
string. This will make it more obvious if something similar which was
fixed with [1] happens again.

[1] commit 101782f8945a ("s390/percpu: Fix MVIY_PERCPU() with older binutils")

Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
Tested-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 10f9cf286ec3 ("s390/percpu: Use asm_inline for arch_this_cpu_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index feb58acf87d69..1bd3f3c4c5847 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -100,12 +100,17 @@
  */
 
 #define MVIY_PERCPU(disp, dispalt, reg)						\
-	".macro GEN_MVIY disp reg\n"						\
+	".macro GEN_MVIY disp, reg\n"						\
+	".set	.Lreg,255\n"							\
 	".irp	rs,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15\n"			\
 	"	.ifc \\reg,%%r\\rs\n"						\
-	"	mviy	\\disp(%%r0),\\rs\n"					\
+	"		.set	.Lreg,\\rs\n"					\
 	"	.endif\n"							\
 	".endr\n"								\
+	".if .Lreg == 255\n"							\
+	"	.error \"Illegal register number\"\n"				\
+	".endif\n"								\
+	"mviy	\\disp(%%r0),.Lreg\n"						\
 	".endm\n"								\
 	ALTERNATIVE("GEN_MVIY " disp    ", " reg "\n",				\
 		    "GEN_MVIY " dispalt ", " reg "\n",				\
-- 
2.53.0




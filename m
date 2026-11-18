Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016379;
	b=uEi1UbX9aOANB7CdIi/ueIsZMwBlef6ssvcrwET5qJzCUpmnoeOr2wcdSYQUMvW1Pl2h
	 MjgZXWTBUkAeICoS4pozPooUgmS9KkkS8oCzlr0Hksl4BRlEBujuibgcVycapU2wR/X/W
	 i8jRBXGgBlH9T7WHZiVXgQlYVgqfR4SKKBBykRvKXkkU4IX77DHH4iHgkwwUKHIoP0uX/
	 joNUZrT5hsU/04PjVvMlGiTu9JZcJMyyXKNcUoxjvRVuDrwuP0SvMyywMeXX2lw5hd3WF
	 4zyyEuhS7WWmMuhlem7Q4868uIwRNECFTeU/9JWQ1wdaXd7J9hXCPKKoBM0vjNd1k1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOGSC/DWmUZTtdn3N7rjZSc01Mw+zDn/++vArdbl0fs=;
	b=OtbK0qzlLXTIiPsUz4fabnoBVL2ZSD0yO3DW9dBn7EoV3al0WfKDIF/hSa+YxxhpVn9L
	 uVU05euZVf4L45Edc883M5vGEy119tSNbweVnCGlO6qGj50e0QyMVQ+1WIgZhqCbHj2Rm
	 H9IvMAkFS/3vufFRVVJ18MtXBJZ0tjfYj59LynFof8YtOEv+3FDWkvJlG9wPXdpRrM/nc
	 GWwRHvGKxgsrHn/rzDTTGi7yOtMD1IM2pgUrpaG3bRUe0ZGD40jTQlVMoaq2r/DOF7Hyv
	 dtj0zVCdusFFsQdizK3GSue3z+rctYbWK90ODKRA2aejeBi6rAjQQ9/b+rsOay2CL8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RxiwknAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F0660A261B;
	Wed, 18 Nov 2026 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RxiwknAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988881F000C4;
	Wed, 18 Nov 2026 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016379;
	bh=vOGSC/DWmUZTtdn3N7rjZSc01Mw+zDn/++vArdbl0fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxiwknAY3yH8/OktYOFrPXiw5roMuK2guTw7uaiZh2Kh82dPVLRX2vRUMIqcuQvi3
	 aGpArtbtmSIVYpji/v5JrxutLHf6+M6PEUZqPhe8LklI/R6zDYKvJVjQBm4bCExu2Z
	 MiEa2xAq0h3zeY0Tk6ZhKSV0esjaERjm2txgmwUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0507/2651] x86/cpu: Inline generic_identify() into identify_cpu()
Date: Wed, 18 Nov 2026 15:29:07 +0100
Message-ID: <20261118150306.010835895@linuxfoundation.org>
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

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit ad86fe2134ccdc97a967693d2723a731c99fb7bc ]

generic_identify() has exactly one call site: at the top of
identify_cpu(). Fold it into identify_cpu() so that a single function
does the job for both the boot CPU and the secondary CPUs.

While at it, fix up both copies of the Cyrix comment.

No functional changes.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260916195203.1099646-4-ihor.solodrai@linux.dev
Stable-dep-of: 2711d67bc3a7 ("x86/cpu: Don't transiently clear the boot CPU's capabilities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7ac09bb6881fe..de07688c8711a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1827,7 +1827,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
-	/* cyrix could have cpuid enabled via c_identify()*/
+	/* Cyrix could have CPUID enabled via c_identify(). */
 	if (cpuid_feature()) {
 		cpuid_scan_cpu(c);
 		cpu_detect(c);
@@ -1991,14 +1991,23 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
 	set_cpu_bug(c, X86_BUG_NULL_SEG);
 }
 
-static void generic_identify(struct cpuinfo_x86 *c)
+/*
+ * This does the hard work of actually picking apart the CPU stuff...
+ */
+static void identify_cpu(struct cpuinfo_x86 *c)
 {
+	int i;
+
+	c->loops_per_jiffy = loops_per_jiffy;
+
+	init_cpu_info(c);
+
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
 
-	/* cyrix could have cpuid enabled via c_identify()*/
+	/* Cyrix could have CPUID enabled via c_identify(). */
 	if (!cpuid_feature())
-		return;
+		goto no_cpuid;
 
 	cpuid_scan_cpu(c);
 	cpu_detect(c);
@@ -2026,21 +2035,8 @@ static void generic_identify(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_32
 	set_cpu_bug(c, X86_BUG_ESPFIX);
 #endif
-}
-
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-static void identify_cpu(struct cpuinfo_x86 *c)
-{
-	int i;
-
-	c->loops_per_jiffy = loops_per_jiffy;
-
-	init_cpu_info(c);
-
-	generic_identify(c);
 
+no_cpuid:
 	cpu_parse_topology(c);
 
 	if (this_cpu->c_identify)
-- 
2.53.0




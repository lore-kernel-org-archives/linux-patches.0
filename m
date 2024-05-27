Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471CA7347E;
	Mon, 27 May 2024 19:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837561; cv=none; b=oRAnmwPVKwdDPbTtSA/6pykFazX1XNZJdXBpMkl59yH/VNlGxd241r9iNrDr20+8mVuoZhMckawuAWyyJQTyAXMn5iD4ONcEMLM3vA7AIAsjxPuLdNZMr1u/o/BvE+csgDZdlc74B367YIP2BTwuAS2VmQKRdK3DnMHSSHRRUmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837561; c=relaxed/simple;
	bh=LMnEjaWbW1L9esV9Fq8M0SizXc3p7rcajQW+yEQguis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+WKW5ddHzIpklZ+UuHPgBE+F76PkRC7NyZm5MTeEkDXc6jZmn2Pgg37lTi9V/tj7YTPMGaEYbepb4e4hJ0E0gaBpFviXWMIVVZth+N55zgx6xsRRj45jXtWmOoraEh1ydhDNok+/4a3niVp5i8Ag1PQwrW2p/FGJ4Hgvj+XWQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkFsfAKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkFsfAKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FECC2BBFC;
	Mon, 27 May 2024 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837561;
	bh=LMnEjaWbW1L9esV9Fq8M0SizXc3p7rcajQW+yEQguis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkFsfAKJljRFTtCB9rGdh3hftDOID/dhOzAO/trw201ZlDptKHepgGNsGGvAT0y88
	 HoCXeuXNQ46LXsO7XzLQSCTnEuM60PDN7A/xrzBI8VZqFtObSMWAju5vCDancxlEom
	 ISwCM8XEG0Id+dXElYFVMvENCugw4Ud0fT9bbawY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	=?UTF-8?q?Christoph=20M=C3=BCllner?= <christoph.muellner@vrull.eu>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 059/493] riscv: thead: Rename T-Head PBMT to MAE
Date: Mon, 27 May 2024 20:51:01 +0200
Message-ID: <20240527185631.380467092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Müllner <christoph.muellner@vrull.eu>

[ Upstream commit 6179d4a213006491ff0d50073256f21fad22149b ]

T-Head's vendor extension to set page attributes has the name
MAE (memory attribute extension).
Let's rename it, so it is clear what this referes to.

Link: https://github.com/T-head-Semi/thead-extension-spec/blob/master/xtheadmae.adoc
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Christoph Müllner <christoph.muellner@vrull.eu>
Link: https://lore.kernel.org/r/20240407213236.2121592-2-christoph.muellner@vrull.eu
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig.errata            |  8 ++++----
 arch/riscv/errata/thead/errata.c     | 10 +++++-----
 arch/riscv/include/asm/errata_list.h | 20 ++++++++++----------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
index 910ba8837add8..2acc7d876e1fb 100644
--- a/arch/riscv/Kconfig.errata
+++ b/arch/riscv/Kconfig.errata
@@ -82,14 +82,14 @@ config ERRATA_THEAD
 
 	  Otherwise, please say "N" here to avoid unnecessary overhead.
 
-config ERRATA_THEAD_PBMT
-	bool "Apply T-Head memory type errata"
+config ERRATA_THEAD_MAE
+	bool "Apply T-Head's memory attribute extension (XTheadMae) errata"
 	depends on ERRATA_THEAD && 64BIT && MMU
 	select RISCV_ALTERNATIVE_EARLY
 	default y
 	help
-	  This will apply the memory type errata to handle the non-standard
-	  memory type bits in page-table-entries on T-Head SoCs.
+	  This will apply the memory attribute extension errata to handle the
+	  non-standard PTE utilization on T-Head SoCs (XTheadMae).
 
 	  If you don't know what to do here, say "Y".
 
diff --git a/arch/riscv/errata/thead/errata.c b/arch/riscv/errata/thead/errata.c
index b1c410bbc1aec..6e7ee1f16bee3 100644
--- a/arch/riscv/errata/thead/errata.c
+++ b/arch/riscv/errata/thead/errata.c
@@ -19,10 +19,10 @@
 #include <asm/patch.h>
 #include <asm/vendorid_list.h>
 
-static bool errata_probe_pbmt(unsigned int stage,
-			      unsigned long arch_id, unsigned long impid)
+static bool errata_probe_mae(unsigned int stage,
+			     unsigned long arch_id, unsigned long impid)
 {
-	if (!IS_ENABLED(CONFIG_ERRATA_THEAD_PBMT))
+	if (!IS_ENABLED(CONFIG_ERRATA_THEAD_MAE))
 		return false;
 
 	if (arch_id != 0 || impid != 0)
@@ -140,8 +140,8 @@ static u32 thead_errata_probe(unsigned int stage,
 {
 	u32 cpu_req_errata = 0;
 
-	if (errata_probe_pbmt(stage, archid, impid))
-		cpu_req_errata |= BIT(ERRATA_THEAD_PBMT);
+	if (errata_probe_mae(stage, archid, impid))
+		cpu_req_errata |= BIT(ERRATA_THEAD_MAE);
 
 	errata_probe_cmo(stage, archid, impid);
 
diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/asm/errata_list.h
index ea33288f8a25b..9bad9dfa2f7a1 100644
--- a/arch/riscv/include/asm/errata_list.h
+++ b/arch/riscv/include/asm/errata_list.h
@@ -23,7 +23,7 @@
 #endif
 
 #ifdef CONFIG_ERRATA_THEAD
-#define	ERRATA_THEAD_PBMT 0
+#define	ERRATA_THEAD_MAE 0
 #define	ERRATA_THEAD_PMU 1
 #define	ERRATA_THEAD_NUMBER 2
 #endif
@@ -53,20 +53,20 @@ asm(ALTERNATIVE("sfence.vma %0", "sfence.vma", SIFIVE_VENDOR_ID,	\
  * in the default case.
  */
 #define ALT_SVPBMT_SHIFT 61
-#define ALT_THEAD_PBMT_SHIFT 59
+#define ALT_THEAD_MAE_SHIFT 59
 #define ALT_SVPBMT(_val, prot)						\
 asm(ALTERNATIVE_2("li %0, 0\t\nnop",					\
 		  "li %0, %1\t\nslli %0,%0,%3", 0,			\
 			RISCV_ISA_EXT_SVPBMT, CONFIG_RISCV_ISA_SVPBMT,	\
 		  "li %0, %2\t\nslli %0,%0,%4", THEAD_VENDOR_ID,	\
-			ERRATA_THEAD_PBMT, CONFIG_ERRATA_THEAD_PBMT)	\
+			ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)	\
 		: "=r"(_val)						\
 		: "I"(prot##_SVPBMT >> ALT_SVPBMT_SHIFT),		\
-		  "I"(prot##_THEAD >> ALT_THEAD_PBMT_SHIFT),		\
+		  "I"(prot##_THEAD >> ALT_THEAD_MAE_SHIFT),		\
 		  "I"(ALT_SVPBMT_SHIFT),				\
-		  "I"(ALT_THEAD_PBMT_SHIFT))
+		  "I"(ALT_THEAD_MAE_SHIFT))
 
-#ifdef CONFIG_ERRATA_THEAD_PBMT
+#ifdef CONFIG_ERRATA_THEAD_MAE
 /*
  * IO/NOCACHE memory types are handled together with svpbmt,
  * so on T-Head chips, check if no other memory type is set,
@@ -83,11 +83,11 @@ asm volatile(ALTERNATIVE(						\
 	"slli    t3, t3, %3\n\t"					\
 	"or      %0, %0, t3\n\t"					\
 	"2:",  THEAD_VENDOR_ID,						\
-		ERRATA_THEAD_PBMT, CONFIG_ERRATA_THEAD_PBMT)		\
+		ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)		\
 	: "+r"(_val)							\
-	: "I"(_PAGE_MTMASK_THEAD >> ALT_THEAD_PBMT_SHIFT),		\
-	  "I"(_PAGE_PMA_THEAD >> ALT_THEAD_PBMT_SHIFT),			\
-	  "I"(ALT_THEAD_PBMT_SHIFT)					\
+	: "I"(_PAGE_MTMASK_THEAD >> ALT_THEAD_MAE_SHIFT),		\
+	  "I"(_PAGE_PMA_THEAD >> ALT_THEAD_MAE_SHIFT),			\
+	  "I"(ALT_THEAD_MAE_SHIFT)					\
 	: "t3")
 #else
 #define ALT_THEAD_PMA(_val)
-- 
2.43.0




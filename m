Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831185;
	b=VLj0BRqA6/4IL87qui4M7leAPWtpAOTiuxbPUbsSSqvXcaSmlE3VjqO0GodogHYjq+VJ
	 6YthyUfsQDhW4EvmexGg35RROVHg/6NCanE5S7ia12jlp8Ll+1Uu3zJyIL9lbT4SzRFXT
	 SZnZAHdGQhrB/STUiyAtRKBcGqIao/BUMMSI5P+VbzWW3O0sHCk7bf/xollZc2ZnuVLgc
	 /tBa0KzIMgzANNgbR2Q4N0s6kzlh1tLiUqUZrhUcnvPem/kNZhmgeF0HHNG9e2edQLjSs
	 prCTbnr6UTlNoowdGgn/u4xsRrcC7mG28QCddICWKnLl+StKA82q2tN4UF5mgsrrQBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xaKEZsse96UoKXjs/s/oPHfnAoNENCU1/qOn3NM7fN8=;
	b=Mwa9MaxNW3WCrtGg/J7DzVzmGG7VuHshlpJxQaz7pxPn35573ZxpNzAsmiKn2dxfCBoa
	 s74BX6c+I7HaNMDsegrHy868dloAA6kKPuYwIGIlXQ9pYO493XAU5rq4JjYDk0xSLusEW
	 eOXQyGkACJQOug+lOk4GTJyxLZ+0ZGjQz5nMRzpA9JR2zxzUKzzW78uE0MS/lxurrAZD3
	 oDASsRchFssJqQGM6vZoUUn3HZeEOAw/UC7WqJqWCa3pXiVsLyc5ryMHNa4zjXwOYheWX
	 5HE+J70kCoYyUkh/p1Z0NKZk5aEy2ucjMxoBcI+XGe4r38NHDgERoA0OKb7xepCQzcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoJCu1ZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E77C606A332;
	Wed,  4 Nov 2026 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NoJCu1ZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081151F000C1;
	Wed,  4 Nov 2026 22:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831185;
	bh=xaKEZsse96UoKXjs/s/oPHfnAoNENCU1/qOn3NM7fN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoJCu1ZQeMXEQCoiQKi2eHO+SIpm9wb6/uRSXT5FaFMkk2g+O95NIE7/qHibQoUTL
	 YmzugL2LtwHsy+AVQhrc3xX6kyYa/kIUCaR/5prs9pEFG3ibneGAMkhRj9ineSfQt7
	 zWx2PsiwAyOCtY2T2VQqN+NMlu+4rE19IZ78mPTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0511/1005] RISC-V: errata: Add SiFive MAL-9092 workaround
Date: Wed,  4 Nov 2026 16:04:04 -0500
Message-ID: <20261104211058.247459269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 148ab873d8194cb44f29474da3b4428fa2e100d1 ]

SiFive cores with MAL-9092 require fence.rw instructions around
HLV/HLVX/HSV hypervisor instructions to ensure proper memory ordering
when accessing guest memory.

Note that HSTATUS.HU is cleared during KVM initialization, restricting
hypervisor instructions to HS-mode only. If future changes enable
HSTATUS.HU for U-mode access, additional errata considerations will be
needed.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://patch.msgid.link/20260817-sifive-errata-v1-1-6a80f1a2743d@sifive.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig.errata                    | 14 ++++++++++++++
 arch/riscv/errata/sifive/errata.c            | 20 ++++++++++++++++++++
 arch/riscv/include/asm/errata_list_vendors.h |  3 ++-
 arch/riscv/include/asm/insn-def.h            | 16 +++++++++++++---
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
index 6f230aebd4968..65d00fb9db9d7 100644
--- a/arch/riscv/Kconfig.errata
+++ b/arch/riscv/Kconfig.errata
@@ -95,6 +95,20 @@ config ERRATA_STARFIVE_JH7100
 	  Say "Y" if you want to support the BeagleV Starlight and/or
 	  StarFive VisionFive V1 boards.
 
+config ERRATA_SIFIVE_MAL_9092
+	bool "Apply SiFive HLV/HLVX/HSV fence errata"
+	depends on ERRATA_SIFIVE && 64BIT
+	default y
+	help
+	  This will apply the SiFive MAL-9092 errata to add fence.rw
+	  instructions around all HLV/HLVX/HSV instructions.
+
+	  Note: HSTATUS.HU is cleared during KVM initialization. If future
+	  changes enable HSTATUS.HU to allow hypervisor instructions in
+	  U-mode, additional errata handling may be required.
+
+	  If you don't know what to do here, say "Y".
+
 config ERRATA_THEAD
 	bool "T-HEAD errata"
 	depends on RISCV_ALTERNATIVE
diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
index 38aac2c47845a..3025b9d6966f8 100644
--- a/arch/riscv/errata/sifive/errata.c
+++ b/arch/riscv/errata/sifive/errata.c
@@ -51,6 +51,22 @@ static bool errata_cip_1200_check_func(unsigned long  arch_id, unsigned long imp
 	return true;
 }
 
+static bool errata_mal_9092_check_func(unsigned long  arch_id, unsigned long impid)
+{
+	/*
+	 * Affected cores:
+	 * Architecture ID: 0x8000000000000109
+	 * Implementation ID: 0x19251031, 0x19251217, 0x19260320
+	 */
+
+	if (arch_id != 0x8000000000000109)
+		return false;
+	if (impid != 0x19251031 && impid != 0x19251217 && impid != 0x19260320)
+		return false;
+
+	return true;
+}
+
 static struct errata_info_t errata_list[ERRATA_SIFIVE_NUMBER] = {
 	{
 		.name = "cip-453",
@@ -60,6 +76,10 @@ static struct errata_info_t errata_list[ERRATA_SIFIVE_NUMBER] = {
 		.name = "cip-1200",
 		.check_func = errata_cip_1200_check_func
 	},
+	{
+		.name = "mal-9092",
+		.check_func = errata_mal_9092_check_func
+	},
 };
 
 static u32 __init_or_module sifive_errata_probe(unsigned long archid,
diff --git a/arch/riscv/include/asm/errata_list_vendors.h b/arch/riscv/include/asm/errata_list_vendors.h
index ec7eba3734371..c62a82f60468a 100644
--- a/arch/riscv/include/asm/errata_list_vendors.h
+++ b/arch/riscv/include/asm/errata_list_vendors.h
@@ -11,7 +11,8 @@
 #ifdef CONFIG_ERRATA_SIFIVE
 #define	ERRATA_SIFIVE_CIP_453 0
 #define	ERRATA_SIFIVE_CIP_1200 1
-#define	ERRATA_SIFIVE_NUMBER 2
+#define	ERRATA_SIFIVE_MAL_9092 2
+#define	ERRATA_SIFIVE_NUMBER 3
 #endif
 
 #ifdef CONFIG_ERRATA_THEAD
diff --git a/arch/riscv/include/asm/insn-def.h b/arch/riscv/include/asm/insn-def.h
index d29da6ccd3dd8..b1b97eab91007 100644
--- a/arch/riscv/include/asm/insn-def.h
+++ b/arch/riscv/include/asm/insn-def.h
@@ -191,18 +191,28 @@
 	INSN_R(OPCODE_SYSTEM, FUNC3(0), FUNC7(49),		\
 	       __RD(0), RS1(gaddr), RS2(vmid))
 
+#define ALT_SIFIVE_MAL_9092_FENCE					\
+ALTERNATIVE("nop", "fence rw, rw", SIFIVE_VENDOR_ID,			\
+	    ERRATA_SIFIVE_MAL_9092, CONFIG_ERRATA_SIFIVE_MAL_9092)
+
 #define HLVX_HU(dest, addr)					\
+	ALT_SIFIVE_MAL_9092_FENCE "\n"				\
 	INSN_R(OPCODE_SYSTEM, FUNC3(4), FUNC7(50),		\
-	       RD(dest), RS1(addr), __RS2(3))
+	       RD(dest), RS1(addr), __RS2(3)) "\n"		\
+	ALT_SIFIVE_MAL_9092_FENCE
 
 #define HLV_W(dest, addr)					\
+	ALT_SIFIVE_MAL_9092_FENCE "\n"				\
 	INSN_R(OPCODE_SYSTEM, FUNC3(4), FUNC7(52),		\
-	       RD(dest), RS1(addr), __RS2(0))
+	       RD(dest), RS1(addr), __RS2(0)) "\n"		\
+	ALT_SIFIVE_MAL_9092_FENCE
 
 #ifdef CONFIG_64BIT
 #define HLV_D(dest, addr)					\
+	ALT_SIFIVE_MAL_9092_FENCE "\n"				\
 	INSN_R(OPCODE_SYSTEM, FUNC3(4), FUNC7(54),		\
-	       RD(dest), RS1(addr), __RS2(0))
+	       RD(dest), RS1(addr), __RS2(0)) "\n"		\
+	ALT_SIFIVE_MAL_9092_FENCE
 #else
 #define HLV_D(dest, addr)					\
 	__ASM_STR(.error "hlv.d requires 64-bit support")
-- 
2.53.0




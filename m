Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EDA213E89
	for <patches@lists.linux.dev>; Sun, 11 Jan 2026 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768131650; cv=none; b=jiHCNNDIts4pLtFvEknAXz+qpYhdxxAy9pKHVnfp/kjt5/l92RS5N1L0i8vcyeAp0iTTtvE5wjiE/m5T0MzdCpTr5K1Myfqaepkaq/ZsNw7wb0+whbyE+pQ8/dz6jlKa78oYLYhgXVjFh7Mft/6cazUtjXYm++SdFhTb3HkA9i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768131650; c=relaxed/simple;
	bh=BxcGEtvmChwcd3jmoVXL2NSISQN+Pq2feVDXfTElWDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XB4PBbtpCFSMvl2yY3txL51DWCvQLyXa8qiOcY8YZ/Bo6elpg753jjbt2VkJNrBR/5r5tfbOLLCyZO/6g1UDr6EtwN4LGpXOX/1W+dgOt9ebLexUgtl5iLiyxEUM4YSoM7xMJNrYMGQFx2FZ5evutLGJX7xL3iQ27bQhuXi0tRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XMavbfUC; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMavbfUC"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42fb03c3cf2so2927209f8f.1
        for <patches@lists.linux.dev>; Sun, 11 Jan 2026 03:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768131647; x=1768736447; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=43+BUdLjDrS+qG8IAzUpYgjX4+qAfP+18HmYFqK51pU=;
        b=XMavbfUC5bDC4KPH+RjuEaknUNID29jg1YVIm3J5GfVJkY9+zg3JROaBML+sQogh3M
         4dgqsYBhLYAsqRs5DOJM9LHcKgYFUHlf8AIQeKeqbVmSe6AC+e+AIY4gWRAqwOx52Cib
         H7F4Z5hJxYZaxA3fsQGp1c5cs+Z7JJg1w35bxk8SZastBqxEh0Xx8h9ebcA22xIvhiGd
         GoDBVb7qtZgPX/DQG4p/86ALr6dOUEweq9Cznh5Xwo+O73liXoR/bE1Zw6iRx5UZ9Eg2
         EMBdwlg9e1/6bWcBX3MPLDkrMKSexdPcNeefBY4ZVVV3+mCQ/jb22MOC/o4ZJfyBthH1
         Sj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768131647; x=1768736447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=43+BUdLjDrS+qG8IAzUpYgjX4+qAfP+18HmYFqK51pU=;
        b=kmnxhP8n0JBfW9xhP6sSFGjZiL6bwWVKMCX4zvO7+PEgr5VIqfOfTabhUVsUQ1e7xT
         rbioxD26AtWnrhFOXQlyzA1hflpucMLFax7gGd5mCyKdxFeku5BzBgqhxKYizShzY6ix
         Qw+r8L7fofueZPhwXgjy0i6SePdUJwojg6XOr9SHl0OpTm3JZHzABieWIdD242vPPIvG
         30R36iJVruvudzQC7lLFQC/vwJoJ6lYFVER/TFCFgMPBDz0AkhRVmAk9MANUMF4ApkIH
         PTlsKP6uyaTfgLqeVM2k9kATBkwvAaJCUDDBcRbTJ1tLTyiB4y2FB7k0pYk16wVVb/JI
         YoeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVd+c/a+AZ1yYBwggVt0pZlyh+1Bv0BAUi1RXfH4b76ysr0jMCMkFT7+boau9edmyyPmc6jXhbS@lists.linux.dev
X-Gm-Message-State: AOJu0YztoqQzc01fHLAwAOPsWWlkmP1GOGb+UcFbT9PGEFDZAnh82GRA
	xrocF5kj921dyrw03kWgNKxzv89ovCrpvHwn0i5RV6zqBskXjtlQggFU
X-Gm-Gg: AY/fxX75BoK5mLfXYMKtJ6q6+PCxYs5Xi8M+Gm/Z3DOaK3iWbrPaGs8CG+/1BO4LNJS
	Z90XC9YN11DTqnYbVx8FL4NoNz1T8qjDQ8ZJSQ8WiFPXU2n0vpAwPu3+vzGF4KEE5U9Ajlqs04k
	tV+BXl7EgyW1m+jQ4cwK1rqvtDBdCm//8lJxiOhL3smYWZOV/sODCm2ci/YtW66wdb2F4Su42Tq
	MMPRw99vhJIPRQOhtmvf/nx+TJ4zr8e23HYuswaLaLO4F3Pcem/tkLJXg8wQHUa77qhhFn5YDIt
	+IfnRITDt73NypAd+5NljUvzEWSGK60BomHgxAkJBd97P/BL1+bBPOxj9bt1hUnJksZiVr3RC3u
	b+zdMC5a2mlJrudW3ha3BfNL+Zhe4lZVAwZemnNEDDBztJiPhsntbIvfi33n1x8RxQD5SmdK+aV
	8ZcVsNZpo=
X-Google-Smtp-Source: AGHT+IFxKr/BDs6GkMVfzizp1ZEtTCP/mlHpR6rPr2/+/EuQe1VJPIN11t6H576GXj/Zy+RsmYa32w==
X-Received: by 2002:a05:6000:2410:b0:430:f58d:40cf with SMTP id ffacd0b85a97d-432c3633514mr16213745f8f.16.1768131646718;
        Sun, 11 Jan 2026 03:40:46 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-432dfa6dc4esm10829923f8f.23.2026.01.11.03.40.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 03:40:46 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	linux-alpha@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	patches@lists.linux.dev
Subject: [PATCH v2 1/1] alpha: trivial: remove ^L chars
Date: Sun, 11 Jan 2026 11:22:17 +0000
Message-ID: <20260111112217.2126872-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260111112217.2126872-1-safinaskar@gmail.com>
References: <20260111112217.2126872-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove ^L (a. k. a. \f a. k. a. form feed a. k. a. \x0c) from arch/alpha.
These characters hurt general readability and editor compatibility
without giving any benefits.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 arch/alpha/kernel/core_cia.c      |  6 ++---
 arch/alpha/kernel/core_irongate.c |  2 +-
 arch/alpha/kernel/core_marvel.c   | 18 +++++++--------
 arch/alpha/kernel/core_mcpcia.c   |  4 ++--
 arch/alpha/kernel/core_polaris.c  |  2 +-
 arch/alpha/kernel/core_t2.c       |  2 +-
 arch/alpha/kernel/core_titan.c    | 10 ++++----
 arch/alpha/kernel/core_tsunami.c  |  4 ++--
 arch/alpha/kernel/err_common.c    |  4 ++--
 arch/alpha/kernel/err_titan.c     |  2 +-
 arch/alpha/kernel/pci_iommu.c     |  4 ++--
 arch/alpha/kernel/smc37c669.c     | 38 +++++++++++++++----------------
 arch/alpha/kernel/sys_marvel.c    |  4 ++--
 arch/alpha/kernel/sys_titan.c     |  8 +++----
 arch/alpha/kernel/time.c          | 10 ++++----
 15 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/arch/alpha/kernel/core_cia.c b/arch/alpha/kernel/core_cia.c
index 6e577228e175..af571073266c 100644
--- a/arch/alpha/kernel/core_cia.c
+++ b/arch/alpha/kernel/core_cia.c
@@ -246,7 +246,7 @@ struct pci_ops cia_pci_ops =
 	.read = 	cia_read_config,
 	.write =	cia_write_config,
 };
-
+
 /*
  * CIA Pass 1 and PYXIS Pass 1 and 2 have a broken scatter-gather tlb.
  * It cannot be invalidated.  Rather than hard code the pass numbers,
@@ -555,7 +555,7 @@ verify_tb_operation(void)
 	alpha_mv.mv_pci_tbi = NULL;
 	goto exit;
 }
-
+
 #if defined(ALPHA_RESTORE_SRM_SETUP)
 /* Save CIA configuration data as the console had it set up.  */
 struct 
@@ -626,7 +626,7 @@ cia_restore_srm_settings(void)
 #define cia_restore_srm_settings()	do {} while (0)
 #endif /* ALPHA_RESTORE_SRM_SETUP */
 
-
+
 static void __init
 do_init_arch(int is_pyxis)
 {
diff --git a/arch/alpha/kernel/core_irongate.c b/arch/alpha/kernel/core_irongate.c
index 05dc4c1b9074..a47b4c48a7d3 100644
--- a/arch/alpha/kernel/core_irongate.c
+++ b/arch/alpha/kernel/core_irongate.c
@@ -160,7 +160,7 @@ struct pci_ops irongate_pci_ops =
 	.read =		irongate_read_config,
 	.write =	irongate_write_config,
 };
-
+
 int
 irongate_pci_clr_err(void)
 {
diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index d38f4d6759e4..5ac99c6b0d17 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -30,7 +30,7 @@
 #include "proto.h"
 #include "pci_impl.h"
 
-
+
 /*
  * Debug helpers
  */
@@ -42,13 +42,13 @@
 # define DBG_CFG(args)
 #endif
 
-
+
 /*
  * Private data
  */
 static struct io7 *io7_head = NULL;
 
-
+
 /*
  * Helper functions
  */
@@ -194,7 +194,7 @@ io7_clear_errors(struct io7 *io7)
 	p7csrs->PO7_CRRCT_SYM.csr = -1UL;
 }
 
-
+
 /*
  * IO7 PCI, PCI/X, AGP configuration.
  */
@@ -468,7 +468,7 @@ marvel_kill_arch(int mode)
 {
 }
 
-
+
 /*
  * PCI Configuration Space access functions
  *
@@ -596,7 +596,7 @@ struct pci_ops marvel_pci_ops =
 	.write = 	marvel_write_config,
 };
 
-
+
 /*
  * Other PCI helper functions.
  */
@@ -611,8 +611,8 @@ marvel_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 	csrs->POx_SG_TBIA.csr;
 }
 
-
-
+
+
 /*
  * RTC Support
  */
@@ -673,7 +673,7 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 	return ret;
 }
 
-
+
 /*
  * IO map support.
  */
diff --git a/arch/alpha/kernel/core_mcpcia.c b/arch/alpha/kernel/core_mcpcia.c
index 74b1d018124c..e7f5ecb31991 100644
--- a/arch/alpha/kernel/core_mcpcia.c
+++ b/arch/alpha/kernel/core_mcpcia.c
@@ -241,7 +241,7 @@ struct pci_ops mcpcia_pci_ops =
 	.read =		mcpcia_read_config,
 	.write =	mcpcia_write_config,
 };
-
+
 void
 mcpcia_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
@@ -249,7 +249,7 @@ mcpcia_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 	*(vuip)MCPCIA_SG_TBIA(MCPCIA_HOSE2MID(hose->index)) = 0;
 	mb();
 }
-
+
 static int __init
 mcpcia_probe_hose(int h)
 {
diff --git a/arch/alpha/kernel/core_polaris.c b/arch/alpha/kernel/core_polaris.c
index 75d622d96ff2..797b1bda0ec8 100644
--- a/arch/alpha/kernel/core_polaris.c
+++ b/arch/alpha/kernel/core_polaris.c
@@ -142,7 +142,7 @@ struct pci_ops polaris_pci_ops =
 	.read =		polaris_read_config,
 	.write =	polaris_write_config,
 };
-
+
 void __init
 polaris_init_arch(void)
 {
diff --git a/arch/alpha/kernel/core_t2.c b/arch/alpha/kernel/core_t2.c
index 3d72d90624f1..82887e882667 100644
--- a/arch/alpha/kernel/core_t2.c
+++ b/arch/alpha/kernel/core_t2.c
@@ -321,7 +321,7 @@ struct pci_ops t2_pci_ops =
 	.read =		t2_read_config,
 	.write =	t2_write_config,
 };
-
+
 static void __init
 t2_direct_map_window1(unsigned long base, unsigned long length)
 {
diff --git a/arch/alpha/kernel/core_titan.c b/arch/alpha/kernel/core_titan.c
index 77f5d68ed04b..3a217dc3bb3c 100644
--- a/arch/alpha/kernel/core_titan.c
+++ b/arch/alpha/kernel/core_titan.c
@@ -52,7 +52,7 @@ static int titan_pchip1_present;
 # define DBG_CFG(args)
 #endif
 
-
+
 /*
  * Routines to access TIG registers.
  */
@@ -76,7 +76,7 @@ titan_write_tig(int offset, u8 value)
 	*tig_addr = (unsigned long)value;
 }
 
-
+
 /*
  * Given a bus, device, and function number, compute resulting
  * configuration space address
@@ -197,7 +197,7 @@ struct pci_ops titan_pci_ops =
 	.write =	titan_write_config,
 };
 
-
+
 void
 titan_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
@@ -438,7 +438,7 @@ titan_kill_arch(int mode)
 	titan_kill_pachips(TITAN_pachip0, TITAN_pachip1);
 }
 
-
+
 /*
  * IO map support.
  */
@@ -571,7 +571,7 @@ EXPORT_SYMBOL(titan_ioremap);
 EXPORT_SYMBOL(titan_iounmap);
 EXPORT_SYMBOL(titan_is_mmio);
 #endif
-
+
 /*
  * AGP GART Support.
  */
diff --git a/arch/alpha/kernel/core_tsunami.c b/arch/alpha/kernel/core_tsunami.c
index fc1ab73f23de..e3452b38e12a 100644
--- a/arch/alpha/kernel/core_tsunami.c
+++ b/arch/alpha/kernel/core_tsunami.c
@@ -173,7 +173,7 @@ struct pci_ops tsunami_pci_ops =
 	.read =		tsunami_read_config,
 	.write = 	tsunami_write_config,
 };
-
+
 void
 tsunami_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
@@ -195,7 +195,7 @@ tsunami_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 	mb();
 	*csr;
 }
-
+
 #ifdef NXM_MACHINE_CHECKS_ON_TSUNAMI
 static long __init
 tsunami_probe_read(volatile unsigned long *vaddr)
diff --git a/arch/alpha/kernel/err_common.c b/arch/alpha/kernel/err_common.c
index 94e1b3dcf6d4..877b5231953d 100644
--- a/arch/alpha/kernel/err_common.c
+++ b/arch/alpha/kernel/err_common.c
@@ -24,7 +24,7 @@
  */
 char *err_print_prefix = KERN_NOTICE;
 
-
+
 /*
  * Generic
  */
@@ -77,7 +77,7 @@ mchk_dump_logout_frame(struct el_common *mchk_header)
 	printk("%s  -- End of Frame --\n", err_print_prefix);
 }
 
-
+
 /*
  * Console Data Log
  */
diff --git a/arch/alpha/kernel/err_titan.c b/arch/alpha/kernel/err_titan.c
index 0ffb2feea42a..d5c4c690209e 100644
--- a/arch/alpha/kernel/err_titan.c
+++ b/arch/alpha/kernel/err_titan.c
@@ -581,7 +581,7 @@ titan_register_error_handlers(void)
 	ev6_register_error_handlers();
 }
 
-
+
 /*
  * Privateer
  */
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 955b6ca61627..9d49908ee2dc 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -55,7 +55,7 @@ size_for_memory(unsigned long max)
 		max = roundup_pow_of_two(mem);
 	return max;
 }
-
+
 struct pci_iommu_arena * __init
 iommu_arena_new_node(int nid, struct pci_controller *hose, dma_addr_t base,
 		     unsigned long window_size, unsigned long align)
@@ -810,7 +810,7 @@ static int alpha_pci_supported(struct device *dev, u64 mask)
 	return 0;
 }
 
-
+
 /*
  * AGP GART extensions to the IOMMU
  */
diff --git a/arch/alpha/kernel/smc37c669.c b/arch/alpha/kernel/smc37c669.c
index a5a6ed97a6ce..8f7a4520771f 100644
--- a/arch/alpha/kernel/smc37c669.c
+++ b/arch/alpha/kernel/smc37c669.c
@@ -1093,7 +1093,7 @@ static int SMC37c669_xlate_drq(
 );
 
 static  __cacheline_aligned DEFINE_SPINLOCK(smc_lock);
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1189,7 +1189,7 @@ SMC37c669_CONFIG_REGS * __init SMC37c669_detect( int index )
     return SMC37c669;
 }
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1421,7 +1421,7 @@ unsigned int __init SMC37c669_enable_device ( unsigned int func )
     return ret_val;
 }
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1625,7 +1625,7 @@ unsigned int __init SMC37c669_disable_device ( unsigned int func )
     return ret_val;
 }
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1702,7 +1702,7 @@ unsigned int __init SMC37c669_configure_device (
     return FALSE;
 }
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1789,7 +1789,7 @@ static unsigned int __init SMC37c669_is_device_enabled ( unsigned int func )
     return ret_val;
 }
 
-
+
 #if 0
 /*
 **++
@@ -1861,7 +1861,7 @@ static unsigned int __init SMC37c669_get_device_config (
 }
 #endif
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1938,7 +1938,7 @@ void __init SMC37c669_display_device_info ( void )
     }
 }
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -1981,7 +1981,7 @@ static void __init SMC37c669_config_mode(
     	wb( &SMC37c669->index_port, SMC37c669_CONFIG_OFF_KEY );
     }
 }
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2011,7 +2011,7 @@ static unsigned char __init SMC37c669_read_config(
 	wb(&SMC37c669->index_port, index);
 	return rb(&SMC37c669->data_port);
 }
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2046,7 +2046,7 @@ static void __init SMC37c669_write_config(
     wb( &SMC37c669->data_port, data );
 }
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2175,7 +2175,7 @@ static void __init SMC37c669_init_local_config ( void )
     local_config[IDE_0].irq = 14;
 }
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2222,7 +2222,7 @@ static struct DEVICE_CONFIG * __init SMC37c669_get_config( unsigned int func )
     }
     return cp;
 }
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2274,7 +2274,7 @@ static int __init SMC37c669_xlate_irq ( int irq )
     return translated_irq;
 }
 
-
+
 /*
 **++
 **  FUNCTIONAL DESCRIPTION:
@@ -2325,7 +2325,7 @@ static int __init SMC37c669_xlate_drq ( int drq )
     }
     return translated_drq;
 }
-
+
 #if 0
 int __init smcc669_init ( void )
 {
@@ -2340,7 +2340,7 @@ int __init smcc669_init ( void )
 
     return msg_success;
 }
-
+
 int __init smcc669_open( struct FILE *fp, char *info, char *next, char *mode )
 {
     struct INODE *ip;
@@ -2365,7 +2365,7 @@ int __init smcc669_open( struct FILE *fp, char *info, char *next, char *mode )
 
     return msg_success;
 }
-
+
 int __init smcc669_close( struct FILE *fp )
 {
     struct INODE *ip;
@@ -2378,7 +2378,7 @@ int __init smcc669_close( struct FILE *fp )
     }
     return msg_success;
 }
-
+
 int __init smcc669_read( struct FILE *fp, int size, int number, unsigned char *buf )
 {
     int i;
@@ -2404,7 +2404,7 @@ int __init smcc669_read( struct FILE *fp, int size, int number, unsigned char *b
     SMC37c669_config_mode( FALSE );
     return nbytes;
 }
-
+
 int __init smcc669_write( struct FILE *fp, int size, int number, unsigned char *buf )
 {
     int i;
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 1f99b03effc2..4c38ad39fd37 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -33,7 +33,7 @@
 # error NR_IRQS < MARVEL_NR_IRQS !!!
 #endif
 
-
+
 /*
  * Interrupt handling.
  */
@@ -432,7 +432,7 @@ marvel_smp_callin(void)
 	for (i = 0; i < 16; ++i)
 		io7_redirect_one_msi(io7, i, cpuid);
 }
-
+
 /*
  * System Vectors
  */
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index b1f3b4fcf99b..1af0d909f436 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -36,7 +36,7 @@
 #include "machvec_impl.h"
 #include "err_impl.h"
 
-
+
 /*
  * Titan generic
  */
@@ -255,7 +255,7 @@ titan_dispatch_irqs(u64 mask)
 	}
 }
   
-
+
 /*
  * Titan Family
  */
@@ -337,7 +337,7 @@ titan_init_pci(void)
 	locate_and_init_vga(NULL);
 }
 
-
+
 /*
  * Privateer
  */
@@ -359,7 +359,7 @@ privateer_init_pci(void)
 	return titan_init_pci();
 }
 
-
+
 /*
  * The System Vectors.
  */
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 4d01c392ab14..1ed69632b01e 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -80,7 +80,7 @@ static inline __u32 rpcc(void)
 }
 
 
-
+
 /*
  * The RTC as a clock_event_device primitive.
  */
@@ -129,7 +129,7 @@ init_rtc_clockevent(void)
 	clockevents_config_and_register(ce, CONFIG_HZ, 0, 0);
 }
 
-
+
 /*
  * The QEMU clock as a clocksource primitive.
  */
@@ -199,7 +199,7 @@ init_qemu_clockevent(void)
 	clockevents_config_and_register(ce, NSEC_PER_SEC, 1000, LONG_MAX);
 }
 
-
+
 void __init
 common_init_rtc(void)
 {
@@ -245,7 +245,7 @@ common_init_rtc(void)
 	init_rtc_irq(NULL);
 }
 
-
+
 #ifndef CONFIG_ALPHA_WTINT
 /*
  * The RPCC as a clocksource primitive.
@@ -275,7 +275,7 @@ static struct clocksource clocksource_rpcc = {
 };
 #endif /* ALPHA_WTINT */
 
-
+
 /* Validate a computed cycle counter result against the known bounds for
    the given processor core.  There's too much brokenness in the way of
    timing hardware for any one method to work everywhere.  :-(
-- 
2.47.3


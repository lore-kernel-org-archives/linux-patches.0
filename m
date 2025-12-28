Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFAE278753
	for <patches@lists.linux.dev>; Sun, 28 Dec 2025 06:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766903716; cv=none; b=iADGXtbR+O0TIlIiYNEhoeaSuI8Rir+arSExEXtkups65IvHzEDtBToXdKBUFx+8RO+9G79rovPp7jLVajSbWtvGYZ3tYUzjZuN3hhCVxeS6FzNGDhlN3PfoWA1cZlU3n5nsu77jOtLj4GhrCZjPvmznhLx03cyluXiERlOxD/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766903716; c=relaxed/simple;
	bh=rS2h+ZCMdpPwTIzNg0Jb7vTkc8+4gj++h6kcd7OKP+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbq9d3iXz+GdUN8zsdQR9BjPtx6QrVKl2SOz7F9YL0ZfF+uEknVqdu8AbJ0YAjPe3g7cKYjp/IYIysx+SSVvVc4ZAcm3WJZS3l9DhbGFVIDMDffkDp0mdAZxZoDe0jtTUFf8vgFGP5lnXcLLZ8O/1LsFO1CvS74a7ZNpOfquTwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kvLYZ1MU; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvLYZ1MU"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59581e32163so9661993e87.1
        for <patches@lists.linux.dev>; Sat, 27 Dec 2025 22:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766903711; x=1767508511; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRYg9SV9y5XYK7dTy3OiE1QQQSIADoBHA5Qhld4xKiQ=;
        b=kvLYZ1MUC6cgxqDodIlcXreEPW8RamhaNlRhp605MwSeUSq57qgPSdvkwrfUPbP11S
         tF02hH6xyVyM6MqHW7/KPyxu2d1Lj6nSUaPgPNi5Pof1vo46lvXyLd3wDKrKteVBiKfj
         oNQ9AdcF4sIva1XqoQEBCSGilunz28o/jTG0biRt8sx3TtNE2itv0bkIfpqWv6RgtBPd
         qffpOrlZf8IPgPoIV/R/N6Yhocg7Gn9f6ujFQnBTCSCcCTvbAJvfQ9U4Ii5r/Vkmruh8
         +WyoxNDvFxW+Lg49tUw274Tkwq4ounnCF3eKeIQxZJKN5xI4Cfq2/0Jv4Y3l9/Anr2lA
         4/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766903711; x=1767508511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nRYg9SV9y5XYK7dTy3OiE1QQQSIADoBHA5Qhld4xKiQ=;
        b=h9r62VYr9BQD8GbJH0qefASWDmJEnTEi1oczM6olJOIduPOhLbXaP0WG0f1v36OSaJ
         57CG/RiHo7VAMJOZQlcE1wVmT9qtwFRHGwTAbkjRaIs5p7PptHOLugaeDfV34zNEREvI
         pAQGlT8GSR0KrSD4n8tg6aPN7AmvNJjMfXRQr+LLfoOtbOZMfxGfC/67So7zVF3OfXss
         L5LdzkNWjd/5BVzYckqjSJZTGy777y48BcXIA288Uj+qeYhsCjf8hSZHYmGnWXZTdmAl
         f93eY0NUJXBaai+kpdLzCXh7cNLJ4ZliQl/RYT/6wJDa2JYA0hjhyNnCctWGqMcIOTi+
         7bxg==
X-Forwarded-Encrypted: i=1; AJvYcCUxeeNSm/hGySV7/ClrS+qqM11ubORyD/5Ij8bst73RxO0QeUJ/wheDurBOW9up52VKZhRdStr+@lists.linux.dev
X-Gm-Message-State: AOJu0YyWjRbzVwHE4W+2PxSw7E/QxN4ZYYmeFT5Bh0UGleRt8a5ymOfT
	7SkPXHV39EJ6t9AkrAc3gc0ruszSVSZsv6RGLk8q/SuRaGNGC1ksG0Fl
X-Gm-Gg: AY/fxX4f5lam44AuLe/MImuGoU/jIRQkc/hiCAe2rtNNqQEBtk70E5FHEC/zP/xrvdv
	QP3klUbvLPBrZQKGIDfhGPrsTUPSbCHW2b3Q2Zv6wH7/uyONFnJ8NNd6xhrb3wG++pMWhOcMh0Z
	DQYJFRl3XbJQ8Gdq7aqn3RELKflOxEEKxEPlwslPuaf3ZW1ozUUumHepAjz9J7s1aAWwPjvT8to
	qJICxn2h4rcPMsjAEeqn0YiS22JlyQy0tRbKSH7K4uNxbFxh4tooEn7TYydbh2Wmj2MApTuXtGi
	VG0CJYfH2Jsn0sUzeoonBlYNyxFjpB1SriMQ6uFe+zZ4mpi7f1qVlGFa2tfCOQBzPMsOo37Nxe6
	YQhZbkuJ9HzTm2KyVENqVU0DA5M7paF+AqMQAuQIS/HiCu8TPT7rTufu6ZrKJSPtqrp1uEVsl6V
	kFnvt7aWV2
X-Google-Smtp-Source: AGHT+IFX1z1K0LJWfAF6kH+lJnxetC8ouTO9QlOH+1r7iPoOX0QCTQu6tJ9aQNKR7aHOZMn4g3QLkw==
X-Received: by 2002:a05:651c:549:b0:37b:8f05:13bb with SMTP id 38308e7fff4ca-38121635cbbmr96623351fa.27.1766903710930;
        Sat, 27 Dec 2025 22:35:10 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381224de67csm71612921fa.9.2025.12.27.22.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Dec 2025 22:35:09 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	linux-alpha@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/1] alpha: trivial: remove ^L chars
Date: Sun, 28 Dec 2025 06:34:40 +0000
Message-ID: <20251228063440.2623595-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251228063440.2623595-1-safinaskar@gmail.com>
References: <20251228063440.2623595-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove ^L (a. k. a. \f a. k. a. form feed a. k. a. \x0c) from arch/alpha.
I'm attempting to write my own tool for parsing kernel code.
And these characters complicate this without giving any benefits.

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


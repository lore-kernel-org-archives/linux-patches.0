Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BDC47127A;
	Tue, 21 Jul 2026 18:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659386; cv=none; b=GWGmANYPFjBHrJJplGV4APB8DrWr7+f6LvKiUqXM2dxPKu/GjDtvc18XTYkRKxWCYci32hMILw7gYO+ktvpQQmwCsMxP50AULrvHCj5Xw1e9Ko+asN0tpSWfShOWi0obwnj4rw2pCC6HdkwyUMYklbOfVgdD0dQSqsC1JHB+HFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659386; c=relaxed/simple;
	bh=JzCY6I7/DKtl2cmBtllP0qi0D/wAXB24log74vWKyAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GDb0UUvDmbPdQMBf5tPUg1NXEBJyvpB4OMDFmKMTmwOjGzQN5zXiO+uFhE1IMW6bQVszvggqdzORKiqgLWEzJJZSiNHr9CEQ1eOiVzSXQoMs3r2gukS2iNf1qvPduaV2CGGG+LdE0NNtt1DEssC5LwsUhn2LIOM0d8xZQsDT22s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYslwBnM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYslwBnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441311F000E9;
	Tue, 21 Jul 2026 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659385;
	bh=6eMVPlTiHXHc1maKeraQrWTWPpCsidJ19SjJ+mHGq0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYslwBnM3HKaqSddy24ZQmeKDiZ3jRhVzOc2CHyRzMrQkv6uvKgb9/kdslVnOmAvv
	 Ax2eBLv77naBTPGKoWyQI8DNyn4hwwVqyvhY8HvoKzdb7EUEglw143Q65Q6Mf0kY20
	 jYAdSkbj7UT8/eF9/sWSHJAV4FjoEurqVw+fldc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 1484/1611] riscv: vdso: Do not use LTO for the vDSO
Date: Tue, 21 Jul 2026 17:26:40 +0200
Message-ID: <20260721152548.825751481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit ad6dcfa023762e37962f77ee48e752b7570e9440 upstream.

With LTO enabled the compiler assumes that the vDSO functions are not
used and optimizes them away completely. Currently this happens to
__vdso_clock_getres(), __vdso_clock_gettime(), __vdso_getrandom(),
__vdso_gettimeofday() and __vdso_riscv_hwprobe().

Disable LTO for the vDSO, as these functions are hand-optimized anyways.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606301855.WvkSC4kD-lkp@intel.com/
Fixes: 021d23428bdb ("RISC-V: build: Allow LTO to be selected")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20260701-riscv-vdso-lto-v1-1-89db0cd82077@linutronix.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/vdso/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -49,9 +49,9 @@ CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
 endif
 
 # Disable -pg to prevent insert call site
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
-CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
-CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_LTO)
+CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_LTO)
+CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_LTO)
 
 # Force dependency
 $(obj)/vdso.o: $(obj)/vdso.so



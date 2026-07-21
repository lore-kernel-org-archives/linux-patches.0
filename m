Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767A33E7141;
	Tue, 21 Jul 2026 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655236; cv=none; b=ZkUcpI0FwfSXgnkxylu5QjjA1rSf2oNbSK+XoWPivX1TtPNxFME5perwbL89otUDLTbt/QMFKlPVbeZuOTU/tKnZMU6xL1/GAa3eTwt8fXh8A75Ly/EBx1G2xX9GcD/hZB829frAqq1Xg01waSTGsWszZsIGykSI0JI/xlqDEhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655236; c=relaxed/simple;
	bh=JtN7FCX1S4WcRJ4kLfo9jYezbGsiir4ZdtvS4QFlGXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tGSx5uY3YCMr/OK5/LZG197Mi7ao2uHygr1IaJM2eFvDYnHQJLn3JG//DZSbZYvk3IqlTmcoJlKOikXLIdX1MlvsdJD/NBzv1ueLZ8p1LEkc1+qB1Abn0Bm+oOc2qVySuqDg9URtqB9N6J9VBPkhPQkn2iUpaDMWI4CSTEw2Qa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIOGCFW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIOGCFW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDE71F000E9;
	Tue, 21 Jul 2026 17:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655235;
	bh=2j/tn0LmhOpk0UD+9F5vrFEQAvgYB34P2MLjuV12vvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIOGCFW13+FtJdNb7aQ5GTKYn/bjjllLv5rZqBkF9bBdpx4A0VQGVEh70E4anId08
	 fog9KcLjtRi60rHcLBGWtbzbYAQRCcQAgCs6yHi9Zx0P6zdToVy3Klyzi48620sVcs
	 ol/xoaOLImTOAtWFBvbEczzJ7sre75508srtBVqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.1 2007/2077] riscv: vdso: Do not use LTO for the vDSO
Date: Tue, 21 Jul 2026 17:28:00 +0200
Message-ID: <20260721152640.048433006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -69,9 +69,9 @@ CPPFLAGS_$(vdso_lds) += -DHAS_VGETTIMEOF
 endif
 
 # Disable -pg to prevent insert call site
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
-CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
-CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_LTO)
+CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_LTO)
+CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_LTO)
 
 # Force dependency
 $(obj)/$(vdso_o): $(obj)/$(vdso_so)



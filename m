Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2E44C62;
	Mon, 23 Jun 2025 21:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713570; cv=none; b=TsbqHxmK4AuyEQyviguJJQKFrI8DOxewrXCq+X6Nel0p0SKQ/lf9SGXaxwaib3wxMfJcyDw1Etxxsjn0T1BS1aTT9zGU/qXXb6AwBUQmpjDqiVw3hCxh3xF2oSuKYPoS4NQqG9Xyk8S3YeYGfgUa9ruhGIAgFhhZKjsPMhKE0kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713570; c=relaxed/simple;
	bh=fFc2/+ExhBWtqWoP7X4IV5WoZiWoD4S91mm+TZG3LBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBE4xSE/k4HUwzQNem72BysPhTkfW1ZRbjnNQ6Yq0f0hiVXJWwh2KQC03U8Ylj1CV+SfbUv/7MjzTEjTqV/A0fTyREPM081+RWnuNQvQJUstAxlThc6peEiyzHVFNh8ce8XbZl6WabIhXn2DM4yDrta91Lds1dRdq9HuEOE4pSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xI3C2IlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xI3C2IlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8259C4CEEA;
	Mon, 23 Jun 2025 21:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713570;
	bh=fFc2/+ExhBWtqWoP7X4IV5WoZiWoD4S91mm+TZG3LBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xI3C2IlW2zBLKo8ZntZnXzKi9JJden7wPtZkEg3emqmoafxZt0yZe55fc6+831Txu
	 j3L36C3lCK5g6lSYUuvxG0joVswmBm/lTNahcTnJDhW4vV3ydRmuo7gXMOR5fpviaq
	 GpDRhNL+/pdz7dA2WTbO9I8xQ7Rgvx+MGG/6z7BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/411] arm64: dts: ti: k3-am65-main: Fix sdhci node properties
Date: Mon, 23 Jun 2025 15:04:38 +0200
Message-ID: <20250623130636.951248797@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit 8ffe9cb889f2b831a9d5bbb1f7ad42d30e31170f ]

Update otap-del-sel properties as per datasheet [0].

Add missing clkbuf-sel and itap-del-sel values also as per
datasheet [0].

Move clkbuf-sel and ti,trm-icp above the otap-del-sel properties
so the sdhci nodes could be more uniform across platforms.

[0] https://www.ti.com/lit/ds/symlink/am6548.pdf

Fixes: eac99d38f861 ("arm64: dts: ti: k3-am654-main: Update otap-del-sel values")
Fixes: d7600d070fb0 ("arm64: dts: ti: k3-am65-main: Add support for sdhci1")
Signed-off-by: Judith Mendez <jm@ti.com>
Link: https://lore.kernel.org/r/20240423151732.3541894-2-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: f55c9f087cc2 ("arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index b81ee1f2aecd2..1d43d1b529b39 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -261,6 +261,8 @@ sdhci0: mmc@4f80000 {
 		interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
+		ti,clkbuf-sel = <0x7>;
+		ti,trm-icp = <0x8>;
 		ti,otap-del-sel-legacy = <0x0>;
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-sd-hs = <0x0>;
@@ -271,8 +273,7 @@ sdhci0: mmc@4f80000 {
 		ti,otap-del-sel-ddr50 = <0x5>;
 		ti,otap-del-sel-ddr52 = <0x5>;
 		ti,otap-del-sel-hs200 = <0x5>;
-		ti,otap-del-sel-hs400 = <0x0>;
-		ti,trm-icp = <0x8>;
+		ti,itap-del-sel-ddr52 = <0x0>;
 		dma-coherent;
 	};
 
@@ -283,18 +284,22 @@ sdhci1: mmc@4fa0000 {
 		clocks = <&k3_clks 48 0>, <&k3_clks 48 1>;
 		clock-names = "clk_ahb", "clk_xin";
 		interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
+		ti,clkbuf-sel = <0x7>;
+		ti,trm-icp = <0x8>;
 		ti,otap-del-sel-legacy = <0x0>;
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-sd-hs = <0x0>;
-		ti,otap-del-sel-sdr12 = <0x0>;
-		ti,otap-del-sel-sdr25 = <0x0>;
+		ti,otap-del-sel-sdr12 = <0xf>;
+		ti,otap-del-sel-sdr25 = <0xf>;
 		ti,otap-del-sel-sdr50 = <0x8>;
 		ti,otap-del-sel-sdr104 = <0x7>;
 		ti,otap-del-sel-ddr50 = <0x4>;
 		ti,otap-del-sel-ddr52 = <0x4>;
 		ti,otap-del-sel-hs200 = <0x7>;
-		ti,clkbuf-sel = <0x7>;
-		ti,trm-icp = <0x8>;
+		ti,itap-del-sel-legacy = <0xa>;
+		ti,itap-del-sel-sd-hs = <0x1>;
+		ti,itap-del-sel-sdr12 = <0xa>;
+		ti,itap-del-sel-sdr25 = <0x1>;
 		dma-coherent;
 	};
 
-- 
2.39.5



task_update_io_bitmap(void)
 {
+	struct task_struct *tsk = current;
 	struct thread_struct *t = &tsk->thread;
 
 	if (t->iopl_emul == 3 || t->io_bitmap) {
@@ -54,7 +55,12 @@ void io_bitmap_exit(struct task_struct *
 	struct io_bitmap *iobm = tsk->thread.io_bitmap;
 
 	tsk->thread.io_bitmap = NULL;
-	task_update_io_bitmap(tsk);
+	/*
+	 * Don't touch the TSS when invoked on a failed fork(). TSS
+	 * reflects the state of @current and not the state of @tsk.
+	 */
+	if (tsk == current)
+		task_update_io_bitmap();
 	if (iobm && refcount_dec_and_test(&iobm->refcnt))
 		kfree(iobm);
 }
@@ -192,8 +198,7 @@ SYSCALL_DEFINE1(iopl, unsigned int, leve
 	}
 
 	t->iopl_emul = level;
-	task_update_io_bitmap(current);
-
+	task_update_io_bitmap();
 	return 0;
 }
 
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -143,6 +143,7 @@ int copy_thread(unsigned long clone_flag
 	frame->ret_addr = (unsigned long) ret_from_fork;
 	p->thread.sp = (unsigned long) fork_frame;
 	p->thread.io_bitmap = NULL;
+	clear_tsk_thread_flag(p, TIF_IO_BITMAP);
 	p->thread.iopl_warn = 0;
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
@@ -401,6 +402,11 @@ void native_tss_update_io_bitmap(void)
 	} else {
 		struct io_bitmap *iobm = t->io_bitmap;
 
+		if (WARN_ON_ONCE(!iobm)) {
+			clear_thread_flag(TIF_IO_BITMAP);
+			native_tss_invalidate_io_bitmap();
+		}
+
 		/*
 		 * Only copy bitmap data when the sequence number differs. The
 		 * update time is accounted to the incoming task.



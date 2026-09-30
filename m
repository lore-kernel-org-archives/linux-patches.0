Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2D151C357;
	Wed, 30 Sep 2026 18:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793564; cv=none; b=RxFXF68F4yotg/ARlHvEnHpy7lqP1Ark0p7p6gfdetBr/m3bH2PJavgAP7pG8bQRM8ZB+3pbNITNyczkbQ4p8R/UmxLBFkttwbIi0gLe7/ystoc0HQeHbafNPOqib5kL4oyskPaUUOQqdQ54/jgug62oZW5NzmSSS/GJCP3xMzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793564; c=relaxed/simple;
	bh=bFG5t3R+ktKU/lRvm3ER5x24nAXynCBoyazvtjME2fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZhTnDZ5zEFHCILtZLH2bPzWAPdNvvBi+2ux05UsC4r0SFfnVmwcEax8DdfFf/sTGC/Nd8wME0fAHC41V4oYXGAN7WyD+urfit8AGKUV1KPV/42U/rUYClC8+sKsiNfJFkrtlCbDhaxd0ort3D5GgFwbMUmzGIg1wJJj4ftChOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENK9fGPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENK9fGPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763CD1F000FF;
	Wed, 30 Sep 2026 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793563;
	bh=Y1KezuCID9WoUxeD2O81Heb4Q2BRLjiRjKqedrcrkjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ENK9fGPrzR/4qAQY2jYfGTNwYEGTkNH1UMkP/3CUa/A2ac32dj4uXvHek+WlBAzTx
	 oqDeoCriFAbT2fRzdgjUBhWjho8hJvrx7jAsP8ARrUEydOn4BYeX25bmkypmay/KE5
	 45yq8YkO+McuaewFPQMK935OZvwq6e0tCyQ0rMis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 6.18 298/395] parisc: Increase kernel stack size to 32kb
Date: Wed, 30 Sep 2026 17:29:20 +0200
Message-ID: <20260930152347.118811016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 94b7e3a7e871ae27d4935c76959dfc61829f27f9 upstream.

For 64-bit Linux kernels, increase the default kernel stack size
(THREAD_SIZE_ORDER) to 32 kB, in order to avoid kernel crashes which have been
triggered recently when building the debian vtk9 package with gcc 17:

stackcheck: kworker/u128:0 will most likely overflow kernel stack (sp:179a83af0, stk bottom-top:179a80000-179a84000)
Kernel panic - not syncing: low stack detected by irq handler - check messages
CPU: 2 UID: 0 PID: 30760 Comm: kworker/u128:0 Tainted: G W 6.18.46-dirty #1 NONE
Tainted: [W]=WARN
Hardware name: 9000/800/rp3440
Workqueue: writeback wb_workfn (flush-259:0)
Backtrace:
 [<000000004022f050>] show_stack+0x70/0x90
 [<000000004022378c>] dump_stack_lvl+0x124/0x190
 [<000000004022382c>] dump_stack+0x34/0x48
 [<000000004020212c>] vpanic+0x204/0x648
 [<00000000402025c4>] panic+0x54/0x58
 [<0000000040232230>] do_cpu_irq_mask+0x3f8/0x440
 [<0000000040227070>] intr_return+0x0/0xc

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/thread_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -24,7 +24,7 @@ struct thread_info {
 
 /* thread information allocation */
 
-#ifdef CONFIG_IRQSTACKS
+#if defined(CONFIG_IRQSTACKS) && !defined(CONFIG_64BIT)
 #define THREAD_SIZE_ORDER	2 /* PA-RISC requires at least 16k stack */
 #else
 #define THREAD_SIZE_ORDER	3 /* PA-RISC requires at least 32k stack */



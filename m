Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E704FB9C3;
	Wed, 30 Sep 2026 17:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787804; cv=none; b=UVY1gq7AvFTBn8miBUhxvxoVszruBxb5YVQ72yeFpCSBlqe5yY5ptx/wPVhJ/G+EaA+KueVpIjQ8Wla/d0JwudPlQ6wQedFG/PnZEYDYfaWLa3eqiVbG3K5FGUXP+IYgZzTs3oRRYhNL5wpgFeXAaKf3I3OYa7XsQ5sc3U/0ftY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787804; c=relaxed/simple;
	bh=hOiDwwaGe2yuo/AtMLYR0sLZ8Ipx3pfrCYue6fAvMyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWOcvLPYIJocflKaofd0LYS4TZ8l1CMbacfbFpjugtRwTwIBaxR/dRELBV07AvOZBADzBGwkZ/ByhiA4CtLMpka4RfSwS9EaA0j9gXTjkfMVX6YhoTh2NsiiI1CiSgkJ6xsL5TQ6elv8yAIiNOx68WOlyhCodq7rdVvds15oEB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAWd1S/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAWd1S/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C13F1F000FF;
	Wed, 30 Sep 2026 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787802;
	bh=m3CglKzjMm6J+y+ULQw1lqzJezQIyE/vlu4dGqTZyXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAWd1S/qn4erICr5ekebyeScHVpgLBsLP1dTqRElZs5q5b95mtzUA9+xXUXFM+iFr
	 n+l+mhz0MGOBWzgXtiQGFXD+ZeYkLpPkuOW+l73LaE+t8vHcFEk7L0QgRFXcYz57N8
	 LIdX8Nvr3hPKtUIVtYIYdTUbskdWAti4OW4mhxq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 7.2 360/457] parisc: Increase kernel stack size to 32kb
Date: Wed, 30 Sep 2026 17:27:45 +0200
Message-ID: <20260930152353.776485076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



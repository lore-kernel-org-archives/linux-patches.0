Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80DE2236EB;
	Tue, 30 Sep 2025 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245156; cv=none; b=sFo4ACMEx4c5HcCxYtmgA8VXhiGc6IGOrroDKJvWxvCFXJNV/ZxPB6bVvQxolmLkcmEZyU0+RBMmeoaxV2jJjdt49AB+S0E06HI2U+0zPN+7M79MZ7DZk8QCoenPN/G2FI5nSKWN8YgtjTXrasEECvLYMo8xU4wEBSoDO8Yx3ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245156; c=relaxed/simple;
	bh=CXDinBqWpp4MToYbEOjsPy+eN+lRrKGVyy4OvfD3Js8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAGBKg4AuQUF95qdfhteIhcsNLDYUgVzGk1LAu8ADa9uT5mRQGD7EiILkBAuUe8khHGLJxjXa1gZzEBLnHLS3bc2T2NfqNgHkEYAoYkXA2ldHhADH30r/t65nqvjGLc/5ssulNvUQxeYc1obI6bqtBNJPbOZVDbP5F5Kg4uMqHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqLmf1ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqLmf1ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D91CC4CEF0;
	Tue, 30 Sep 2025 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245155;
	bh=CXDinBqWpp4MToYbEOjsPy+eN+lRrKGVyy4OvfD3Js8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqLmf1ipQ7qshQSfIlxi4xVVljkI6ffHtusilZOROynmCyXi/+OWxqnWxGU6X5Uru
	 Z+mPzxQMWo8SsnyD+aJbnWr9bKGwgN2r+CMX9dZOUn2LFuBJ8KxoHhIq/HVB3WBNxA
	 7Cgmlh5ZCKSNSjdQx0A6Q9ywijzoGmGY7cWsfMGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/151] hrtimer: Remove unused function
Date: Tue, 30 Sep 2025 16:46:24 +0200
Message-ID: <20250930143829.757309921@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 82ccdf062a64f3c4ac575c16179ce68edbbbe8e4 ]

The function is defined, but not called anywhere:

  kernel/time/hrtimer.c:1880:20: warning: unused function '__hrtimer_peek_ahead_timers'.

Remove it.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240322070441.29646-1-jiapeng.chong@linux.alibaba.com
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8611
Stable-dep-of: e895f8e29119 ("hrtimers: Unconditionally update target CPU base after offline timer migration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 2e4b63f3c6dda..a8fbf4b1ea197 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1873,25 +1873,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	tick_program_event(expires_next, 1);
 	pr_warn_once("hrtimer: interrupt took %llu ns\n", ktime_to_ns(delta));
 }
-
-/* called with interrupts disabled */
-static inline void __hrtimer_peek_ahead_timers(void)
-{
-	struct tick_device *td;
-
-	if (!hrtimer_hres_active())
-		return;
-
-	td = this_cpu_ptr(&tick_cpu_device);
-	if (td && td->evtdev)
-		hrtimer_interrupt(td->evtdev);
-}
-
-#else /* CONFIG_HIGH_RES_TIMERS */
-
-static inline void __hrtimer_peek_ahead_timers(void) { }
-
-#endif	/* !CONFIG_HIGH_RES_TIMERS */
+#endif /* !CONFIG_HIGH_RES_TIMERS */
 
 /*
  * Called from run_local_timers in hardirq context every jiffy
-- 
2.51.0




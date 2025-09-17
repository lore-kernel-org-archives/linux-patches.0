Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC4D1F3BA2;
	Wed, 17 Sep 2025 13:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114176; cv=none; b=lUePHgSkkxtaRDwOoEeB1j8ZsgvyrQwC2qAGIAlW4ZtV/4jKPeDk3Erj5gQ31oeRrDG27Zxs+/kawlopamnw5jrSYoh1zZg7QD6eWeUdgRshoJljj97vkUOvU+pa0pW4CieBrssgCS0EzVr5bd4H+ou6ZRhACu6FFjXIGp7zsJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114176; c=relaxed/simple;
	bh=os4FcHcfDaZ91efdIFR/E6Ou49qBG1ark/bnAZz6KWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKl2gSExz3Vz0Nu4oXgb/DznYl7P1fwDfWRTeisYs5LHWjw4niUSmFXlfYlawx/6PmcjJQ76N0aS3GP9taOBRMBlMniMeESh/fwZ24SjwqL0lh9Bu/sqzEiBI6lCfIYWMrP8QQwWq7wpYyuB6qyvPbVEmR6GlWv/3YimqyO4BQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqllr1Bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqllr1Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9248CC4CEF0;
	Wed, 17 Sep 2025 13:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114176;
	bh=os4FcHcfDaZ91efdIFR/E6Ou49qBG1ark/bnAZz6KWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqllr1BuFgsDQwNinns3K+BJc0OXNXf9s1yR2kN0vtgDChrOUl6RwBTFztRZa+wGa
	 68oYhuq6NO82Ocw71Bwuw3tujvtCznE2J+0DK01qRcwrKWbd6p5ydHp5mHZ1vr5Iac
	 hrTqgHv4OOK4ey6zPa/ok4m2GJhPXMnHRm5j6wus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 67/78] hrtimer: Remove unused function
Date: Wed, 17 Sep 2025 14:35:28 +0200
Message-ID: <20250917123331.213741251@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b3860ec12450e..00eecd81ce3a6 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1935,25 +1935,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
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




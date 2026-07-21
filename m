Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F3E46EC84;
	Tue, 21 Jul 2026 19:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661368; cv=none; b=rTsD4Sl1BXeQmSYyjxPAMlGvk+czgsu1WRnGXnO91rn7Ja4X1kJCW/1m5VTIzxD6jTgOL7SPIR90eSft9NopoWGD4klYEnLj3lrM1cDj9cmCb2JkeGeWaOpx8wqjvjopj6nMXE22CjbvY+MZj1KbBsb8fHXv7n7GWcJscwp6KQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661368; c=relaxed/simple;
	bh=PABUIboMc8aw5Qswdkp3GujSZUVcw4931NoxMW9pJNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nC7xwUcRKx6rfJL8TFmM2fQ59ywbseTTa37ayCbBuwXgEKctRk7mD0WVoMngOlcV6GQID4EeJPJMDRHrA8doBCSwovlZ2zYEHbRVBOGmoZKzXMRAnNhZP08gEKTD2Uov5dgSUk0QvPEP2cToEa3UF3WnNgPRiGpUowLn+bV5/ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVJ0whab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVJ0whab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E285B1F000E9;
	Tue, 21 Jul 2026 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661367;
	bh=Ft3VMZ8Xr694Jeag+sdhB1pIDp6Z2i612JtnbQE8fMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVJ0whabagCmgTnoCKcqqSzA6K458Pv5RMM7/0mEUPwXNDogHyTjtS7CZa9aIdEgj
	 4Z3lmXHNAmTh4JcwqZOW4QHxkboFeC0ND2hlx3/gpjmDwp9Lz+j2/abwa6QlRbWBD1
	 OP++wsa29W33IKdKv0dR6TDbx9q8+AgjlaNnkQBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0039/1276] time/jiffies: Change register_refined_jiffies() to void __init
Date: Tue, 21 Jul 2026 17:08:02 +0200
Message-ID: <20260721152446.961037769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 007c07168ac0c64387be500f6604b09ace3f3bdc ]

register_refined_jiffies() is only used in setup code and always returns 0.
Mark it as __init to save some bytes and change it to void.

Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250430032734.2079290-2-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/jiffies.h | 2 +-
 kernel/time/jiffies.c   | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 5d21dacd62bc7d..8e4a2d4fafe07b 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -59,7 +59,7 @@
 /* LATCH is used in the interval timer and ftape setup. */
 #define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
 
-extern int register_refined_jiffies(long clock_tick_rate);
+extern void register_refined_jiffies(long clock_tick_rate);
 
 /* TICK_USEC is the time between ticks in usec assuming SHIFTED_HZ */
 #define TICK_USEC ((USEC_PER_SEC + HZ/2) / HZ)
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 7ddedfa49b9dd8..e34a0623e7ada5 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -74,13 +74,11 @@ struct clocksource * __init __weak clocksource_default_clock(void)
 
 static struct clocksource refined_jiffies;
 
-int register_refined_jiffies(long cycles_per_second)
+void __init register_refined_jiffies(long cycles_per_second)
 {
 	u64 nsec_per_tick, shift_hz;
 	long cycles_per_tick;
 
-
-
 	refined_jiffies = clocksource_jiffies;
 	refined_jiffies.name = "refined-jiffies";
 	refined_jiffies.rating++;
@@ -99,5 +97,4 @@ int register_refined_jiffies(long cycles_per_second)
 	refined_jiffies.mult = ((u32)nsec_per_tick) << JIFFIES_SHIFT;
 
 	__clocksource_register(&refined_jiffies);
-	return 0;
 }
-- 
2.53.0




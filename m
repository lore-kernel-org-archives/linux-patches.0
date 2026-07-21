Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C185730F80C;
	Tue, 21 Jul 2026 17:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655726; cv=none; b=scAIR1hf3GMfR4/T6oOTez/NtSsauJkUw1XKJkmHPsbnEBtEPCXdp+3cbVqdjxe6kD57sKsqRvce7jJtDQELUL0F99AOZ4BeJfzrUT/tFMgisfqHGv0H2uf6iTOY61l7tCGKqCR2oCUPaK1Uwm2ZhLC+0eQfEBIobcGLLn3wvQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655726; c=relaxed/simple;
	bh=uYHNUgS9MX7GmKKhGhmwjECo22c+MBuFwTCjznUHi4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiVo5dxMEXnWAAwbAY8mcloh4yGdFE8rAxmUBmEAHqKWAa3opoVZhZfJKnI5AA/iwD9oBC0fz58f7BBK3be3HQbm0ftbE22PipJUOjl8fWRpM6lwT7oZd7JgOkFBe8WB7ZaNxSAIehjp1eCP2EFrTtjlp3IJMLXTc1sKFms3sm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVSuY2Ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVSuY2Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334DA1F000E9;
	Tue, 21 Jul 2026 17:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655725;
	bh=/jZx7nC4ozmtjvVksZXyVQnes2Vg0fKUq7r1hs/pvu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVSuY2Nirfnu1h7FBtd4eubxrybFchfAasEYhkjvOOPOn3OAfbpFoqMcBHjWKdC70
	 n1JNmNeoKvHHWtodtAOyKxEWUEGGTThz9VMJf4guq4CqEstIQnqh5fL+CpG+g3+7P7
	 fb5qMrTSkaswx+KqcvEqcr9MqmPbTMEKLVg1Ftgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0118/1611] alarmtimer: Remove stale return description from alarm_handle_timer()
Date: Tue, 21 Jul 2026 17:03:54 +0200
Message-ID: <20260721152517.511816668@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit ed3b3c4976686b63b28e44f9805a88abc20ff18a ]

alarm_handle_timer() was converted from returning enum alarmtimer_restart
to void, but the kernel-doc "Return:" line was not removed. Remove the
stale description.

Fixes: 2634303f8773 ("alarmtimers: Remove return value from alarm functions")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260429080635.166790-1-zhanxusheng@xiaomi.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/alarmtimer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index b64db405ba5c71..189ee8bbc3e650 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -508,8 +508,6 @@ static enum alarmtimer_type clock2alarm(clockid_t clockid)
  * @now: time at the timer expiration
  *
  * Posix timer callback for expired alarm timers.
- *
- * Return: whether the timer is to be restarted
  */
 static void alarm_handle_timer(struct alarm *alarm, ktime_t now)
 {
-- 
2.53.0




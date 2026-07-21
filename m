Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B396146AA6B;
	Tue, 21 Jul 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648334; cv=none; b=a9nlIcI2cT5TeQAFoAVW/Gjnl9SDq9TPXH9FnnhMD0sAtLfMws+7i4mnXuMud8oYT+9n4Nx2YPbaMazKXHjjSRPP4ghyiU+c7DdfmTPYl9Jnc3AgrKTls5aIYrueET3aPh/JZY9FnovCxDOyaNW568Z99nhAMoK0kNSagb/GWEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648334; c=relaxed/simple;
	bh=Is6ci5Oia0tHIduE07dX3dNu8fAZ5fzUJMxtBSo6gjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jghXekyZHMUMeZ4edduqw6t0das43rQYmugQKVX+P4nv13xn386imb6mEGPhgcrU9Ay00hYvEtHgrliJHDF6In3AVaCCiixKnUe4Mj9q0AJxUVgj55wVrhh+Ht+W6jKZ8ItKBtY5uWBzaSgHe3uFDH1UmLY7KyXg2cL0RHwmz6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTG513Bx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTG513Bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253591F000E9;
	Tue, 21 Jul 2026 15:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648333;
	bh=vmZdBu9qOryimW/ZwoYMhsF1QFe66INOD3xm6oafV2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTG513BxrVp7QA9RGxWXQE6hTUlYzesbcNjoIywdl47xog9fL4DOhZBiaXi0lgaV1
	 LUloZNyrtHsk0nholNxVLiUvMsM6cZG0mNiHj909WhYM/6gn8Srr+6yxPMBJ35e12n
	 M9iDEaZdfyRjEkdSPFy28eWOcK+lkC2VliuAtxuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0159/2077] alarmtimer: Remove stale return description from alarm_handle_timer()
Date: Tue, 21 Jul 2026 16:57:12 +0200
Message-ID: <20260721152556.435002153@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6e173d70d82592..fe9c42c03523c5 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -512,8 +512,6 @@ static enum alarmtimer_type clock2alarm(clockid_t clockid)
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




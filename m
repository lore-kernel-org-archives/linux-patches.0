Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062567;
	b=XJovBXGfUFBke78g3ehLoG4Uhx1G9ddBgKs17oLahtxT2M0nT8XIkpyIcIbNQTqYDts2
	 BLnpqKeyViKLgSIzdXgoWe6vZ3p1cSIZJUo3sHoCe7FYxBPMTvH3hYFiJaEpPXCUY8jTh
	 NFJw3ZnZkctkrmjkeY2hOPwdEWRh3V3v5bGA1lPhIIy0qLogRGB5JlbVJVLO1QSrAzzet
	 hYFsSXTgN/4bOkzAUJgwDVk3bJU/2IiTxZjpB0suVNIe6aOahdoV2UMdj6WllxpAwjwZE
	 qjYP6Z0iztoRoVIHoNpLvPYK/BKXwqmBSQTPmLZCC3Ox9f+Fei/mexFK0X1uWGG+tPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y5qTSXiOzrrG7mufTIQ29qJTn+//6MWvdcJclCfcgqI=;
	b=YRQAFrAJvJlx0IxfpRFY5oB5KF0U9f0hWC6JT7vZrWSnAyCcYs0AIWmFJJvHQf5QT1nu
	 hxzeYHRwjVX8XVto7KCHf1i0MAiwHBnlQ2K8o33uJ6GG0zOKoDRrxza0leAUeMqpyEflN
	 Vo468MSv4XivaqyUaGi/svY0LizYPK5YipgOn+2hYVqvyGIIs3Zwap/j9RLkbj1e8nn1d
	 skGMaUT/BgYP4O/+O3/+9qFtuRM6evnWVJ2OGJhIqpgvykMeC1IUyT0Du8VdC6b5Lj62t
	 I3sZtomEwi0p6cxoZPiH8b/p+cYJBwnLSfDgU5NdJfG4I2UxQRUPoC/DAiTHqd6QPtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4zjukd1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515E4606A333;
	Sat,  7 Nov 2026 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4zjukd1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25C61F0089F;
	Sat,  7 Nov 2026 14:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062567;
	bh=y5qTSXiOzrrG7mufTIQ29qJTn+//6MWvdcJclCfcgqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4zjukd1dUJdy9TzC4NgUlVVkMY0fy8aYIc5IyRSGiZervajik0cfH/Z29+4JRmQp
	 DOAw9ffNn6Ue3OWjqJT/EVKK/6D15SJVC+5Hf8VSmQoNzCGTSx/H7o9wNPm2wQqOlD
	 pE0JvOymEcto5t0vAOyhof1Rnk4/rTzWezQHd15I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1451/1536] timers/itimer: Keep a nonzero value at CPU timer expiry
Date: Sat,  7 Nov 2026 08:57:47 -0500
Message-ID: <20261107135038.592074332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit ef60f61208a30eb5b941b707debdf04517271b4f ]

get_cpu_itimer() returns a zero remaining time when the sampled CPU time
is exactly equal to the nonzero expiry. This makes an armed ITIMER_VIRTUAL
or ITIMER_PROF timer appear disarmed.

The cputime cleanup replaced cputime_le(), which implements <=, with <.
Restore the inclusive comparison so the equality case returns TICK_NSEC,
like the overdue case and set_process_cpu_timer().

Fixes: 648616343cdb ("[S390] cputime: add sparse checking and cleanup")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020223957.87842-1-dennylin0707@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/itimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index dc5b1d92e2466..677b67812fee3 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -60,7 +60,7 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 		thread_group_sample_cputime(tsk, samples);
 		t = samples[clock_id];
 
-		if (val < t)
+		if (val <= t)
 			/* about to fire */
 			val = TICK_NSEC;
 		else
-- 
2.53.0




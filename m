Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAE7471248;
	Tue, 21 Jul 2026 18:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658067; cv=none; b=TjBQwfpoVhnDykQI1WXu2e3OQ24NTvCjqeHb83WjyJXl1m4AvddwPU/onRMoBmUH2D3LZvn4C8F+cBr7X96ZOEjeXFcijzR5UdmPzows5GeFerLYO61S2H7KPFMvAnXcKEgyCUJUzeRevFL2xyb5Bk2fsVUlubNhOo4bIZexnIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658067; c=relaxed/simple;
	bh=uy/p0//t06Ohhj3NRmBlk1WnDY9m9fo/mKjg+DoLlIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbZg1QMSS5uuGEsX6ViMSWtwhm7L+2vf+Tgd9GD2s0dku2loRdoWzlP6Npr5ta9c71yeGV9CdsnRFpQCxr3yFTAl/8WJfH0uoEjUoz5tu4LZj/jeimool8BDzS6Tml4XC3DW60qRfh5wVXb4E1qLnB39eRuE1qbYz9cm+3+OA/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNhWaP0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNhWaP0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4231F000E9;
	Tue, 21 Jul 2026 18:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658066;
	bh=wxdNmCNXjdag65qr8fY6teehUHr5vNCNNOsbXNxPI5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNhWaP0wRZj41oUmeOHNNDMJcSMsnhGrRBjG3N/CxKFWvlBwHmEIfQ0t61URqkTy+
	 dn8af9Z0iEmpYs2dnAfU1JnxG+nuP4oxzrV8y23Orx92FS3Zuk0eQJ9domgpREqJaS
	 CmdhUGpi4wCPSE8AShPNckHAd7Tl/Ap1lDUn1hwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Karunika Choo <karunika.choo@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0976/1611] drm/panthor: Dont overrule pending immediate ticks in sched_resume_tick()
Date: Tue, 21 Jul 2026 17:18:12 +0200
Message-ID: <20260721152537.345548970@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 6fec8b473497b7f32e604a6dd92b32b0889af3e8 ]

We schedule immediate ticks when we need to process events on CSGs,
but those immediate ticks don't change the resched_target because we
want the other groups to stay scheduled for the remaining of the GPU
timeslot they were given. Make sure these immediate ticks don't get
overruled by a sched_queue_delayed_work() that would delay the tick
execution.

Fixes: 99820b4b7e50 ("drm/panthor: Make sure we resume the tick when new jobs are submitted")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260625-panthor-signal-from-irq-v4-0-3d2908912afa@collabora.com?part=9
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Karunika Choo <karunika.choo@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-6-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 749fe34b06db28..ff6fb8e6c38e96 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2588,7 +2588,14 @@ static void sched_resume_tick(struct panthor_device *ptdev)
 	else
 		delay_jiffies = 0;
 
-	sched_queue_delayed_work(sched, tick, delay_jiffies);
+	/* We schedule immediate ticks when we need to process events on CSGs,
+	 * but those don't change the resched_target because we want the other
+	 * groups to stay scheduled for the remaining of the GPU timeslot they
+	 * were given. Make sure those immediate ticks don't get overruled by
+	 * a sched_queue_delayed_work() that would delay the tick execution.
+	 */
+	if (!delayed_work_pending(&sched->tick_work))
+		sched_queue_delayed_work(sched, tick, delay_jiffies);
 }
 
 static void group_schedule_locked(struct panthor_group *group, u32 queue_mask)
-- 
2.53.0




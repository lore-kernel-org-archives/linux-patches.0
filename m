Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8441B25EF91;
	Tue, 11 Mar 2025 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707108; cv=none; b=W6+Y3VIaJbDGXL39dmpZGZ0sHXvSuxxPYEiXy0uqGfMcYFpa9PjZ4hfRFXrDuI5M/y1Qrh5NT2VOAbdYGcwNQbjT0AlU3rQPAebRqptB1QbCAzMbnrJri6ym0lTu8AGS9DvW5qO+OS/WTKXPIcfp3GbbU6OkAjSb+hedDRyT5dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707108; c=relaxed/simple;
	bh=7LMQN4BmljOX9BxxteciJ7IXpZj4R0qUMuXb+mmLdrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADwncwy9oC/VdmfwaJd8m3egP7eseh8FD/NxFvJ6b1lLwQvjtJYcyZAlQ0HrZfxlQmmC8zgowRDTZiVKkyzMDcFChePIKHqpZwWClLRTOchbBBdHfElLgQZH8HFdRFXRN+F1ylV0ROoFswIcQA+9KUayzZNi33jOr2CK0mVUQ5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3c7fdWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3c7fdWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4A6C4CEE9;
	Tue, 11 Mar 2025 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707108;
	bh=7LMQN4BmljOX9BxxteciJ7IXpZj4R0qUMuXb+mmLdrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3c7fdWvFGWfVPFEqlSOjzHd/8AwXFR5LHrCT4vjZyNPdeMAiVwosXn9n/lEDeeOV
	 2CJandOdTj1s86uHrJzqHUqfhiw7hBIJeQVmnp/aOoqyboSrENonNSOf1w8lyQ/kUd
	 +O8nKpiUnd2XCBxtaiwhi/CQNkbnGV4chw6UOJnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/462] clocksource: Replace deprecated CPU-hotplug functions.
Date: Tue, 11 Mar 2025 15:59:01 +0100
Message-ID: <20250311145809.232413401@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 698429f9d0e54ce3964151adff886ee5fc59714b ]

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210803141621.780504-35-bigeasy@linutronix.de
Stable-dep-of: 6bb05a33337b ("clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 00cf99cb74496..e44fb1e12a281 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -335,12 +335,12 @@ static void clocksource_verify_percpu(struct clocksource *cs)
 		return;
 	cpumask_clear(&cpus_ahead);
 	cpumask_clear(&cpus_behind);
-	get_online_cpus();
+	cpus_read_lock();
 	preempt_disable();
 	clocksource_verify_choose_cpus();
 	if (cpumask_weight(&cpus_chosen) == 0) {
 		preempt_enable();
-		put_online_cpus();
+		cpus_read_unlock();
 		pr_warn("Not enough CPUs to check clocksource '%s'.\n", cs->name);
 		return;
 	}
@@ -366,7 +366,7 @@ static void clocksource_verify_percpu(struct clocksource *cs)
 			cs_nsec_min = cs_nsec;
 	}
 	preempt_enable();
-	put_online_cpus();
+	cpus_read_unlock();
 	if (!cpumask_empty(&cpus_ahead))
 		pr_warn("        CPUs %*pbl ahead of CPU %d for clocksource %s.\n",
 			cpumask_pr_args(&cpus_ahead), testcpu, cs->name);
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D9B17A2E8;
	Mon, 10 Mar 2025 18:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629742; cv=none; b=CdQOh7fbm8R/jgLRBx+lxyxNJhBBQfBtBgO0JSclOxHJgyz22pmmMqoiG34WZ6cVWOZcajVENK6OfmowXFPzlS4lGNRnmT1zVbCzf8k+qN7C3UMvj5puVrUOW5ub2D0gh0nJ7oKTEYBS+EqOl9yUFbuOnllMQjeGGsPP20nmYjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629742; c=relaxed/simple;
	bh=PG5y7xgbJcNTRzA3tuTo/4ptGaWbiwHZ5UHnekJ58+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuXmZEO2teis6N6Ty0cjFXr7Hz/A4voQVzLrdSioCuxwdDQVCj/8aLec/aaA57BBhYTUm6DFO7wWqLAu+qaCUi8t1HzOPTITyL5bLOA+j+195lLLrrRiUyToiuA/dOW8M+5GfDbSLHfBlfzMr096OLUwXXT56M5A7H0E0ozGkTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8BkN2hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8BkN2hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D32C4CEE5;
	Mon, 10 Mar 2025 18:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629741;
	bh=PG5y7xgbJcNTRzA3tuTo/4ptGaWbiwHZ5UHnekJ58+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8BkN2hhDRTCBgvs+wuanM2wo5EzVWxa2BzX/bRNVJKVxMQwB04+YJIjHWI75hW5c
	 szZxZDQRWWgVXt4FEFU9Vv4hUBtM8F5cjBJIZUClmHWfkDEbDYpr5DH2GzROVz697+
	 9wNjqqV9/TZh8Rr5P4UY7T9DKoh5U7J2dP4+EeiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 390/620] clocksource: Use pr_info() for "Checking clocksource synchronization" message
Date: Mon, 10 Mar 2025 18:03:56 +0100
Message-ID: <20250310170600.990564180@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 1f566840a82982141f94086061927a90e79440e5 ]

The "Checking clocksource synchronization" message is normally printed
when clocksource_verify_percpu() is called for a given clocksource if
both the CLOCK_SOURCE_UNSTABLE and CLOCK_SOURCE_VERIFY_PERCPU flags
are set.

It is an informational message and so pr_info() is the correct choice.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Link: https://lore.kernel.org/all/20250125015442.3740588-1-longman@redhat.com
Stable-dep-of: 6bb05a33337b ("clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ee7e8d0dc182f..8d9b11555f7ef 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -351,7 +351,8 @@ void clocksource_verify_percpu(struct clocksource *cs)
 		return;
 	}
 	testcpu = smp_processor_id();
-	pr_warn("Checking clocksource %s synchronization from CPU %d to CPUs %*pbl.\n", cs->name, testcpu, cpumask_pr_args(&cpus_chosen));
+	pr_info("Checking clocksource %s synchronization from CPU %d to CPUs %*pbl.\n",
+		cs->name, testcpu, cpumask_pr_args(&cpus_chosen));
 	for_each_cpu(cpu, &cpus_chosen) {
 		if (cpu == testcpu)
 			continue;
-- 
2.39.5




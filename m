Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE5025BABF;
	Tue, 11 Mar 2025 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707228; cv=none; b=szOoJLcp7vdCFMNN/fx3o0HsFGE9b09y7LBdMixMefmvNwXwMe2BM5C0glaw6biglsYXTJr6FBvq2S6YqyNBof6rW1qc54kbCSvGTVNExAUR6sqC9Tmvq1Qf6Gx/fRI3dDKz9DDA6RHOv8JOe9o+gXYRoa6Mv3cR6o1dfsapFUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707228; c=relaxed/simple;
	bh=rv9Zk//qxYSdgSdJkwWD/9XRamiY9eUIhZklS3VnK60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRRVDLfZdTXQ4JFNiTYrL0ofPqCtTJUpcRVjuK6F0rhtWQHXbsYLDiT9p0k+q3u5C1J3CU2rieLFdCBJdfBuAGNA8KF8q+2H9t/KR+jcS6lWnAuD1DY0BJWCZdGX75ToNwvHtv41MNUeevTbmNMDfYMzBrWtDC2ojf4AyNbIFvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKt2oEz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKt2oEz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7389CC4CEE9;
	Tue, 11 Mar 2025 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707227;
	bh=rv9Zk//qxYSdgSdJkwWD/9XRamiY9eUIhZklS3VnK60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKt2oEz1gvD3M/N3038iXWucuhBzD8UWFy9MoZqsMRIJwHzV0f1nxg7zJjX9eyvPa
	 hYGs5VCyd3h7kJryo5cLUq6NZDB1m/OwHbAPhfb5gTUTpiF/Fo82e2CrUq1YHXRnQj
	 mb7bXLlMryr3Lkdnr//9aP56HcQeYd5IMUMnmT7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/462] clocksource: Use pr_info() for "Checking clocksource synchronization" message
Date: Tue, 11 Mar 2025 15:59:03 +0100
Message-ID: <20250311145809.308322069@linuxfoundation.org>
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
index 658b90755dd72..21dfee6c0d936 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -345,7 +345,8 @@ static void clocksource_verify_percpu(struct clocksource *cs)
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




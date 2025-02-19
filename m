Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326A61DE8BC;
	Wed, 19 Feb 2025 08:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954415; cv=none; b=P3MYz/Z2LT8it7auEBLWDQRQr/HK6RqXu971Gs/jkvZXAj32CGnloFyAy65x/RY0xaYEA/rSdTkFvI3+iNu/+rMNqbnXQU3BhpnObavk0JmRkv4dsqEsRw73PacdasJXcjb63DK5IwpeuHwz4ehbMCheR27jz5fSQmsPvavLJ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954415; c=relaxed/simple;
	bh=DlnjLQt8sA9HArA12eXAEiliyii55G8RGApVpmhGxiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAqKH71XJGqPqgXVshbUBNAXQJmwjd5WJlS9XaQZ/O8+Dg1MROAj0BmH5N7E/XAoNW6fD5XW08Vvf2R4uX/fTa9iaocLBxl7Jfg7lBWZD2heRaY4HkWjmPIUEP0eDC9JFydG/oSoeCk50wwSK145MtfzozWSuPjj0qA0u3Onh6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMzmAf/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMzmAf/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF79C4CEE6;
	Wed, 19 Feb 2025 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954415;
	bh=DlnjLQt8sA9HArA12eXAEiliyii55G8RGApVpmhGxiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMzmAf/hNtHmrCbDeUMn13UwQW4u/tdFZCzL17wEx3gjioVijpRtZMBpE3geXv20c
	 v71osRQpBKvoONWTg/vbgKUKtEkjjHWcDIhZ/yB0YkuGWpa8Lyznvyk1zdO0j2UuuO
	 mqoxYmQvaB57hoB9H/0CgLJlkanI9eDQ8L5l6jtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	John Stultz <jstultz@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 197/274] clocksource: Use pr_info() for "Checking clocksource synchronization" message
Date: Wed, 19 Feb 2025 09:27:31 +0100
Message-ID: <20250219082617.293581980@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 7304d7cf47f2d..77d9566d3aa68 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -382,7 +382,8 @@ void clocksource_verify_percpu(struct clocksource *cs)
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




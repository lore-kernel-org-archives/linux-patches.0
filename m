Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0954383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302051; cv=none; b=hJpTJFXfj5WzypkROU9+QGtl1MLZA8bwdHWhOTuMWYpJ3VjH4p91NAgodc5n/SzGTgJ1NaA7QCBa89KEy+bqzJx27kS5q9VB0pdrC4/exYhAvNH7UiDItqFnZHrXB60jkIgYBoIgwAuu4LKcGS2Pf+ei6L95WL8TWooIIP6pXpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302051; c=relaxed/simple;
	bh=vfXcpkLA8Pkd58DbLx3sz7lXjVrfLGt+1JWgzn4iDdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5GZF+F+1avHj7VSq9CE+ob+KDSLmC98n0ZrZzV9cq9jX3tZvw2ahurh9qVdj9PjF8Llucwp8tgyO+vCpSos3IpEaWtdlR8DElgSn7n9hhfqWWm9cGUbq4wWv5YEbQwyWEAp54h65R0DgyMhENDodZWvcNPZizHd4w+nBS45otg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gy/UjUvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gy/UjUvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2198BC19423;
	Sat, 28 Feb 2026 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302051;
	bh=vfXcpkLA8Pkd58DbLx3sz7lXjVrfLGt+1JWgzn4iDdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gy/UjUvnlaXDWMR52vUWOSISUrCPQpeNHhiYYZ2f8hPcFBNn4OXlN4u6t0WdKGqFV
	 QdrSfnly1V8yma8Ocp6UFFVgPds3Swp5mjLV18fxnsd5scsinmwl9IIphdYbJuqcjt
	 jSrwfPKkcn4TIp0NU6Hm1lbEbpxgccINCeXk9yYrUQf+RHtCk6FDji5ho8FXzpUGkU
	 UMG/CcT+UxMOzxoNeX5KiBVeXuLLs0GpaFM4BY9rOXjV6PHHu3p98fs3a6qsyCTktA
	 t74F4Bdbb1ycM3cW7I18PrzP3jQkv90wTOFJKHF4vCl2mdwgT2ZehucPOD2eVVIO3R
	 9IxMG2B8fOtMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/283] cpuidle: menu: Cleanup after loadavg removal
Date: Sat, 28 Feb 2026 13:02:48 -0500
Message-ID: <20260228180709.1583486-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit bf183113842b0fcf4b6f977a97fa9cf8e2b21625 ]

The performance impact of loadavg was removed with commit a7fe5190c03f
("cpuidle: menu: Remove get_loadavg() from the performance multiplier")
With only iowait remaining the description can be simplified, remove
also the no longer needed includes.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 80606f4eb8d7 ("cpuidle: governors: menu: Always check timers with tick stopped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 27010eee6d1bc..864a7be7ba485 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -14,8 +14,6 @@
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
-#include <linux/sched.h>
-#include <linux/sched/loadavg.h>
 #include <linux/sched/stat.h>
 #include <linux/math64.h>
 
@@ -94,16 +92,11 @@
  * state, and thus the less likely a busy CPU will hit such a deep
  * C state.
  *
- * Two factors are used in determing this multiplier:
- * a value of 10 is added for each point of "per cpu load average" we have.
- * a value of 5 points is added for each process that is waiting for
- * IO on this CPU.
- * (these values are experimentally determined)
- *
- * The load average factor gives a longer term (few seconds) input to the
- * decision, while the iowait value gives a cpu local instantanious input.
- * The iowait factor may look low, but realize that this is also already
- * represented in the system load average.
+ * Currently there is only one value determining the factor:
+ * 10 points are added for each process that is waiting for IO on this CPU.
+ * (This value was experimentally determined.)
+ * Utilization is no longer a factor as it was shown that it never contributed
+ * significantly to the performance multiplier in the first place.
  *
  */
 
-- 
2.51.0


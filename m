Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2B3326938;
	Sat, 12 Sep 2026 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223558; cv=none; b=iYx3hkSHfCN46aCRU/CKJ+3Jjmm9RyBqVlni6HG8pyPGBXOCLL5Ku5fxu6l7FaaE6Qjym6mDyfulq4TRSS5JSqDlpENzlcyxjq18HpQU+g/YOU1DuHFi0qA1GpCRP1U59ZEYrOTQZI3B0sZ+0dfXeIJizs73/cMU09spaDgsAto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223558; c=relaxed/simple;
	bh=nhZOi5l3bgL4GizFGLw3vnVPEjncbGF6ARGUT9KI7fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCS4JjDe1qkVvUXyhUvZPZ6T15I9/z4sA/jawIQ2i5ZoPd7KQftLvke2YmxyjdB8SUc+VNv6H3z88jthMpxcaEt4VirJ0ZXV5yc3i9RpIG0WFupeZrzGKqjmcZwDbFy1mpPbkfTxR9QhpZM8OqciRp461CmWSBwWwizkJdKo6rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEUOsrcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEUOsrcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B057F1F000FF;
	Sat, 12 Sep 2026 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223557;
	bh=EOKpNSNT/4sVvEx/QUHR/EckJpskHMNcDtW5oVK39fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEUOsrcjDcx/D/tXs2xtjPjP8XkMSOp08ghJ+7mFEFRwbhRoKWI52LhQA7vd5Ca0J
	 od+kyaN09zUN/VQjpfvuikHjwV0CHnU/SPh53JUpMEiSfSZZpgf1U8WNFYhkoOHehu
	 seLOx22t17aa2jUWi7MzSH6uKzAzuGEb60k4eQ3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0771/1424] cpufreq: schedutil: Fix self-contradictory comment in sugov_iowait_apply()
Date: Sat, 12 Sep 2026 08:53:23 +0200
Message-ID: <20260912065624.562492713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

[ Upstream commit db6a017c91b774c15b1b890db45981eacfff540e ]

The kerneldoc of sugov_iowait_apply() says the IO boost value is increased
in sugov_iowait_apply() and, in the same sentence, that it is decreased by
the same function. That is self-contradictory, and the first part is wrong:
sugov_iowait_apply() only decreases the boost.

The boost is actually increased in sugov_iowait_boost(). Fix the comment to
name sugov_iowait_boost() as the place where the boost is increased, so it
matches the code.

No functional change.

Fixes: fd7d5287fd65 ("cpufreq: schedutil: Cleanup and document iowait boost")
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260703092433.4080165-1-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 996ceaaa35288..809452968eb44 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -317,7 +317,7 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
  * A CPU running a task which woken up after an IO operation can have its
  * utilization boosted to speed up the completion of those IO operations.
  * The IO boost value is increased each time a task wakes up from IO, in
- * sugov_iowait_apply(), and it's instead decreased by this function,
+ * sugov_iowait_boost(), and it's instead decreased by this function,
  * each time an increase has not been requested (!iowait_boost_pending).
  *
  * A CPU which also appears to have been idle for at least one tick has also
-- 
2.53.0




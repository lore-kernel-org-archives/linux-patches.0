Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F371FBEA6;
	Sat, 12 Sep 2026 19:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242565; cv=none; b=iFmD//a0jhG/7AnBwI9m4ocKG2BXdtpfDM8exJxhK9aLHeJ8nbIlDwMekONHpiBwVUAK+4QZ21qPg9MxdxvpoQUhhF3IC/XHIGgftIp8tzKYJO3f5ltleY4jzFw81q0Hj67HZw/AH5j/jnXK0NdoExave4O9jxNm8Rd8ZRQpfXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242565; c=relaxed/simple;
	bh=T7jyMhiRwRc2KEyIZmSBFbEBPCtuNTUmIgTBgBMg578=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDPDi+/1hZYlgenw+rb7KW7pCuApuJmsfEDWmde8uWD/mfpZmDWyCvqbyU7+EJm5KdiUfJVTxnwtfOjZY8QSmGfQRqBMFYIqW/ejNIa3VwjBxqMh7gaUNSdkXkWf2E1ycoTPbu4Uzxwg7czhDy3gd499h6P/jadyQhYty8E6J2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EK2+gDEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EK2+gDEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3D31F000FF;
	Sat, 12 Sep 2026 19:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242564;
	bh=CwwUmCX0rV0i4f8wfT5bM6bjD9W1Kl9aW0lBRJA+Xv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EK2+gDECzuhwzSaUFuUXRF0HLfTZDp5tpcD+/OVsSPkuikbzZsoTYV+D0HDbglUhB
	 q99to7S7T4sdFVk67cziZOB+w8M1eyy6arBYPixdHZy0B+iAR4VwK8inaG71cPifn9
	 /PAnuy7lDyy3iaVkaq6h0RzokVF9ds+JT8WPOKOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 448/798] cpufreq: schedutil: Fix self-contradictory comment in sugov_iowait_apply()
Date: Sat, 12 Sep 2026 09:01:16 +0200
Message-ID: <20260912065527.408942210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8df584b2af900..98e7010ac07fc 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -400,7 +400,7 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
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




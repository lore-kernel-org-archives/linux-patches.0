Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF6247B405;
	Sat, 12 Sep 2026 12:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215568; cv=none; b=MGFVWsQFDKILRu0dupmnwJR88m29BCfBot1s+0pViS1eSZoeJd6+gI9rZCZORwzCBNCb+PgnAIhWHXIJGXVwTQFhVGBg6uZO/6HqlckajA2N3stfVvOtC+ppgPunjTpRwGzRhG3cWLBlZ7Y70G/q5vyQhC4KqcFL/Bh42u7lyVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215568; c=relaxed/simple;
	bh=MmnMkR0JPJEDbBl4QwAR6UPi6JTLaWgegjUsuLqbbsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3qORXYPgYYrlJhfeCu9ruml//A9Ftcz2+iVBB/KILZNvsEhalJEzehTX2sNyGK91W7KFCgYHhk0zELRsnhtG7TTyyn2gEFunZ716wvaPMqB195aFQ33H7UicaSO9RzjDJ/T061osuGXb1w6S0K2uifE+5Fsme3U3bobtOvP49c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvYFn+c+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvYFn+c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A365A1F000FF;
	Sat, 12 Sep 2026 12:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215566;
	bh=a2cch3jtTnV/Ztca3oDKDqZEC178NwOr1z22A6NUzpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvYFn+c+m4U2m7BB7owwEGD5j9f4Mt0aCyU0+A22iw/X8aI0PjTVkHYyq6SRxJCfV
	 PQG/g3iK9W14Ltv1GDT2siffUkJI80LSvDeAaoloi5yXXXIAdIiWKWa39cvvfOZX/o
	 dPC12jxq+plvF6y4CJD9OLLxLEqmJYfH7FUTux4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0556/1376] cpufreq: schedutil: Fix self-contradictory comment in sugov_iowait_apply()
Date: Sat, 12 Sep 2026 08:49:42 +0200
Message-ID: <20260912065619.928148110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3d9606c2f32c6..7c41ed3ec9175 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -320,7 +320,7 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
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




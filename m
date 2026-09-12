Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B928346AE3;
	Sat, 12 Sep 2026 07:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198730; cv=none; b=d035N1O4oWChOiiPbaKWACORlBuveHEJuMUq8QJKV30IFqbOAQQzGzJCqik9wMMsqtvEIY7Ds5d4ECBnVBJ+qCpQ7GCI/GExjqR/zSGV8CD/lQG89iFo05s+1DM5zPgT6rJ9G3lBEFd3orWaajXHVGkdD1++pEBxHHWzvh0ad5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198730; c=relaxed/simple;
	bh=Y5tWwhrQNU4/esGZ+cao6lzyIcbjAMk+KrnIEz4NQ6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXGja/yNvTwopuKAizqS+qAKCamj/6W9q+LT2+5HUSeeJG+dugthqU5OFw5Ekzcty/tO0Rsmk5mr78CHoICbLsxnkJPz990boetpEBUWlAZxdfCanUiiMMOu9JEP5ID0XlVUky7kx2hjWbCrvt3YJz3cxA3GeKeEZIIIRC6AtdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcqNREGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcqNREGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D401F000FF;
	Sat, 12 Sep 2026 07:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198728;
	bh=0obdTJAa0Vp8Hf94LSCAFBfX3UJ54XcSvKEyUocMifQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcqNREGtTdN7PqbKM+7rIW96ftKbFEsL2wUQy0DH4idWsprTzL6f7hJzNbZPk2Yk3
	 Qulo3jLrW9NRC4ZnPd3W10UzV87YO8hFhKMf0jLrfkxlS3Jnw27tg24nCv03YouWPP
	 HK2UcSE7KNwDxqr412V7X1wMCAygVMY0OpxSM8A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0439/1815] cpufreq: schedutil: Fix self-contradictory comment in sugov_iowait_apply()
Date: Sat, 12 Sep 2026 08:36:29 +0200
Message-ID: <20260912065659.197727530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 614ff0d33c016..835df03e3d7b1 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -325,7 +325,7 @@ static void sugov_iowait_boost(struct sugov_cpu *sg_cpu, u64 time,
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




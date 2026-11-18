Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058543;
	b=nOYz3+nrj+UzQ01+XWwr0CR5mED9SWMLSoqknduvkPW9V02WgpTjZwiMU2jfcakbZtxd
	 B5lbxlaFuu3thgLR9G26skQN6DN4O6RYZ8BFVTLEEqUqfHD+C7AktdS0Kq+yIIWyCEEtm
	 3+A18iF+DUvZOs52+HAgh0kQjfFppZRym+R6j0xtDE3OZHdUWMCyR1+a2wxHHRA2gtI1e
	 oUH/+5YKdN2vf8Aa44/u/KxQ19NM0Ntp9zliR+Sk/w5toUY1Bszu1gDicMViF+0d2i6LB
	 CXizffDkH0r73cEO64vp3i2MkqJcQbcWkz+f/q5FAxgf0m27WotifDMzsZiiIAzQvZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Mz0mz/SHzU4AwCIGoIxHZKLq7OPxeszzHnOQ1OioTY=;
	b=l6PtAAyT/l34Uok3EQyVxZnkMzgOLR9Uyk1DCNJclDemtlejjs8lAKSszIb1EJVDp1uD
	 wCnHPlloVLBhOWShj1jumL0qGob1P/g1Y8k6uBiDQ7TDUMTl3eh/3tCMoE7cqyR4sykF1
	 xlsRvCFkDawHxPYYIkTZZQ2nx2WD0BRGYx3GvIXa0/JRsuLkRC3B/oECDNjAOVYyESGOU
	 OBljjBB0EdSGUY2jrZkBkbUi1xFcIqb8R46ie5Z9gs1rjOySDCYDmc6+5ckM4FEeFOgtd
	 p5EaudVsSIDwj9QwU9H3m1YhwLwwbLWPytru06qMYo6fhoVGojpB5yMi1nCYRWXpw/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cplCCffR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425B5606A326;
	Thu, 19 Nov 2026 03:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cplCCffR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB291F000C4;
	Thu, 19 Nov 2026 03:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058543;
	bh=3Mz0mz/SHzU4AwCIGoIxHZKLq7OPxeszzHnOQ1OioTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cplCCffRTWbZLmV7USKg85SQyTNtazAZ3j4LXgG+5MHtiCksPTdq+N2E5qMr8vfPV
	 eOuyMLSHux688GGKQLtbNgsRI0wRrz9inhQsZ09e28YK9Hrci0jA//MEj5DJKtfgRb
	 0Sfyz0s/fZYRm0MqTpJWIA3mk8I/g20l179RT7KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Hui Su <sh_def@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0522/1848] cpufreq: schedutil: Serialize sugov_start() against rate limit updates
Date: Wed, 18 Nov 2026 15:42:40 +0100
Message-ID: <20261118145936.598803453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit ce390caf5541c493c9061e7a2d98a463e66b736a ]

The current value of sg_policy->tunables->rate_limit_us is used in
sugov_start() without locking to update sg_policy->freq_update_delay_ns,
so if rate_limit_us_store() runs in parallel with it, the rate limit
update may go unnoticed and the new freq_update_delay_ns value may be
stale until the rate limit is updated again.

To avoid that, acquire the update_lock mutex of the rate limit sysfs
attribute, that is held by rate_limit_us_store() during rate limit
updates, around the freq_update_delay_ns in sugov_start().

Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on scheduler utilization data")
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Hui Su <sh_def@163.com>
Cc: All applicable <stable@vger.kernel.org>
[ rjw: Subject adjustment, new changelog, edits of the new comment ]
[ rjw: Add empty code line after guard()() ]
Link: https://patch.msgid.link/20261013034235.2678177-1-sh_def@163.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 98e7010ac07fc..609fe254b5b01 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -78,6 +78,18 @@ static void sugov_update_rate_limit_us(struct sugov_policy *sg_policy)
 		(s64)sg_policy->tunables->rate_limit_us * NSEC_PER_USEC;
 }
 
+static void sugov_update_rate_limit_us_sync(struct sugov_policy *sg_policy)
+{
+	/*
+	 * Serialize with rate_limit_us_store() to prevent this path from using
+	 * a stale rate limit tunable value to set the limit for the given
+	 * policy.
+	 */
+	guard(mutex)(&sg_policy->tunables->attr_set.update_lock);
+
+	sugov_update_rate_limit_us(sg_policy);
+}
+
 static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
 {
 	s64 delta_ns;
@@ -857,7 +869,7 @@ static int sugov_start(struct cpufreq_policy *policy)
 	struct sugov_policy *sg_policy = policy->governor_data;
 	unsigned int cpu;
 
-	sugov_update_rate_limit_us(sg_policy);
+	sugov_update_rate_limit_us_sync(sg_policy);
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;
-- 
2.53.0




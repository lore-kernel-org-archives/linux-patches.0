Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052660;
	b=vz/nkJq5Gf+QEWZa/P7XXi3r0SiSl/Io2/FHb3Xrn/+4+54A8egPysrvQEQ3gb7+Q9Zs
	 5Uy0C4DoVQrFAcpjBV4DuzR8xY3zXf4MVjhrfQSBz3V6NTDgwU7CcPSy/jgahplRWzUxe
	 f/7qqpJcpXxYs2LePGpCX6Jiyj9rE6XmkiBeqMnbMTJwI7l9eBNetu7WNRxmW4pJCJ0vW
	 xa2ggnsYyE7NAZJpeH5WG1tRKC+G/bntffFDulCOS4JMeBVWXW9wfM4hzk0zRR2ZRK+wm
	 vHAHxIPb0zCndSoulGNaMsKsBt0OVzSXWedS7emsSjpbORUScYah+emFOCSslDboAzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ok9Xacj91vZq6hz8JgHPHaHEhtXLUBpct5HcSDOT2ms=;
	b=fjATuwUNvlPrfX7Gk0meiwrGY5Xfz6tE2BNQ7nTrW1QPvGB8teR5eaiGVARiy/PtRAVM
	 o396iIP/RKntf2CQ1uIxv8H88JrH1GO7Jv8Z79pd6+eFX0XqSX2hkwVW+FiF6uxmojL3x
	 TPpWf6dlyLs/zk3QQhwTHlBlJljpkHqPlxwSAHzYuK14n9jqmlqSMC92sHpYRBQ0ff6wL
	 OUnJDHixndC0g+CHurLc6ILs6VcHqlFpjV03VC1zgpsiZuwFXkx/xEO1J9vVe/dXlS1l5
	 ufYVfIG+PQkyXeDwOLVmyWgaIJKJIbnB+eF0wahwnCocgRSo/1j1rgAJo31J85o7AzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vgkpywkf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2418606A320;
	Thu, 19 Nov 2026 01:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vgkpywkf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B211F000C4;
	Thu, 19 Nov 2026 01:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052660;
	bh=Ok9Xacj91vZq6hz8JgHPHaHEhtXLUBpct5HcSDOT2ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgkpywkfjVMGMpRetIoDQVNl2IoZs9HvRBQWkqKSmnccrXKNVUvWNHBtaWzw28gro
	 ZZAENu03Rm4yVAQF6QS11vshouD+Zs5H84YfxW0T1M/p1AbVOcSMOS4Lu01MOW3EwC
	 K9Rfvz3XEFt/SoEmmEnZ/bnZgxTxGAAIIEIGoS+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Hui Su <sh_def@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0644/2214] cpufreq: schedutil: Serialize sugov_start() against rate limit updates
Date: Wed, 18 Nov 2026 15:38:40 +0100
Message-ID: <20261118150037.093029194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8692d5e7e9ce4..351cc92829ef3 100644
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
@@ -790,7 +802,7 @@ static int sugov_start(struct cpufreq_policy *policy)
 	void (*uu)(struct update_util_data *data, u64 time, unsigned int flags);
 	unsigned int cpu;
 
-	sugov_update_rate_limit_us(sg_policy);
+	sugov_update_rate_limit_us_sync(sg_policy);
 	sg_policy->last_freq_update_time	= 0;
 	sg_policy->next_freq			= 0;
 	sg_policy->work_in_progress		= false;
-- 
2.53.0




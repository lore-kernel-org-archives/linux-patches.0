Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618413;
	b=XczOUMJAEDckgmJ+hFyZRcgOUkjg5xSukby/l2QUvLimajeaogyo6QUWRLnylGxTeLgw
	 /p3U9ba4LZTx8O6bkimuRPviB3g5M/TmNfnsTf5DUNRSf4ksYyCw5QCMX6C0e0z+qT7d9
	 M1Rr8AmRME0r1OP1Q65GrLxSim3c0cpYi0q9chw1IhzHNLI05hf0+FSNneDql7TZPdqi1
	 fYmUT/uuE1T8PVg3/Oxyn9LjR+Dmt2g2JkKZaXV+2H0gQVUwna3zp0M3huF5eQBYkeuej
	 iwHWpWv90OTZZuitTkbiB4dujqwfeT8PLiyn7IjEQ1cUi3yxJHPFcMCr3kK4sjecpGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzPeOfj6gHMV2aPHp6vQRLxZfUTIRqLx82VbwOD+eto=;
	b=2f4QqD8ALM6SBWUrtZjFduWpIdOlC/uuZIvmR7Y4LlPC/4JMRYo1lXe7jTeg8SueTfzw
	 TPQik8COfChlXVWpaLjQY9fKQl/LXM7iRmRy9WNFnfQKMzDVBsOaz78BJAxeAygPa8lhK
	 j/8E1DrgNEOh81hRTqQTL30oYVss9ZpBdH/VkCqLCur3R81YNkQtjwk41RrdxuDxhKkxO
	 /wJmyhEtvbNIpDypvuBAg9Ky17bQbmfe/jyIfvBFaELIvoh/Xbsql0KCN/M2A8GAwX8DY
	 Dmf41WOu3z14KJ05DieFLDdVvup1Ud5OIb1ianb8z9OtllcKjfY5gmJXXJxy5qmyhxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vy+rAO4p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D96606A31E;
	Wed, 25 Nov 2026 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vy+rAO4p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99591F000C4;
	Wed, 25 Nov 2026 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618413;
	bh=OzPeOfj6gHMV2aPHp6vQRLxZfUTIRqLx82VbwOD+eto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vy+rAO4pUVE4dpqEmaGCgG9HYT5FDN8sIZHfn73qzj18NE+mBmwT+oqqSMsgrp8P0
	 OMwWmQpy/FZ6w/PKlmK5a2va2KWTzDBycLrR+LQvcneNSTs79lPwg9tm1ViRjzVe0s
	 EKU8Fvi0T00Px3NAP84LuxBjo5KKQ3AWsU3e7MHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0273/1005] cpufreq: Hold the policy write lock when changing boost state
Date: Wed, 25 Nov 2026 15:26:51 +0100
Message-ID: <20261125143828.133891130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit e6f50e602e373583423654ec000cad8b8d08f7bc ]

The per-policy boost sysfs handler calls policy_set_boost() under
policy->rwsem, but the global boost handler and cpufreq_online() do not.
Consequently, global and per-policy boost changes can concurrently
update policy->boost_enabled, invoke the driver callback and update the
boost frequency QoS request. The driver callbacks also access policy
state, e.g. CPPC updates cpuinfo.max_freq that assumes policy->rw_sem
held.

Take policy->rwsem around policy_set_boost() in both unlocked
callers. Keep locking at the call sites because the per-policy sysfs
handler already holds the lock.

Fixes: 218a06a79d9a ("cpufreq: Support per-policy performance boost")
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/be3739f8-e668-4711-912c-91459d77ed35@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 54dde8419bdc4..015962e6c1fe4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -576,6 +576,8 @@ static int policy_set_boost(struct cpufreq_policy *policy, bool enable)
 {
 	int ret;
 
+	lockdep_assert_held_write(&policy->rwsem);
+
 	if (policy->boost_enabled == enable)
 		return 0;
 
@@ -1629,6 +1631,8 @@ static int cpufreq_online(unsigned int cpu)
 	 */
 	if (cpufreq_driver->set_boost && policy->boost_supported &&
 	    (new_policy || !cpufreq_boost_enabled())) {
+		guard(cpufreq_policy_write)(policy);
+
 		ret = policy_set_boost(policy, cpufreq_boost_enabled());
 		if (ret) {
 			/* If the set_boost fails, the online operation is not affected */
@@ -2830,6 +2834,8 @@ static int cpufreq_boost_trigger_state(int state)
 		if (!policy->boost_supported)
 			continue;
 
+		guard(cpufreq_policy_write)(policy);
+
 		ret = policy_set_boost(policy, state);
 		if (unlikely(ret))
 			break;
-- 
2.53.0




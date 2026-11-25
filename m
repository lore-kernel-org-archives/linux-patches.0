Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619820;
	b=RBbjmfj0hIllA9wTkKbToQdwDyrx+/GmRrbdkW8RPzHIJMcElQmXJwpvVk+QN5+iCTtT
	 PbGjjns4bCUObXx+dnbNOS+zK22PifntIfZRznhXiytsbtUdMFRQLZg0QO9j4PSstIM60
	 /H4BySKxp55vmanoXoyTuU8HBx5K8FeQu5zbNYfSgz+A9EkGOVkdM8nfPv3N1L05pymDW
	 LjRonlhYOiOxLvPAEyubn+pk0gsxG0L9o+pb0iwhc14D3Q9y3W27RnNXv1sYlKYNg3sNz
	 3LWvlqb6wnxyN8Mn3WeDVTILpGJZXqNvb1VUbXM2pEfzlhqsa7FvOvoUeoQwOeBg8jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DBGGSJnkJy2qm9KnpyaVnuYsNQZEk9O1tfiJeRCk6Mw=;
	b=qdHRbpodkdPGNxhwu6suJyih53qBcjhfamMNyosnNCMWfozSgTyknW7sRo8O5p4zHzI/
	 MszMizXb4uzJG2XN3taQ6d17npdCHuJb1kEmm1F67RcEB+2Ji59dJunBAzMVNL+FgB33w
	 7/CW4QcG3TXu3xr57z3ry67FIxPC4b5Hn+2KLXVrJa2F0esr0kEQS63JiENFX0ACHau3K
	 q+bIvlGbBW0G5xBVc7xbXRPqqazWvvV8aYWV0BSwDj0q5MyR+0H1YJ9w53yQRmnb7i1iq
	 n8scwhGM8/qgF+P1Eil/oJEW6V8HMUegNdgnHvst+BymMk/eSpRcIA2ZE1LS7B26bSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDyWq52P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC36B606A321;
	Wed, 25 Nov 2026 15:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDyWq52P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFCF1F000C0;
	Wed, 25 Nov 2026 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619820;
	bh=DBGGSJnkJy2qm9KnpyaVnuYsNQZEk9O1tfiJeRCk6Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDyWq52PfLcU44CrSrZiQgFE6lWKt+hMQvE4U5OaRff1AKc/ZEa8djzLD2gw3sKEU
	 tkIfBZBpSNndbABlVvDtTlLvtuAPGl9YRHsScV/aqXQ/V7fcqw510QbLOXVO2HxwFz
	 g5Qu7SfraF7TwHioeNnor2QQ+WmHNQ2oso5zx5IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zak Brighton Knight <zakbrightonknight@gmail.com>,
	Doug Smythies <dsmythies@telus.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 7.3 0718/1005] cpufreq: Force passing target frequency to driver during resume
Date: Wed, 25 Nov 2026 15:34:16 +0100
Message-ID: <20261125143838.577342311@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 342d3a73c5dbc2f1cd0c5142e2d11bda4dc54cd7 upstream.

The policy->cur value preserved across a system suspend-resume cycle
may become stale in some cases and it may prevent the CPU performance
scaling logic from being updated due to the target_freq == policy->cur
check in __cpufreq_driver_target() [1].

To address this, adjust the existing mechanism to force the invocation
of the driver .target() callback in __cpufreq_driver_target() and make
cpufreq_resume_policy() use it.

This involves renaming update_limits in struct cpufreq_policy to
force_target and moving the driver CPUFREQ_NEED_UPDATE_LIMITS flag check
from __cpufreq_driver_target() to cpufreq_set_policy(), where it is used
as a condition for setting policy->force_target.

In cpufreq_resume_policy(), policy->force_target is set for drivers that
implement the .target() callback, but don't implement the .get() one,
which is the case when the driver callback needs to run if policy->cur
becomes stale while suspended.

Fixes: 2f0aea936360 ("cpufreq: suspend governors on system suspend/hibernate")
Link: https://lore.kernel.org/linux-pm/20261027143725.3763827-1-zakbrightonknight@gmail.com/ [1]
Reported-by: Zak Brighton Knight <zakbrightonknight@gmail.com>
Reported-by: Doug Smythies <dsmythies@telus.net>
Cc: All applicable <stable@vger.kernel.org> # eee2a44e4e2b cpufreq: Improve suspend-resume synchronization
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Zak Brighton Knight <zakbrightonknight@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/1995295.tdWV9SEqCh@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |   33 +++++++++++++++++++++------------
 include/linux/cpufreq.h   |    4 ++--
 2 files changed, 23 insertions(+), 14 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2027,6 +2027,15 @@ static void cpufreq_resume_policy(struct
 	if (!start)
 		return;
 
+	/*
+	 * Force executing the driver .target() callback, if present, in the
+	 * next invocation of __cpufreq_driver_target() in case policy->cur has
+	 * become stale while suspended, but do it only for drivers without a
+	 * .get() callback for which cpufreq_verify_current_freq() is a NOP.
+	 */
+	if (cpufreq_driver->target && !cpufreq_driver->get)
+		policy->force_target = true;
+
 	if (cpufreq_start_governor(policy))
 		pr_err("%s: Failed to start governor for CPU%u's policy\n",
 		       __func__, policy->cpu);
@@ -2404,17 +2413,14 @@ int __cpufreq_driver_target(struct cpufr
 		policy->cpu, policy->cur, target_freq, old_target_freq, relation);
 
 	/*
-	 * This might look like a redundant call as we are checking it again
-	 * after finding index. But it is left intentionally for cases where
-	 * exactly same freq is called again and so we can save on few function
-	 * calls.
+	 * Unless invoking the target callback is forced, skip the update if the
+	 * frequency is not really changing.
 	 */
-	if (target_freq == policy->cur) {
-		if (!(cpufreq_driver->flags & CPUFREQ_NEED_UPDATE_LIMITS) ||
-		    !policy->update_limits)
-			return 0;
-
-		policy->update_limits = false;
+	if (policy->force_target) {
+		/* Avoid forcing the driver callback unnecessarily next time. */
+		policy->force_target = false;
+	} else if (target_freq == policy->cur) {
+		return 0;
 	}
 
 	if (cpufreq_driver->target) {
@@ -2673,6 +2679,7 @@ static int cpufreq_set_policy(struct cpu
 			      struct cpufreq_governor *new_gov,
 			      unsigned int new_pol)
 {
+	bool need_update_limits = cpufreq_driver->flags & CPUFREQ_NEED_UPDATE_LIMITS;
 	struct cpufreq_policy_data new_data;
 	struct cpufreq_governor *old_gov;
 	unsigned int freq;
@@ -2712,7 +2719,8 @@ static int cpufreq_set_policy(struct cpu
 			      CPUFREQ_RELATION_H);
 	if (freq != policy->max) {
 		WRITE_ONCE(policy->max, freq);
-		policy->update_limits = true;
+		if (need_update_limits)
+			policy->force_target = true;
 	}
 
 	freq = __resolve_freq(policy, new_data.min, new_data.min, new_data.max,
@@ -2720,7 +2728,8 @@ static int cpufreq_set_policy(struct cpu
 	freq = min(freq, policy->max);
 	if (freq != policy->min) {
 		WRITE_ONCE(policy->min, freq);
-		policy->update_limits = true;
+		if (need_update_limits)
+			policy->force_target = true;
 	}
 
 	trace_cpu_frequency_limits(policy);
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -146,8 +146,8 @@ struct cpufreq_policy {
 	/* Per policy boost supported flag. */
 	bool			boost_supported;
 
-	/* Pending policy->min/max update for the driver */
-	bool			update_limits;
+	/* Force passing target frequency to the driver. */
+	bool			force_target;
 
 	/* The policy has been suspended. */
 	bool			suspended;



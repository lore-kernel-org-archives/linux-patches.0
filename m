Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619826;
	b=Xh+ZKuuyUCi5Ayywcd0ssHKDc7CVh4PbOKaCTUR3nW0whs21dtEEyyBr3zUO+3Leu3gm
	 L0sbCVSvbyOZ3a+L5C1qe/aV7tPMLu8q344ufBT1kNH0bOGKJit/iSEA3clz+bkPAf4ml
	 BX6ePKF8sbw7X4gy3k2MeDUSFwGAQJrdlQ4iMkYP7tPsTCYX2MFlNSQdKcu6NyOMCCopw
	 4dquNfKVO57z3WLmSZzt5tXZFkrTlltIRRWEhIynob6mZet9KniGzmYEzGDVIRqPIfHMt
	 T8zbiIgpehJp757+fRVW8g932dc29FoX7Uj/gn7ThBMqYl4je39jZEC0B/F4ldV56sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IyyuqTlflHEYEAaFYkbCKzDEb1wa3Lp7jmZ2cOyAHuE=;
	b=DN5C38LBoTePTWMZHpmGKYI3O2yozXKyX6k++xW4gL6AYGt8nHmPnJ4qHKusAO03FUxi
	 KQNAsJc298s0JCzRIYfxl24YOIAB3/vKJnRGyScO7Q+ToLwjDrrOMGdW7YxkFkV2rOndU
	 GKffHkfn4jSIl/Qs8dibBlgNE+e47/pXwmMKG6iQtyl/bPQ1CIuNrmqhWX35yA5dSt6jy
	 SvoKWub+cbqiB4mzvutXfi4HEVRasMSlzvCvAfJ9ZwlkPHra9bT9HdUxykwlirJrs7vH5
	 qVU+pZo3AnNvd5fA4M3NNJsONJxpGVPjAzl2tBlLNiPRuHcfB9hH+PkeoB0IFhhgukQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xbQaHQ9c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B22606A337;
	Wed, 25 Nov 2026 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xbQaHQ9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA11E1F000C0;
	Wed, 25 Nov 2026 15:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619826;
	bh=IyyuqTlflHEYEAaFYkbCKzDEb1wa3Lp7jmZ2cOyAHuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbQaHQ9cOzVJCRgtZE46bm1RnMJtGmgohSEsW/1prZbXSw0OTjUc2+x41Dzmj2yfA
	 OTKHPtKl7zCRYlJT49gfKu1GCyx6VguaKuhGRiZdpTyyNpd+0apW0Ds8n1r4ruhQYk
	 2LC1qdifYlBSce3r5/5uzhEVUqXDy/gPTX5y3Zwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 7.3 0720/1005] cpufreq: Fix updates of cached resolved frequency and index
Date: Wed, 25 Nov 2026 15:34:18 +0100
Message-ID: <20261125143838.623893997@linuxfoundation.org>
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

commit 75120f31aed010c326b28d7c80d22314df34d9a8 upstream.

The cached resolved frequency and index, cached_target_freq and
cached_resolved_idx, respectively, may be updated concurrently if
cpufreq_driver_resolve_freq() is called by the schedutil governor
while cpufreq_set_policy() is running for the same policy.  Those
concurrent updates are not synchronized in any way and the values
written by cpufreq_set_policy(), if it wins the race, may confuse
drivers using those policy fields [1].

To address this, use the observation that the only place where
cached_target_freq and cached_resolved_idx need to be updated is
cpufreq_driver_resolve_freq() because the only legitimate users of
them are .fast_switch() driver callbacks.  Although cached_resolved_idx
is also used in __cpufreq_driver_target(), that is in fact unnecessary
and it is better to use a local variable for storing the frequency
table index in that function.

Accordingly, rearrange __resolve_freq() and its callers so that
cached_target_freq and cached_resolved_idx are only updated in
cpufreq_driver_resolve_freq().

The cached_target_freq initialization in cpufreq_set_policy() is still
needed, but move it after stopping the old governor and before starting
the new one to avoid racing with cpufreq_driver_resolve_freq().

Fixes: f9ccdec24d91 ("cpufreq: Reuse cpufreq_driver_resolve_freq() in __cpufreq_driver_target()")
Fixes: 151717690694 ("cpufreq: Make policy min/max hard requirements")
Reported-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-pm/20261105140357.1331894-1-zhongqiu.han@oss.qualcomm.com/ [1]
Co-developed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Cc: All applicable <stable@vger.kernel.org> # 342d3a73c5db cpufreq: Force passing target frequency to driver during resume
Cc: All applicable <stable@vger.kernel.org> # 166207cac451 cpufreq: Cache post-resolution target frequency in __resolve_freq()
Link: https://patch.msgid.link/3472677.aeNJFYEL58@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -477,7 +477,7 @@ EXPORT_SYMBOL_GPL(cpufreq_disable_fast_s
 static unsigned int __resolve_freq(struct cpufreq_policy *policy,
 				   unsigned int target_freq,
 				   unsigned int min, unsigned int max,
-				   unsigned int relation)
+				   unsigned int relation, unsigned int *idx_p)
 {
 	unsigned int idx;
 
@@ -487,9 +487,10 @@ static unsigned int __resolve_freq(struc
 		return target_freq;
 
 	idx = cpufreq_frequency_table_target(policy, target_freq, min, max, relation);
-	policy->cached_resolved_idx = idx;
-	policy->cached_target_freq = policy->freq_table[idx].frequency;
-	return policy->cached_target_freq;
+	if (idx_p)
+		*idx_p = idx;
+
+	return policy->freq_table[idx].frequency;
 }
 
 /**
@@ -520,7 +521,10 @@ unsigned int cpufreq_driver_resolve_freq
 	if (unlikely(min > max))
 		min = max;
 
-	return __resolve_freq(policy, target_freq, min, max, CPUFREQ_RELATION_LE);
+	policy->cached_target_freq = __resolve_freq(policy, target_freq, min, max,
+						    CPUFREQ_RELATION_LE,
+						    &policy->cached_resolved_idx);
+	return policy->cached_target_freq;
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_resolve_freq);
 
@@ -2402,12 +2406,13 @@ int __cpufreq_driver_target(struct cpufr
 			    unsigned int relation)
 {
 	unsigned int old_target_freq = target_freq;
+	unsigned int idx = 0;
 
 	if (cpufreq_disabled())
 		return -ENODEV;
 
 	target_freq = __resolve_freq(policy, target_freq, policy->min,
-				     policy->max, relation);
+				     policy->max, relation, &idx);
 
 	pr_debug("CPU %u: cur %u kHz -> target %u kHz (req %u kHz, rel %u)\n",
 		policy->cpu, policy->cur, target_freq, old_target_freq, relation);
@@ -2437,7 +2442,7 @@ int __cpufreq_driver_target(struct cpufr
 	if (!cpufreq_driver->target_index)
 		return -EINVAL;
 
-	return __target_index(policy, policy->cached_resolved_idx);
+	return __target_index(policy, idx);
 }
 EXPORT_SYMBOL_GPL(__cpufreq_driver_target);
 
@@ -2716,7 +2721,7 @@ static int cpufreq_set_policy(struct cpu
 	 * concurrently by cpufreq_driver_resolve_freq() during the update.
 	 */
 	freq = __resolve_freq(policy, new_data.max, new_data.min, new_data.max,
-			      CPUFREQ_RELATION_H);
+			      CPUFREQ_RELATION_H, NULL);
 	if (freq != policy->max) {
 		WRITE_ONCE(policy->max, freq);
 		if (need_update_limits)
@@ -2724,7 +2729,7 @@ static int cpufreq_set_policy(struct cpu
 	}
 
 	freq = __resolve_freq(policy, new_data.min, new_data.min, new_data.max,
-			      CPUFREQ_RELATION_L);
+			      CPUFREQ_RELATION_L, NULL);
 	freq = min(freq, policy->max);
 	if (freq != policy->min) {
 		WRITE_ONCE(policy->min, freq);
@@ -2736,8 +2741,6 @@ static int cpufreq_set_policy(struct cpu
 
 	cpufreq_update_pressure(policy);
 
-	policy->cached_target_freq = UINT_MAX;
-
 	pr_debug("new min and max freqs are %u - %u kHz\n",
 		 policy->min, policy->max);
 
@@ -2763,6 +2766,12 @@ static int cpufreq_set_policy(struct cpu
 		cpufreq_exit_governor(policy);
 	}
 
+	/*
+	 * Initialize cached_target_freq while no governor is running to avoid
+	 * racing with cpufreq_driver_resolve_freq(), which updates it.
+	 */
+	policy->cached_target_freq = UINT_MAX;
+
 	/* start new governor */
 	policy->governor = new_gov;
 	ret = cpufreq_init_governor(policy);



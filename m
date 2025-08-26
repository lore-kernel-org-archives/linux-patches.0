Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1C131DD93;
	Tue, 26 Aug 2025 13:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213775; cv=none; b=IoC8a4INqlku6hHsbr0U6F9q3dG9z62jyawwM6pNJhUKksdgjyCavECocp4HAupeFduByFJsZc7d2MmaaVdjPqAOcugwG4oC9uteUwOehUdjOIHFiZZgKKgSfwlvGUjuvGioineomz7Z6qfDxIYajK8Lr4d1Orc+amztY3DzV5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213775; c=relaxed/simple;
	bh=eJ4/1RrMBMl4IjPpg6vpHlPEnR7OyM+R4UicRdVd1f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXlR5yHUVxg6yt0AzIqw34MKVDVZdhhqYv0qlMKetW/4o53scIgqvZ0ZmUd5FZ4kqHK5T/TR+PqBb2elSWupDQ8iLPExCJ9+r+mpkLa+u9x5LcXsfwSjhuNt0OB3/+4uVrSKC+fvmr+n5tjYzrY76AqOXaboKGUe5bxulsycy5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/IOE/w4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/IOE/w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CC2C4CEF1;
	Tue, 26 Aug 2025 13:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213775;
	bh=eJ4/1RrMBMl4IjPpg6vpHlPEnR7OyM+R4UicRdVd1f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/IOE/w4N4RYPslAiHgrJ5CTliGmldbD60pOUGO/MrtU/pGvHKz7zAG+smLcMbjdy
	 Kh3UUA6MdlTfeaAFYYBEJR+ai/63nV5w+rFzHnz6nLSP9epsrsUPAs+JDxSg0ktcrA
	 uzzdhXtgMoznjqUTPLZ/Bwy7vMsfvM9aWFyMJ3hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ingo Molnar <mingo@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6 473/587] cpufreq/schedutil: Use a fixed reference frequency
Date: Tue, 26 Aug 2025 13:10:22 +0200
Message-ID: <20250826111005.003320251@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vincent Guittot <vincent.guittot@linaro.org>

commit b3edde44e5d4504c23a176819865cd603fd16d6c upstream.

cpuinfo.max_freq can change at runtime because of boost as an example. This
implies that the value could be different than the one that has been
used when computing the capacity of a CPU.

The new arch_scale_freq_ref() returns a fixed and coherent reference
frequency that can be used when computing a frequency based on utilization.

Use this arch_scale_freq_ref() when available and fallback to
policy otherwise.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20231211104855.558096-4-vincent.guittot@linaro.org
Stable-dep-of: e37617c8e53a ("sched/fair: Fix frequency selection for non-invariant case")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/cpufreq_schedutil.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -138,6 +138,28 @@ static void sugov_deferred_update(struct
 }
 
 /**
+ * get_capacity_ref_freq - get the reference frequency that has been used to
+ * correlate frequency and compute capacity for a given cpufreq policy. We use
+ * the CPU managing it for the arch_scale_freq_ref() call in the function.
+ * @policy: the cpufreq policy of the CPU in question.
+ *
+ * Return: the reference CPU frequency to compute a capacity.
+ */
+static __always_inline
+unsigned long get_capacity_ref_freq(struct cpufreq_policy *policy)
+{
+	unsigned int freq = arch_scale_freq_ref(policy->cpu);
+
+	if (freq)
+		return freq;
+
+	if (arch_scale_freq_invariant())
+		return policy->cpuinfo.max_freq;
+
+	return policy->cur;
+}
+
+/**
  * get_next_freq - Compute a new frequency for a given cpufreq policy.
  * @sg_policy: schedutil policy object to compute the new frequency for.
  * @util: Current CPU utilization.
@@ -163,9 +185,9 @@ static unsigned int get_next_freq(struct
 				  unsigned long util, unsigned long max)
 {
 	struct cpufreq_policy *policy = sg_policy->policy;
-	unsigned int freq = arch_scale_freq_invariant() ?
-				policy->cpuinfo.max_freq : policy->cur;
+	unsigned int freq;
 
+	freq = get_capacity_ref_freq(policy);
 	freq = map_util_freq(util, freq, max);
 
 	if (freq == sg_policy->cached_raw_freq && !sg_policy->need_freq_update)



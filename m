Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704371;
	b=vGZ0SjXP6O+uPI9jqC3yxzS1499FgJQjkTcpaqna2CDNqcZaNbsZVvlHu66H72nvdLGu
	 y2akpzOuJ+xBvg5zRmspYbehpwziajKywNGUYkUj9ToVj2csYztDZNQqZlKWNmTzmwIs3
	 MFjA7jVdEuSRRnOo2RPvxKCaqStX66b9YrVcNs/LEBuvEwpx1kY80jtvjKxy1dJ7dI+mM
	 IOkVJ4CtUqbbwOps9OvXdGW/DUWcuOlXKw1Qv+x796CuHYxYS4DpD11HpkeG/7BAS1aUe
	 L2byirAjzZ6t37txudeYHS1JxL/QdzHMlOlNjSyxAij8NdmXIja8eyBZbn/kIxpElVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l5wDpLyz9G65h6/66v23z+VXj9AVH4JUtP5DxhNhleU=;
	b=D/stPMjpjyLidphNHyG61/MY+6c8F068FYnHUwXdNCBWnecZ8cA5v16Jubtrcbcz4mCA
	 CNprTt7qr3Q4hCdl8W83oU4luLLVctgq5Ii8gJvFk92Z3SrAX1XNgtV5my8E9ExqXAQnM
	 4BAeLnco1hO6Xlvm6y0VQpqt813xKZEOypNtMD0rZ6jrJ0jCPJKVDyFne+q1ECfqlNj/8
	 M8jNMVSl+rhU7C8BsoaKuaRYIOQzQXEC8VnSta9RWNsBzzgO1BoqLcGToK9V47tf0yYIE
	 8kJjsu5CZ1n1LpatKzJHz28Ce//AAWGazXZ6jFNjxu5SH0MNcO6k+GWJnSoYUZn1lXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cits1wak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B5C606A326;
	Thu, 26 Nov 2026 14:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cits1wak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4301F000C0;
	Thu, 26 Nov 2026 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704371;
	bh=l5wDpLyz9G65h6/66v23z+VXj9AVH4JUtP5DxhNhleU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cits1wak/cTdtSGP62vckoyScSReEQo1MoxvgYYnFCJ8zK4E3xMKrwoPM1XiCwtGN
	 IPpoyRqom3ZkMWVc+4mJcvBGcdjDWreyYoLSrRUOyMq2I3p03QZrfaSIDQUW7Ne1RR
	 lroYu/gBMrtxm4SXO7kvYFhb2ZGqy4+0bqhrCXNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/265] cpufreq: Replace deprecated CPU-hotplug functions
Date: Thu, 26 Nov 2026 15:37:12 +0100
Message-ID: <20261126143612.138560866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 09681a0772f773dddffd3c2d1796c87bd0d903b9 ]

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: a0cde2b601bc ("cpufreq: Preserve global boost state on failed updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/acpi-cpufreq.c     | 4 ++--
 drivers/cpufreq/cpufreq.c          | 6 +++---
 drivers/cpufreq/cpufreq_ondemand.c | 4 ++--
 drivers/cpufreq/intel_pstate.c     | 4 ++--
 drivers/cpufreq/powernow-k8.c      | 6 +++---
 drivers/cpufreq/powernv-cpufreq.c  | 4 ++--
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 0f74c5e5ed0f7..ee545f0ce666d 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -163,9 +163,9 @@ static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
 	if (ret || val > 1)
 		return -EINVAL;
 
-	get_online_cpus();
+	cpus_read_lock();
 	set_boost(policy, val);
-	put_online_cpus();
+	cpus_read_unlock();
 
 	return count;
 }
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 47ba1e73e77cf..585ad335f1c31 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2651,18 +2651,18 @@ int cpufreq_boost_trigger_state(int state)
 	cpufreq_driver->boost_enabled = state;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	get_online_cpus();
+	cpus_read_lock();
 	for_each_active_policy(policy) {
 		ret = cpufreq_driver->set_boost(policy, state);
 		if (ret)
 			goto err_reset_state;
 	}
-	put_online_cpus();
+	cpus_read_unlock();
 
 	return 0;
 
 err_reset_state:
-	put_online_cpus();
+	cpus_read_unlock();
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver->boost_enabled = !state;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index ac361a8b1d3bb..eb4320b619c9c 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -418,7 +418,7 @@ static void od_set_powersave_bias(unsigned int powersave_bias)
 	default_powersave_bias = powersave_bias;
 	cpumask_clear(&done);
 
-	get_online_cpus();
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
 		struct cpufreq_policy *policy;
 		struct policy_dbs_info *policy_dbs;
@@ -442,7 +442,7 @@ static void od_set_powersave_bias(unsigned int powersave_bias)
 		od_tuners = dbs_data->tuners;
 		od_tuners->powersave_bias = default_powersave_bias;
 	}
-	put_online_cpus();
+	cpus_read_unlock();
 }
 
 void od_register_powersave_bias_handler(unsigned int (*f)
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 7ae59be19a9ae..546c582787f21 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2744,7 +2744,7 @@ static void intel_pstate_driver_cleanup(void)
 {
 	unsigned int cpu;
 
-	get_online_cpus();
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
 		if (all_cpu_data[cpu]) {
 			if (intel_pstate_driver == &intel_pstate)
@@ -2754,7 +2754,7 @@ static void intel_pstate_driver_cleanup(void)
 			all_cpu_data[cpu] = NULL;
 		}
 	}
-	put_online_cpus();
+	cpus_read_unlock();
 
 	intel_pstate_driver = NULL;
 }
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 40bb3845d52dc..b4b97264d2c79 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1182,7 +1182,7 @@ static int powernowk8_init(void)
 	if (!x86_match_cpu(powernow_k8_ids))
 		return -ENODEV;
 
-	get_online_cpus();
+	cpus_read_lock();
 	for_each_online_cpu(i) {
 		smp_call_function_single(i, check_supported_cpu, &ret, 1);
 		if (!ret)
@@ -1190,10 +1190,10 @@ static int powernowk8_init(void)
 	}
 
 	if (supported_cpus != num_online_cpus()) {
-		put_online_cpus();
+		cpus_read_unlock();
 		return -ENODEV;
 	}
-	put_online_cpus();
+	cpus_read_unlock();
 
 	ret = cpufreq_register_driver(&cpufreq_amd64_driver);
 	if (ret)
diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 8977e4de59157..169ad5415ae19 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -911,7 +911,7 @@ static void powernv_cpufreq_work_fn(struct work_struct *work)
 	unsigned int cpu;
 	cpumask_t mask;
 
-	get_online_cpus();
+	cpus_read_lock();
 	cpumask_and(&mask, &chip->mask, cpu_online_mask);
 	smp_call_function_any(&mask,
 			      powernv_cpufreq_throttle_check, NULL, 0);
@@ -932,7 +932,7 @@ static void powernv_cpufreq_work_fn(struct work_struct *work)
 		cpufreq_cpu_put(policy);
 	}
 out:
-	put_online_cpus();
+	cpus_read_unlock();
 }
 
 static int powernv_cpufreq_occ_msg(struct notifier_block *nb,
-- 
2.53.0




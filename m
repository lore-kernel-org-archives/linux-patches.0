Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B82271475;
	Tue, 26 Aug 2025 13:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213891; cv=none; b=J2bEsooFIBIu1xe20MXJmz32JUaMJPjcgShGktONAhFbRSVg6Tj96eqeTSZ0vw3kzf3PBCneodR6r54qxy2wA5iH/iv2CQL9E6y2DxP7tVjSxBUUtRUfkdeKf160nmULqa4BvO4q3UIkzOBT87VRn5jA99/t1fmPzaB7Ftvz/Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213891; c=relaxed/simple;
	bh=TZxrheu/LczvGeV11FF9nraBP1owuLr9OdxArvGwprM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDJ0yAx0njv93wr2Uk3jzrJtCxC3x3DCjYkNdEPC4dqChTky53XGCVRUY3VhUTIz5wzbI0gw+nDYVklenmGtDPDWflRzGk52kVlT9Pm/tLaIYWDfIzox4BKR6GrrlJQ9Vh9SwxMuG52MRojn7J7B0FeLXYMUJBcO/zYgFUFdz+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZhJDzp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZhJDzp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8255CC4CEF4;
	Tue, 26 Aug 2025 13:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213890;
	bh=TZxrheu/LczvGeV11FF9nraBP1owuLr9OdxArvGwprM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZhJDzp9tmoI8E0YjOjo5wq9RrrmR3dMZYC+Vjcm6QVuwWyn50OdteMHLTx+5zISI
	 Aqrbb2aGUBX5snqBjK+buEEV3iPWU7L6ZvAi2sUWlVKb4QYT5kknPDKJWDCLHc7+0u
	 blUcSmA91aeRQWulDwxHXVnnudaJMabNQOjindT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Pierre Gondois <pierre.gondois@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Paul Barker <paul.barker.ct@bp.renesas.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.6 477/587] topology: Set capacity_freq_ref in all cases
Date: Tue, 26 Aug 2025 13:10:26 +0200
Message-ID: <20250826111005.103546555@linuxfoundation.org>
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

commit 98323e9d70172f1b46d1cadb20d6c54abf62870d upstream.

If "capacity-dmips-mhz" is not set, raw_capacity is null and we skip the
normalization step which includes setting per_cpu capacity_freq_ref.
Always register the notifier but skip the capacity normalization if
raw_capacity is null.

Fixes: 9942cb22ea45 ("sched/topology: Add a new arch_scale_freq_ref() method")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Pierre Gondois <pierre.gondois@arm.com>
Tested-by: Mark Brown <broonie@kernel.org>
Tested-by: Paul Barker <paul.barker.ct@bp.renesas.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20240117190545.596057-1-vincent.guittot@linaro.org
Stable-dep-of: e37617c8e53a ("sched/fair: Fix frequency selection for non-invariant case")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/arch_topology.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -417,9 +417,6 @@ init_cpu_capacity_callback(struct notifi
 	struct cpufreq_policy *policy = data;
 	int cpu;
 
-	if (!raw_capacity)
-		return 0;
-
 	if (val != CPUFREQ_CREATE_POLICY)
 		return 0;
 
@@ -436,9 +433,11 @@ init_cpu_capacity_callback(struct notifi
 	}
 
 	if (cpumask_empty(cpus_to_visit)) {
-		topology_normalize_cpu_scale();
-		schedule_work(&update_topology_flags_work);
-		free_raw_capacity();
+		if (raw_capacity) {
+			topology_normalize_cpu_scale();
+			schedule_work(&update_topology_flags_work);
+			free_raw_capacity();
+		}
 		pr_debug("cpu_capacity: parsing done\n");
 		schedule_work(&parsing_done_work);
 	}
@@ -458,7 +457,7 @@ static int __init register_cpufreq_notif
 	 * On ACPI-based systems skip registering cpufreq notifier as cpufreq
 	 * information is not needed for cpu capacity initialization.
 	 */
-	if (!acpi_disabled || !raw_capacity)
+	if (!acpi_disabled)
 		return -EINVAL;
 
 	if (!alloc_cpumask_var(&cpus_to_visit, GFP_KERNEL))



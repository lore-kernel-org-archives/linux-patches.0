Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705473;
	b=POb5ACf1jf3+yj2O6GI+zWcr+HclyQ6SRsrWKEO3/OTORGUaSe2sODWC9YEJbYUp1t3f
	 zg2YB+A0DrgmSlzRyJbyEVn5Zy727Z0XRUH9Vy1dUkO9CJB6+wA99xrCqn8yngbEpESAW
	 cfGKZ6rNSIE5oWmsmptoEU1c0G2zJLHNdmoI+QmnqX0wuiNTkSnAvmS1xA6Hz9d/aBmpC
	 eGoaZa2YCjLACl2KjT9CQ/H4yJsbgfbsoc7KtJrj6XP41G8fftLrhxyt19rYzEKvFRmN+
	 fPBWSA05iCljKOpGNSw1iidWhLFIbXota/BJEJOm9eqFGeIHOEv7Hxe6bm/E/lUi7kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ut0jKHCQCsZ4uET39KiJ/+6gY3sFwadgbKxYMwzrlkM=;
	b=AymZw2KDZgGeQMn0zCSaqraWhDgNHRz4co2rmdQchmMxi1+c1A/85wZzskdSg19q+BeY
	 E96XE1BZWfeW0rVOFwJ0jmpPg2QUI5fJzGUEBg2R2H/fp7tXuKbHdMua2IeBOmbImcSaa
	 2/knTmjY6ulpRsJouZRdreEr55Gwbsqu7TOc63zUCQ6TND0xb3p8tMiw/S5GyMRXukWwf
	 nZOTv9UBR44ca+eU0IKxAUhCUr+qjmYrjclQNwhL3oH70YsyPzzuh2xKSwG6JNz6yOOtU
	 7WOr/qbYFuPcgr1pRdwZ8uO2y8q0dACa3TuvR6a8w6VyUDUFsVgK9MeZzdTx9KAtesQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdXva6TQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2288606A321;
	Thu, 26 Nov 2026 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdXva6TQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BD91F000C6;
	Thu, 26 Nov 2026 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705472;
	bh=Ut0jKHCQCsZ4uET39KiJ/+6gY3sFwadgbKxYMwzrlkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdXva6TQzH9AnRkGRY/H9RaA3FvV7ZVG4LBIVwAdwLqV3VsIR0g644NA4MF/jAMG8
	 5F318NtUls0oPe6tuLonD/TsT/4rHXnU1a6q1DXUqAPomWraqkCr3m1BNQ0Hjv70KF
	 63FCKYx4P17xZv3wR/Y2SjZQ+9sREqVv6LOZ/xZA=
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
Subject: [PATCH 5.15 209/319] cpufreq: intel_pstate: Clear last written P-state value on suspend
Date: Thu, 26 Nov 2026 15:39:37 +0100
Message-ID: <20261126144011.462144053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 02e77af824d5be3a94fdd885835a352f90d24c5c upstream.

Preserving cpu->pstate.current_pstate across system suspend-resume
cycles, when running in the passive mode with HWP disabled, is a mistake
because its value from before system suspend may become stale after the
subsequent system resume and in some cases it prevents MSR_IA32_PERF_CTL
from being updated properly after system resume [1].

Address this by clearing cpu->pstate.current_pstate after the governor
has been stopped during system suspend.

Fixes: 001c76f05b01 ("cpufreq: intel_pstate: Generic governors support")
Fixes: 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and ->online callbacks")
Link: https://lore.kernel.org/linux-pm/20261027143725.3763827-1-zakbrightonknight@gmail.com/ [1]
Reported-by: Zak Brighton Knight <zakbrightonknight@gmail.com>
Reported-by: Doug Smythies <dsmythies@telus.net>
Cc: All applicable <stable@vger.kernel.org> # 342d3a73c5db cpufreq: Force passing target frequency to driver during resume
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Zak Brighton Knight <zakbrightonknight@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Doug Smythies <dsmythies@telus.net>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/14150222.uLZWGnKmhe@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2898,10 +2898,11 @@ static int intel_cpufreq_cpu_exit(struct
 
 static int intel_cpufreq_suspend(struct cpufreq_policy *policy)
 {
+	struct cpudata *cpu = all_cpu_data[policy->cpu];
+
 	intel_pstate_suspend(policy);
 
 	if (hwp_active) {
-		struct cpudata *cpu = all_cpu_data[policy->cpu];
 		u64 value = READ_ONCE(cpu->hwp_req_cached);
 
 		/*
@@ -2912,6 +2913,17 @@ static int intel_cpufreq_suspend(struct
 		value &= ~HWP_DESIRED_PERF(~0L);
 		wrmsrl_on_cpu(cpu->cpu, MSR_HWP_REQUEST, value);
 		WRITE_ONCE(cpu->hwp_req_cached, value);
+	} else {
+		/*
+		 * Invalidate the cached P-state value that may be stale when
+		 * the governor is started again during resume and may prevent
+		 * MSR_IA32_PERF_CTL from being updated.
+		 *
+		 * This does not require synchronization because the core
+		 * prevents frequency updates for suspended policies from
+		 * occurring.
+		 */
+		cpu->pstate.current_pstate = 0;
 	}
 
 	return 0;



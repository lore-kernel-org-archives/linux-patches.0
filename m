Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619815;
	b=aoQsEoiD4kC7tPgeqltTFr52w5y5ldv8gXokO6uPFuHU2f9NTUfYM36Qv8TequDXpAdG
	 Va0Wvugs6kqeHeL9iUnNTsIteCI5FfP/1mMMK2a6X94foG6vg39v/aJiff3QWNxel9XgV
	 gXcROGsuszotZ5D9Xprl4mGLfpouSXdaJctxwy1NrwkqQOIpsRgVy7qLit7bcE3qDP0yw
	 qLSUeI9TYeNKYGzOG6o6pr+XyKl6TUuKMGKOyGZYbLixCdiy4UNwSMd/1MmdjOFNVPNxx
	 xITh9ApSO5++gjaZAN82ytosGOHDJxQH9hx4Qt0n1igvEAW+hu5kx9gbTEvaeJHetcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JS6n3qEI6CrqJFVKLDHuTcQwx6v/PRqmf+uN7HAjfHU=;
	b=1U1OFX8VRBHyxdzegMJDQAKn7sV+BNiFTlATYUBC7txSYYQv0yVjT9Z93VTGAaWqE8c1
	 lRisghHXVl/8wZYOvEkri3IF2JwFYR/x9DvfNn3xTj59sh3p7yE1kZbX+uO4c7oR1KuTd
	 vNdTkQymwMWLwnT2R3NAYgac9aLl1UJZqH72YobGZLfbQawmkVcRzVwU2QG58KGX+K6Wx
	 O7NjjCXO9aQumv+tw4/gg2h5wfNVwSmsUF5hY/edWQU+Q7KqAMnHhM2HOCKScWnfKrUx9
	 JELix39E9WbKZIHyTM3ujZOQ3egKeb7CGpnzEiKdx1o9N189lxYg2v0IFqZVNY59j/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZAHOyqx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF47606A323;
	Wed, 25 Nov 2026 15:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZAHOyqx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13A31F000C0;
	Wed, 25 Nov 2026 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619814;
	bh=JS6n3qEI6CrqJFVKLDHuTcQwx6v/PRqmf+uN7HAjfHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZAHOyqxbkW32NfxlJNk8Sh2E3kfCpjfvV/BrGLRilDjVd4DqPvnv0Q+EE8Fvfyfr
	 eUwl/Qk56U/d6sFtWZML8sX6l1K6pN6S4Oip0ENuU8AgoVJgEojT1kaRK56WZh8FN3
	 QfbFtzxZUK5pX0QkY649bB+kIDufvR1nWInIhtcI=
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
Subject: [PATCH 7.3 0716/1005] cpufreq: intel_pstate: Clear last written P-state value on suspend
Date: Wed, 25 Nov 2026 15:34:14 +0100
Message-ID: <20261125143838.529073198@linuxfoundation.org>
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
@@ -3389,10 +3389,11 @@ static void intel_cpufreq_cpu_exit(struc
 
 static int intel_cpufreq_suspend(struct cpufreq_policy *policy)
 {
+	struct cpudata *cpu = all_cpu_data[policy->cpu];
+
 	intel_pstate_suspend(policy);
 
 	if (hwp_active) {
-		struct cpudata *cpu = all_cpu_data[policy->cpu];
 		u64 value = READ_ONCE(cpu->hwp_req_cached);
 
 		/*
@@ -3403,6 +3404,17 @@ static int intel_cpufreq_suspend(struct
 		value &= ~HWP_DESIRED_PERF(~0L);
 		wrmsrq_on_cpu(cpu->cpu, MSR_HWP_REQUEST, value);
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



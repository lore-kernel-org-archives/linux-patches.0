Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625753;
	b=3wxIF6JgTE9osfwgKP2/+c5nENFl+OOEWInsfYGrSrXVDX1Nobwlah+3MsTILoQ660dx
	 A5SUZRc+CZ8Ng+W0Q3B7arx6EPgFVONwFf4Jg2T4Pe1b4a2N+WikKjkLuUmzceFmyxJDd
	 xmbJYiFg0cZV5Nm4/Ip+5FdmnxP5L4V0p4O7GTntUKQWBdSP+seIE0MuZAROaOIWff5Dq
	 0i8aXUV4dvIsbkz580UAxC1JQog+uCWeRzLXbSmnhb9/ssR8gRa6MefsWKrX4QQl2/2zK
	 BIFBquAwVzlmKaLj513sou7DlGw5JJ6M7Zy4EITF+pxsC2C5DvABVFWNlwW+MnCTpFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iAkVcmF0XdJgP7vxTdM0G3buV29zAP1y345WE7j6iUg=;
	b=v6c/uxpkLE+BgtHkQvyI+Dk6yPdqVPGkOzuktl45L42EyeiSuhRk+H9oQ+8hTD0arpMX
	 H4y5/qIuulTHqqcsLRVElSVyXJMl+FannJ/kwH27quGCDwg4na7hln5beGqy9ves0GA9v
	 pBhfN9wo7SqTjs51byt+7QVFMQXU3HqhXfpB9Mlyw70jdWGCw+Ba5K0riJwaofmlyLI5+
	 uAmVx1HGNKVOPqztJ2xgOMnv4VauS+TQPWMEP669Sopw7gKFnlCJmqjhGP8pIrfann98N
	 Df1nWnC44F6FEIAcc428kye7bjp2Qzd4I1QgVIPKil8DHvsPqOGI25HG5xixa/Jdrow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKUrxMHy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A103E606A32A;
	Wed, 25 Nov 2026 16:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VKUrxMHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534DF1F000C0;
	Wed, 25 Nov 2026 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625752;
	bh=iAkVcmF0XdJgP7vxTdM0G3buV29zAP1y345WE7j6iUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKUrxMHyYPs8qdgs7ofz4D3hFB4GPp5PlcmnZH5MBfvpr6TnJ/PoTLEpD4y0XVDAt
	 kPeWcTLIUPmhDng9JdLptleR02T4MmD7EsRI9ZMuqCRR7Hq/Y5NM0EiasCb70MhV2Q
	 nIngmxQpLCTSH0KV8Iter6dP5Aosw3d/ZiufzffY=
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
Subject: [PATCH 6.12 622/816] cpufreq: intel_pstate: Clear last written P-state value on suspend
Date: Wed, 25 Nov 2026 15:36:10 +0100
Message-ID: <20261125143903.581877365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3322,10 +3322,11 @@ static void intel_cpufreq_cpu_exit(struc
 
 static int intel_cpufreq_suspend(struct cpufreq_policy *policy)
 {
+	struct cpudata *cpu = all_cpu_data[policy->cpu];
+
 	intel_pstate_suspend(policy);
 
 	if (hwp_active) {
-		struct cpudata *cpu = all_cpu_data[policy->cpu];
 		u64 value = READ_ONCE(cpu->hwp_req_cached);
 
 		/*
@@ -3336,6 +3337,17 @@ static int intel_cpufreq_suspend(struct
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



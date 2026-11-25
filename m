Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623116;
	b=B2ds/sCgoFi5UdSXLcNmnS6JyKOeD3q33SpB0QazuvYZ6hcoFuHJj/w/sBrVl0eJc1yu
	 KzKmBobBGA16MHngMRQErdvNFUJqtkiORhoGEThn/VcVRprcDTwBkNj0LISXELACh7HpZ
	 TWnvYJQaONLN5r6BjjXzrN9nnr4ml2nr9PJXsYvZ1ZH5OHgMMpSpOvaUAoaNMpWjLmaty
	 ZCay0Fg64rSVpPmiQ3Z8+5RTtJ0DQipZR73oxbWnpFGyXsClVIfTqg8BrMkBmwzeBvle7
	 zds8me78wf+Qfb0rniY9aEBOzRPetuNfXEKNow6q/3KAc9el1gA9Y9NbYo/1BPRau+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3cVXVg0qqspO5RwVBe2jysHRkF2fYZ2UQx7y1YI5+nY=;
	b=ROryO0JaFmyt/GtxZrD5Gzv2k0mejXeV4TNM9TFTb4Gdrt9uPLywZWyID5rIMWJQdnau
	 BAyY1W9wUStxbMQZBmNf/6evRAG19XaGpZS8w6/pmz32/6jDQSNbyvsd+NS0LHKC27M67
	 6K6+hAqgVGJbhGkukh920xHXKdlGNfCbrSOXAYLezZP/ulR+qbE/xaHqc8PDZPnApce8M
	 eayOCc3etSuGRSfeUqTmSTlXzDDaIKgt2xiFHJC+xwGy6AHA9JAZvTIfJrnhpQPLlGiGn
	 weFc4d/mKxvj/3H0D+CKtSnNi61Hi0kbe+e+H4nwtUimRSRbXVodAviMcUqi7j9HfiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bY1QoZdc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79536606A31E;
	Wed, 25 Nov 2026 16:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bY1QoZdc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8B61F000C6;
	Wed, 25 Nov 2026 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623116;
	bh=3cVXVg0qqspO5RwVBe2jysHRkF2fYZ2UQx7y1YI5+nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bY1QoZdcx9Ffl7ErRKKqRZlgmb5sFMAuYwg7w/QTUpK69ztrMnX/FrIxZ4hijhJMl
	 qDxfu7uJofpTYzbYP+ezNF03SUcelfbKjSQWiLP80X9gechubSBtgU9WIEzMp5ykJH
	 9sqS2biFpxtkzUgqUMqS1jZeriNHRfeoXWC5HPAI=
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
Subject: [PATCH 6.18 756/990] cpufreq: intel_pstate: Clear last written P-state value on suspend
Date: Wed, 25 Nov 2026 15:35:23 +0100
Message-ID: <20261125143839.766414248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3412,10 +3412,11 @@ static void intel_cpufreq_cpu_exit(struc
 
 static int intel_cpufreq_suspend(struct cpufreq_policy *policy)
 {
+	struct cpudata *cpu = all_cpu_data[policy->cpu];
+
 	intel_pstate_suspend(policy);
 
 	if (hwp_active) {
-		struct cpudata *cpu = all_cpu_data[policy->cpu];
 		u64 value = READ_ONCE(cpu->hwp_req_cached);
 
 		/*
@@ -3426,6 +3427,17 @@ static int intel_cpufreq_suspend(struct
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



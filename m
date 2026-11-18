Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043476;
	b=H4/h26MzCrUeui5G4UWvgLjlaxYvZBlAx3r7gUeb27RURilUQouuIFLIaWHWF08//lfT
	 8sQ/c7EjrSJX9tuX+zOEHVUZ8yK9XnHPh37/PrIdZG6EwGCed1eQ844C8PeJRo43VdUPe
	 StRFz3lJlAhLp9iJdkTMCXiwvaA4mcA2GaZ0SPK3mWxmWFcmveYTa60bTiP/pOtg5/Shg
	 f7OeMCZ5ob6UfvyggBH76x8G6a+Q1jDBtUChZ7fRwB52pgKVUsPyjR3Y4uRB5e+Wjq+Ja
	 yMKZxOImi6+eqZvgi+WaLtKjqZ0njgTQjp2iaAFowBkwtcc2t0td6+LoaGzokcUqaJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UXg3/GO2x2b/RKEsAtseZOz5S9zGDg5htT8NY+DuApo=;
	b=VVeLMb/k2cupPiBHClDoBC3bclKYENxX+FVXvTUvacED83LS5Bl2tmSxi8bcoTha71qW
	 CNuuRInZpzN32dmTdhKU/Rr4sTqexUu4kS6jK2YB4uvHasR2c9IiBXtPYmfdv+bOTjD0C
	 M4wA6dlLofDMZhu+78j9K8yulaLUg77yiMzMjsFjwx/6nUTQSZNSPuI5AgUJyxD69pNw9
	 FqT594cFQFGiQ6z5p5dmQY0FdmZftcNgfxTERnyj71olDa7VkkG/mqGqYwU0iCa51q5XV
	 p9OszExA5d5kBcbr41LY5/Uh8EGWYlXa0tLcFi6G+Yn0VWTX2IrXDr6NWO4wsEMpBhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KCW+UjyP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9434606A31C;
	Wed, 18 Nov 2026 23:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KCW+UjyP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A861F000C4;
	Wed, 18 Nov 2026 23:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043476;
	bh=UXg3/GO2x2b/RKEsAtseZOz5S9zGDg5htT8NY+DuApo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCW+UjyP7D16GAhmLRmyc3ITu/AGUWGP6G6t2obV6gDsf8CsoXrrcynhYHqrbVQGT
	 DCF4B9brSL2n7NQgNT7zGd0iGbFspHoqdeCK9pGVzfYnEW5Ia10JRHhdLsmkgPgRhZ
	 V/8Nqx4b0xpxXFmMdO/aEHzrWhRFpGp12NhvZ03s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0223/2857] perf/x86: Unregister PMI handler on PMU init failure
Date: Wed, 18 Nov 2026 15:20:57 +0100
Message-ID: <20261118150209.490259218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 91787047b1dc52b1fee68b07f79af70aae5fce47 ]

Fix an NMI handler leak in init_hw_perf_events(). When PMU
initialization fails after register_nmi_handler(), the error path
exits without calling unregister_nmi_handler(), leaving a stale
NMI_LOCAL "PMI" handler registered. Add the missing call before
clearing x86_pmu state.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Link: https://patch.msgid.link/20260717080342.1879573-2-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index c85ffd7fd2245..45e1ca8d4645a 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2160,7 +2160,7 @@ static int __init init_hw_perf_events(void)
 	err = cpuhp_setup_state(CPUHP_PERF_X86_PREPARE, "perf/x86:prepare",
 				x86_pmu_prepare_cpu, x86_pmu_dead_cpu);
 	if (err)
-		return err;
+		goto pmi_unregister;
 
 	err = cpuhp_setup_state(CPUHP_AP_PERF_X86_STARTING,
 				"perf/x86:starting", x86_pmu_starting_cpu,
@@ -2222,6 +2222,8 @@ static int __init init_hw_perf_events(void)
 	cpuhp_remove_state(CPUHP_AP_PERF_X86_STARTING);
 out:
 	cpuhp_remove_state(CPUHP_PERF_X86_PREPARE);
+pmi_unregister:
+	unregister_nmi_handler(NMI_LOCAL, "PMI");
 out_bad_pmu:
 	memset(&x86_pmu, 0, sizeof(x86_pmu));
 	return err;
-- 
2.53.0




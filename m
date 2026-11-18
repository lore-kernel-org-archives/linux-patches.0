Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034121;
	b=ysjquljBInwdYF2lXnTHRiwNunWvwns1PxZwEj2Yq1Y/da9XoiLLM+bBfnzkX/1aqH22
	 u0TYKhccjteeKNDR2I08o61DHH+Tc2odv++GIQE8y9h42o1DniLsMSuVVbQcLWesDLd68
	 gq2Ujd0mXIB40P3ii7EpE3VgCJOVy5e070tCnpZ/71RqQjt/79CVj9PqzDUFP/3K6RSYU
	 DSFOQmCgNFTHVvSn9OjEgNdsDeaGhuW1ViYXFqyrvRzqQita8tWGThlaY582UNtwbjKnV
	 pdD/r4gn1VnUJtY6T9CoD2DeIFtZlhIfoJHeAYdirRi+oDTrLi/DLe3T9qD+bvq+AzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jp5GiDoTcrTSNEjEwD4Jvz6tc/XHQP8PmE2iRBf15XM=;
	b=uhk4pl1Sd2sApgjw1FNJB289oSNSfF1CCfezaeYuxT1IXUQc4zbhbjtbrIb33OVCczJb
	 LbvFc86AjnpzoEqG+x0PbRBbVIQXg3wv6SN8WsqnAW1clj3HKz+1AR4DqsnsCDLQ5RvBm
	 c8wvDi359YpgQokwlcmyCieeFBQAfJvdhGmnmvZZ5Ql+SwYG5ys6f8XKO9LHbQ4AJ3QSV
	 Fv5kO4ulH/Y6FRokkG/iq3dS0hcYJ/G6bvVyKTpr0xZZz+3P4muSjLpaznM3mI7QYEJLK
	 haIm/o38JAplB3btXPETTW4ZmLTi6MMXkBwz/2E90y1e7rQwKBjFoulPFy+7A8NHTCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oxyAtP/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D32D606A320;
	Wed, 18 Nov 2026 20:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oxyAtP/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A8C1F000C4;
	Wed, 18 Nov 2026 20:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034121;
	bh=Jp5GiDoTcrTSNEjEwD4Jvz6tc/XHQP8PmE2iRBf15XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxyAtP/MPZAn8vAhW6U4rRJbVwyIQxqNixO2eOlBqlOmx1p2PbaYJEOEYeVHh8Dcu
	 ib6RsVOk/aqycgNmqkWOTE+Yk1kfbgjJYXnxJ8aVsRjtEox/1l8Gd+qVe2d+cR7HDf
	 jTYAnoS/+GvRhnaBpbFQ/VVKdVPbHLu3dOpDfeb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0258/3318] perf/x86: Unregister PMI handler on PMU init failure
Date: Wed, 18 Nov 2026 15:14:40 +0100
Message-ID: <20261118150323.091407926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 497a1c20277f2..531b34b4b3633 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2142,7 +2142,7 @@ static int __init init_hw_perf_events(void)
 	err = cpuhp_setup_state(CPUHP_PERF_X86_PREPARE, "perf/x86:prepare",
 				x86_pmu_prepare_cpu, x86_pmu_dead_cpu);
 	if (err)
-		return err;
+		goto pmi_unregister;
 
 	err = cpuhp_setup_state(CPUHP_AP_PERF_X86_STARTING,
 				"perf/x86:starting", x86_pmu_starting_cpu,
@@ -2196,6 +2196,8 @@ static int __init init_hw_perf_events(void)
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




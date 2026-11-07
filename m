Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060947;
	b=whFgESA7lxbeuCu8WVK+C0Zzw3Crgh9Lp08kIDxuvf+h/M2CNjrRQji8P8i7VllLNKjW
	 rQnmtKg9TXUHWlquXU1BUaq0YV5Ny3qN93LpngRdPcdiWlIB+cYrtJi8EYT1ZzCWAhRWI
	 updoA1YHzCgd6xrDW9IZJgbCXgGx+eZvKnSso4B75vDzFe4vDddHWR4SsVgu9WHzEtZ4h
	 gbJuamMj1p560uDrVbXVH7tZ2RV/zwSbXkhRBdanFTIpFBAjdZPuK2rx73MF+nL3nnYya
	 nusOiirB8emUlVG2zDhc65zVB0ANPBHtwpuum8q9cTMtl01fwL+kuMj18EiwrP6owEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7RLPc8GWcxa/wm0KigmbcxUuzn7+BaIfiU9L3e+Aj9Q=;
	b=ySjbohuAM/m/gGVz1IDSAnbatUZKIH27zTSNxML8W7RgXpKHju5LnlZI9VCypnQ+2X37
	 /hbA7OZRazoO0oeJFyf8tlkMdlRLr7thP4QoOhU2xy34FTp6fDG4vw82dBr5SMAju0/XY
	 h56VOpjbvrxh29GyYr50VeIXSgS0SPb/E1WG8MicJqKN2xPfMAqRs9IFJoUzfD52uYlW3
	 mLNGB6U3wRt9zv1qquLhqetSBE1L3KB4Fbo/Mudtxzg4ZV7Xtpt+yFJ/Sdyosr/FxTknK
	 8Hwhfs0vOICYXPvRAyiiTEtzgHSsPEJtq8Prqw00hT4gKvrgsZcTVFbmvXFj+3c31/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVbkfOTv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E46B606EE8C;
	Sat,  7 Nov 2026 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVbkfOTv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05731F008A4;
	Sat,  7 Nov 2026 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060947;
	bh=7RLPc8GWcxa/wm0KigmbcxUuzn7+BaIfiU9L3e+Aj9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVbkfOTvqL5emVlxru1efB2VVTG/vJxVfYPOtz85+LZ+WzPBqOXAZIMhRV5Iypfzz
	 ZuzEnt1+wTu72f0neoZjxxcFxHzNVx1sKUTVblvBs8WoFotA7eYUc7pdga8XI/73r9
	 zxQR06dhwDWtcyji5SnRR+u6mIVW9/vSNs0SSVNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0308/1536] perf/x86: Free hybrid state on PMU init failure
Date: Sat,  7 Nov 2026 08:38:44 -0500
Message-ID: <20261107135006.370649963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 96746e731e1626545e343974ca4673739dceb31b ]

If PMU initialization fails, for example in check_hw_exists(), hybrid
state can be left partially initialized: x86_pmu.hybrid_pmu is not freed
and perf_is_hybrid remains set. This can leak memory and leave stale
hybrid state reachable after a failed init path.

Add x86_pmu_free_hybrid() and use it on PMU init failure paths so all
hybrid-related state is consistently reset.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Falcon <thomas.falcon@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Link: https://patch.msgid.link/20260717080342.1879573-3-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 98b4014ff94a9..32b2eefd7b10d 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2054,6 +2054,17 @@ void x86_pmu_show_pmu_cap(struct pmu *pmu)
 	pr_info("... event mask:             %016Lx\n", hybrid(pmu, intel_ctrl));
 }
 
+static void x86_pmu_free_hybrid(void)
+{
+	if (!x86_pmu.hybrid_pmu)
+		return;
+
+	static_branch_disable(&perf_is_hybrid);
+	kfree(x86_pmu.hybrid_pmu);
+	x86_pmu.hybrid_pmu = NULL;
+	x86_pmu.num_hybrid_pmus = 0;
+}
+
 static int __init init_hw_perf_events(void)
 {
 	struct x86_pmu_quirk *quirk;
@@ -2181,9 +2192,6 @@ static int __init init_hw_perf_events(void)
 			for (j = 0; j < i; j++)
 				perf_pmu_unregister(&x86_pmu.hybrid_pmu[j].pmu);
 			pr_warn("Failed to register hybrid PMUs\n");
-			kfree(x86_pmu.hybrid_pmu);
-			x86_pmu.hybrid_pmu = NULL;
-			x86_pmu.num_hybrid_pmus = 0;
 			goto out2;
 		}
 	}
@@ -2199,6 +2207,7 @@ static int __init init_hw_perf_events(void)
 pmi_unregister:
 	unregister_nmi_handler(NMI_LOCAL, "PMI");
 out_bad_pmu:
+	x86_pmu_free_hybrid();
 	memset(&x86_pmu, 0, sizeof(x86_pmu));
 	return err;
 }
-- 
2.53.0




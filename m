Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043479;
	b=rRa86XNt0TfMiKszCl0R56Lm+JA42p5HUWlyR/lS6RHOwRfPOxUb7I+2CO7q2czUstjW
	 vU5OqM39H/zJxwCZGssVu5MNawicJsBrhsrk2RhpYCdnBKQN8RAyubxZuJQt5EyJXhaAs
	 Juiu0GcsxejoPZP+oOfrNkIEogNnJ5j8FewG+2iVljvMJQMXDHXb+lvPkVXuMCoY8Ubi0
	 z3wLSGb3LAhMqWkhPphu03/JJ4DU/pLu0Q4uOm4B5YlRfSrMLoOiKkUWOuHWIOW4OnJoq
	 pjGV5sMoI77aZdCUnaCFaKtlmy0RYeIyjbcMzeD9mqSSNWvTJXubSZhgI6qOUzTsiQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=71yJBPx1Gp6y0ZEcVXC62wz/gUX+3UA8QcX9x6Y4Pj4=;
	b=pFsjR4x/pCXuw9TZWXS7324kkoxeoMo7XVKpBLBC3tXVtfSPJB4BdX9aD5grSaBjgTvv
	 0kHHwfa+imf6k/tQITRboLeAhcw4pd0XrFfos98j1p/k9EIF1t9ZIxTtqtaIjRai+F9cW
	 wpFe7Hszb7AHGrPLg+dgWUhDLbYQwQg3TiadVf8s1KJFS2/56tGoseRFubTmwhidLx9Hm
	 m93jyLlf/t/1NQbTQG3sy9CX4cr7q9GtSSVT/cjeO8STjCawlU9+EbzukD2wDeADXXVbr
	 hmZHC2Lt334anPvGbOkcNPsscalFt834N42hybw0QUQ/tojMKeGiU3jlSUwzDHKwKHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFfOfPIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59FD606A31C;
	Wed, 18 Nov 2026 23:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IFfOfPIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0423F1F000C4;
	Wed, 18 Nov 2026 23:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043479;
	bh=71yJBPx1Gp6y0ZEcVXC62wz/gUX+3UA8QcX9x6Y4Pj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFfOfPIUJL/NDFwFVf43tdO9Uad1uLa/O4yWQ1wQ+nfyNbjfIzRWAig7M6qjLK5d3
	 bZXMjky+qFwbsQUC+bNFg3+KC6mcDyltZhPswHSFjMRcE2TJkgddeMIq6EaYZLsq0B
	 FVyxPTn+cgKZWeB498tfcdkJnXQA/qBHWwz7o7sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0224/2857] perf/x86: Free hybrid state on PMU init failure
Date: Wed, 18 Nov 2026 15:20:58 +0100
Message-ID: <20261118150209.525778066@linuxfoundation.org>
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
index 45e1ca8d4645a..a4d95c0d6746d 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2072,6 +2072,17 @@ void x86_pmu_update_cpu_context(struct pmu *pmu, int cpu)
 	cpuctx->ctx.pmu = pmu;
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
@@ -2207,9 +2218,6 @@ static int __init init_hw_perf_events(void)
 			for (j = 0; j < i; j++)
 				perf_pmu_unregister(&x86_pmu.hybrid_pmu[j].pmu);
 			pr_warn("Failed to register hybrid PMUs\n");
-			kfree(x86_pmu.hybrid_pmu);
-			x86_pmu.hybrid_pmu = NULL;
-			x86_pmu.num_hybrid_pmus = 0;
 			goto out2;
 		}
 	}
@@ -2225,6 +2233,7 @@ static int __init init_hw_perf_events(void)
 pmi_unregister:
 	unregister_nmi_handler(NMI_LOCAL, "PMI");
 out_bad_pmu:
+	x86_pmu_free_hybrid();
 	memset(&x86_pmu, 0, sizeof(x86_pmu));
 	return err;
 }
-- 
2.53.0




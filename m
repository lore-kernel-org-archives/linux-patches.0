Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830875;
	b=kueZZHH6il3TupELE/FW6+e268sFjhQ2QBoV9ler4ec3T2aUiSHBnsh8uo3ksPmhsa8x
	 ArspiEEAzHqh7KWVa/xvhJ5PKkMUG8+JtrME7TLpPJYXKJOnjVSDIgaAYp4fgkt6fq3nW
	 rYj0cDD1ZEV2Ld2J21JANJg72KWMsIJ0hoToSIgyCZ86lxg2FrfDBrg0032Qc65MjVJJF
	 J5MwMJ1krhhU3uoG88A2PmqmPbZWL9BahiA/nqMjMvPqgcznf8iaZGlV5T9PA7HaqS1Kw
	 E0XONLFJyxH/6FxyJzoWSOj+9VQH6XrRsRzWI/U5ixR8THJ0n+L3iBwtUQIyb2Lqw9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=APAsKoRyO4G5q5Cdd9rZXzsBwj9TrLHg1+uSlg2hzDQ=;
	b=24ALaxwJhmF9q5BaDBRs8smkjwp/hEmoiLv26bMq56r8K+0SW9emK6oqEcH4KGH/QPNe
	 JELvf8hPYM61bCWBTmzT5vXrdIppbocmN6b6fbHWWax+QPlmDHlr/C3O85AYCxAKzO60o
	 WQWregXhE8+7UoSjsDEjYhoJJEwiYWh1OcTw0zkI716S4BOK5SdgiWGxI/rMkosZFWw/p
	 rHXDe2d8TNJ1x61qZsgMvQT/J0eKpYSyrLipNJUTCAMb4Y07xIWooRHIseMRgzDSvLH+7
	 anVqBI/xB8tYtc42kcy1T/EiCnUzUXK9LCogrREYS/o//Gpj3ZuRxQ79aVDKm/HbYgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGgaeF1r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E0606E825;
	Wed,  4 Nov 2026 22:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGgaeF1r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDC71F000C1;
	Wed,  4 Nov 2026 22:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830874;
	bh=APAsKoRyO4G5q5Cdd9rZXzsBwj9TrLHg1+uSlg2hzDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGgaeF1r/LcTXvAMMGWsZrGTHctelw7tFDzJUJszgculso+aVojgXKZEWkIwvVj9/
	 d0dy9ib4yl9IKmitJ1P35Vbn3CJHe73G0yctonIPGgP49eS9TBIw3xCkP708xYhNjd
	 QjRHvIaBFBiFz14k+iquSIDY7G80OzyCaZM2dcvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0373/1005] perf/x86: Free hybrid state on PMU init failure
Date: Wed,  4 Nov 2026 16:01:46 -0500
Message-ID: <20261104211054.535257858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 2aa9270446634..7c37c228a88a4 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2087,6 +2087,17 @@ void x86_pmu_show_pmu_cap(struct pmu *pmu)
 	pr_info("... global_ctrl mask:          %016llx\n", hybrid(pmu, intel_ctrl));
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
@@ -2214,9 +2225,6 @@ static int __init init_hw_perf_events(void)
 			for (j = 0; j < i; j++)
 				perf_pmu_unregister(&x86_pmu.hybrid_pmu[j].pmu);
 			pr_warn("Failed to register hybrid PMUs\n");
-			kfree(x86_pmu.hybrid_pmu);
-			x86_pmu.hybrid_pmu = NULL;
-			x86_pmu.num_hybrid_pmus = 0;
 			goto out2;
 		}
 	}
@@ -2232,6 +2240,7 @@ static int __init init_hw_perf_events(void)
 pmi_unregister:
 	unregister_nmi_handler(NMI_LOCAL, "PMI");
 out_bad_pmu:
+	x86_pmu_free_hybrid();
 	memset(&x86_pmu, 0, sizeof(x86_pmu));
 	return err;
 }
-- 
2.53.0




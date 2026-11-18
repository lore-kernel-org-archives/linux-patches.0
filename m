Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034124;
	b=rL7ngsTQ5MmWV4FHJAHvC8gX+voDkfx1qWr9TWHZlv6HwqgZmLKT/iKS7CkJKbvSQyFB
	 N/QvXsoccsffHPmwxltgQ9a2sKP4GG1VlGxs69y3W63LzVpVviaCn1WE7JpTxnwk4VLpN
	 LAA/GKeHZYZS25tr//ZA6AAwh1Vq3+FuwQNzeUYpSARndpFylohtzmlEwBhfVG/nRUKZD
	 waKFo/80mHD6iZHLAHqUkbXu8JOYfXuUM7kSfu6CGcre3e3LVRDlHhB2bkAD75d0B1BTE
	 jjOD9FQPcX/eEYfFopovix/94gNZiITileMnYbOXTNcW8+aENtofOAKTRyodXobdTjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LZemEKedSPc4URrC/zMXoGFSS/03Mcfka9IhWQVicks=;
	b=eF1FF9FFktBh3YHhLTs4ezD84QuMNs+v79wvVsTIUQh0r512oP4xTTJo/0yvbllAXBfB
	 lTVkpf0R2OAfMwSk8UcaCNCGWSrZ5cuKwiqZhs3EPrsRZYiTikDKtTrOkGkuTQS/wE+SO
	 YHFQiuVRdnRoVtjSyvVd4q6/2tzL0S894YDilRJh9rRQ8Rx4OsUFO1SxrMRMljL/YbjkL
	 QRZ5b67mlt1R5ux77iJCe9eFVymZ3XVXW2ksVivALbcrRoJH3TgQqkeq2AR5NNHjh1Vo4
	 Hp4ilb7rwgY7V6qRsCYyGjL1E0oqj2FsrZw3q14vMcOadT6UWl9dZ74tagfFuzap1kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUzYJRIe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A4E606A333;
	Wed, 18 Nov 2026 20:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUzYJRIe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5671F000C4;
	Wed, 18 Nov 2026 20:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034123;
	bh=LZemEKedSPc4URrC/zMXoGFSS/03Mcfka9IhWQVicks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUzYJRIefQ9BxyQU2N1F0xyxYIbP3qjDjAkE3Hu/7Lg3lBah87eEX919ljatjgN/1
	 yU3kpD0TnpzM/1lmYdUVNWExHa1U4J6RWud4uRHVvg1BEmzF8hw69/T89rXfDgGQmM
	 o1e4DhTifiQUZ5F38gnCT2VQD4LMykZfrkUURuTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0259/3318] perf/x86: Free hybrid state on PMU init failure
Date: Wed, 18 Nov 2026 15:14:41 +0100
Message-ID: <20261118150323.128491576@linuxfoundation.org>
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
index 531b34b4b3633..0630d7d2656c5 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2054,6 +2054,17 @@ void x86_pmu_show_pmu_cap(int num_counters, int num_counters_fixed,
 	pr_info("... event mask:             %016Lx\n", intel_ctrl);
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




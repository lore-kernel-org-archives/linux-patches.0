Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E9A18C332;
	Wed, 30 Sep 2026 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787446; cv=none; b=Yzv4yLLTaofvt+1/V2LXlSJpTGjEgbFhMdwjeNyuC+vJYYqASJN2ILh+SgLsWdCWhHOULMqJoY54RfY7CYArssHKBYmapnLWloH+hkuC1ERIZxr8iqgnVLUVLSoGauP/NMehtWCIv76rVO0N3IIuhbpGDiKy9f1XqMpVBU86HWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787446; c=relaxed/simple;
	bh=pyEv8LWG97ypHDNAc6iU5K4ydFieuLudYwH1fVVp6U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F100qJs6/Gb/Rg0hAA0OsnNhuCaVRONXDVGH5sSgQdGuAeMspvh4gCff/D6yjNAe3u0NZzD6lixTE80DbtAoNMTonH05KOFN/1zWl9Nq5a7vUqEDLdqzHPSYX7GozvHjhspJGqdN0DFYVWwgK29sQ3I7hE2dUu38k0MSIRxHwDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yc86QUJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yc86QUJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA501F000FF;
	Wed, 30 Sep 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787445;
	bh=9rnjc7d9rIIK8pzEOQp3sAYIfNsw9V1NeCmu+t9j1iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yc86QUJnq5rXG2Uaaq75K8Mi3XzGM/0uxSL+dfEkS/ddVpOzzB5OOPfZaZ0QagjMW
	 bU7N33Oz0vjsdIq4i1sAcxymyRntRtWidRt0iIMcbzsdP/3/njfpZCM8iSrcznR5Et
	 L3s9aiqL0sVpht+IOTsUe9qwSu/wXWdQT1dotvq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 232/457] perf/x86/intel: Delete dead NVL PEBS data-source initcall
Date: Wed, 30 Sep 2026 17:25:37 +0200
Message-ID: <20260930152351.051591761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 858b37ca19d3f695f7fa94cd14be5a856fd8e7d7 ]

Nova Lake now uses the OMR data-source table for PEBS data-source
decoding and no longer depends on the legacy static pebs_data_source[]
mapping.

Remove the dead intel_pmu_pebs_data_source_lnl() initialization call
for NVL.

Fixes: c847a208f43b ("perf/x86/intel: Add core PMU support for Novalake")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20260917015234.981153-9-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 41134233fc512..689acaeeabada 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -8785,8 +8785,6 @@ __init int intel_pmu_init(void)
 		/* Initialize Atom core specific PerfMon capabilities.*/
 		pmu = &x86_pmu.hybrid_pmu[X86_HYBRID_PMU_ATOM_IDX];
 		intel_pmu_init_arw(&pmu->pmu);
-
-		intel_pmu_pebs_data_source_lnl();
 		break;
 
 	default:
-- 
2.53.0




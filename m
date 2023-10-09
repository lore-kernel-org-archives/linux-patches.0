Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D301A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyY/A/XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975EFC433C8;
	Mon,  9 Oct 2023 13:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857808;
	bh=xHMqZYjEgKmAh0V2I0P1ycJF/pjEkwYP1GNuUcTVSfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyY/A/XIqiHCNvuSJKcMYWncNsdtwU5n8pNdfSrotQLznbqmmauDFhfx05pgxZCZ1
	 BlkWabp36SEDGeIwGqBwzshddw2Rj5JnQtdb+tX+/dO5UYCxFshKxSinwQcVH0f0YY
	 YocSwtXvZaT5D33F9n6xssdNlWrjK6skCAQy3OQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/162] intel_idle: add Emerald Rapids Xeon support
Date: Mon,  9 Oct 2023 15:01:57 +0200
Message-ID: <20231009130126.663777750@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit 74528edfbc664f9d2c927c4e5a44f1285598ed0f ]

Emerald Rapids (EMR) is the next Intel Xeon processor after Sapphire
Rapids (SPR).

EMR C-states are the same as SPR C-states, and we expect that EMR
C-state characteristics (latency and target residency) will be the
same as in SPR. Therefore, add EMR support by using SPR C-states table.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index cfeb24d40d378..bb3d10099ba44 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1430,6 +1430,7 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		&idle_cpu_adl_l),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_N,		&idle_cpu_adl_n),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	&idle_cpu_spr),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X,	&idle_cpu_spr),
 	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNL,	&idle_cpu_knl),
 	X86_MATCH_INTEL_FAM6_MODEL(XEON_PHI_KNM,	&idle_cpu_knl),
 	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT,	&idle_cpu_bxt),
@@ -1862,6 +1863,7 @@ static void __init intel_idle_init_cstates_icpu(struct cpuidle_driver *drv)
 		skx_idle_state_table_update();
 		break;
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
 		spr_idle_state_table_update();
 		break;
 	case INTEL_FAM6_ALDERLAKE:
-- 
2.40.1




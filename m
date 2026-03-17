Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504562459DC;
	Tue, 17 Mar 2026 17:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768320; cv=none; b=rTr1BEjzVJ6Uik9NR+YYqFBVRAV82/kB1ImL+w+m4UxF6dEf8S1PZ9dRvIPrHJkjganzfqg9ivyjLXBFz0wJN1P2i4v+UZLpw4z5jRCHzWqY4txIX1mwNF44TlKQKoMMjUwUZ7OQ8ir7wmTXk/gSdltEwkqhkkRI+l417c/YjtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768320; c=relaxed/simple;
	bh=e9rBBDFFCuJSQzlx0qwQSBDooxOCdEN93m5O631pE3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCUL7PrS4K7Vo7zTJs/NCACxpUzW+EWI3dJhfn04voKYPz+cuKazsOTojFNBTsiz7DAriXA7x1ehz+yo7lVU/pezuDeob58Pfzc9vmAaUthwGjicq/SgYe5ZSfwd0k5d+XfZ7/QgHHqnNQoLBy6d0NiNGxLVjpiN3vV/aBpi4/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzVsqoEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzVsqoEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB45C4CEF7;
	Tue, 17 Mar 2026 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768320;
	bh=e9rBBDFFCuJSQzlx0qwQSBDooxOCdEN93m5O631pE3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzVsqoEMtkiyKNnSzHye3+19lZX1vjmNv5lE0YWhYKNDcRcU9ZBZ1mY7LNYqLt7kJ
	 ULmPW1ciV65SxO1ZBosL++fGCZP69vmpVWCL8L81iUytpp6syLFoAJZK164wmRQ/vR
	 ggaamrTGt6IbZ6ooXDP+RdC9x6j1Ps0Yn+ju6DF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 250/333] drm/amd/pm: remove invalid gpu_metrics.energy_accumulator on smu v13.0.x
Date: Tue, 17 Mar 2026 17:34:39 +0100
Message-ID: <20260317163008.636859664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 68785c5e79e0fc1eacf63026fbba32be3867f410 upstream.

v1:
The metrics->EnergyAccumulator field has been deprecated on newer pmfw.

v2:
add smu 13.0.0/13.0.7/13.0.10 support.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8de9edb35976fa56565dc8fbb5d1310e8e10187c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    8 +++++++-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    3 ++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2109,6 +2109,7 @@ static ssize_t smu_v13_0_0_get_gpu_metri
 		(struct gpu_metrics_v1_3 *)smu_table->gpu_metrics_table;
 	SmuMetricsExternal_t metrics_ext;
 	SmuMetrics_t *metrics = &metrics_ext.SmuMetrics;
+	uint32_t mp1_ver = amdgpu_ip_version(smu->adev, MP1_HWIP, 0);
 	int ret = 0;
 
 	ret = smu_cmn_get_metrics_table(smu,
@@ -2133,7 +2134,12 @@ static ssize_t smu_v13_0_0_get_gpu_metri
 					       metrics->Vcn1ActivityPercentage);
 
 	gpu_metrics->average_socket_power = metrics->AverageSocketPower;
-	gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
+
+	if ((mp1_ver == IP_VERSION(13, 0, 0) && smu->smc_fw_version <= 0x004e1e00) ||
+	    (mp1_ver == IP_VERSION(13, 0, 10) && smu->smc_fw_version <= 0x00500800))
+		gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
+	else
+		gpu_metrics->energy_accumulator = UINT_MAX;
 
 	if (metrics->AverageGfxActivity <= SMU_13_0_0_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2119,7 +2119,8 @@ static ssize_t smu_v13_0_7_get_gpu_metri
 					       metrics->Vcn1ActivityPercentage);
 
 	gpu_metrics->average_socket_power = metrics->AverageSocketPower;
-	gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
+	gpu_metrics->energy_accumulator = smu->smc_fw_version <= 0x00521400 ?
+		metrics->EnergyAccumulator : UINT_MAX;
 
 	if (metrics->AverageGfxActivity <= SMU_13_0_7_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;



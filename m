Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81210365A0A;
	Mon, 23 Mar 2026 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275668; cv=none; b=R6AotRC0cEbPnL7cGCz2cdBGSxYXQcQ854IvbfqaV7oFp4Y9VEcFtZaP2rC1DF2P1zr446weRjPkRq/rTmvVZZHSSftFYKUg11b5J3spv9da09W5TT8TeF/YdRPG0XxEOJpVG4lEIV60j6marAobufmK8gW0qqDrIozGlvP9ORY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275668; c=relaxed/simple;
	bh=8ODFTQijnmCmpSg9AauVG89wcZHsBsxDgEdhWk9VbqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pn+baiYMQPkvtAEZD3kt0uoPWhW+Ro3GfnreKvXkpniSxRYazgY0zqIYVkzRqoQER5rEkG9OnxqWEnGq7QjqT0bmR900UDbeAtANMJwrPScMmzcZFEnISs15TREUH6izZgYy72m1bhYhECotNB6Zgidixkrl96qR0yDWtJdzGKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pj5UBeGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pj5UBeGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06555C4CEF7;
	Mon, 23 Mar 2026 14:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275668;
	bh=8ODFTQijnmCmpSg9AauVG89wcZHsBsxDgEdhWk9VbqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pj5UBeGTPdQ3q1JpkX7TrTPwDBUL/eUrlia7nQe7dWhqK6nDbZnc+yfGXOpG8c+pw
	 9uadoAZ/94VLnOGQa6cZLt3qLYiBnGdxaGdnV4SEulSgZo7IM7Zle+mudMkjydDhmo
	 X9r+daQVvLDd2NRxM85LS7GB7Cles389b46joOZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 177/460] drm/amd/pm: remove invalid gpu_metrics.energy_accumulator on smu v13.0.x
Date: Mon, 23 Mar 2026 14:42:53 +0100
Message-ID: <20260323134530.891380995@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2033,6 +2033,7 @@ static ssize_t smu_v13_0_0_get_gpu_metri
 		(struct gpu_metrics_v1_3 *)smu_table->gpu_metrics_table;
 	SmuMetricsExternal_t metrics_ext;
 	SmuMetrics_t *metrics = &metrics_ext.SmuMetrics;
+	uint32_t mp1_ver = amdgpu_ip_version(smu->adev, MP1_HWIP, 0);
 	int ret = 0;
 
 	ret = smu_cmn_get_metrics_table(smu,
@@ -2057,7 +2058,12 @@ static ssize_t smu_v13_0_0_get_gpu_metri
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
@@ -2043,7 +2043,8 @@ static ssize_t smu_v13_0_7_get_gpu_metri
 					       metrics->Vcn1ActivityPercentage);
 
 	gpu_metrics->average_socket_power = metrics->AverageSocketPower;
-	gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
+	gpu_metrics->energy_accumulator = smu->smc_fw_version <= 0x00521400 ?
+		metrics->EnergyAccumulator : UINT_MAX;
 
 	if (metrics->AverageGfxActivity <= SMU_13_0_7_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;



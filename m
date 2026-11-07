Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061397;
	b=UZtYp7q6FJQgxxDbK00aucAKffzfWwNuA50E7WZhxw1i/B+q/H9c/oKcqEvP7jUIjxiv
	 G3rKZWU2G/lxwQtqVr5Tvw+SFub6R6Gk/x+WzR1Y4b4Zrp1VDeJipN+TMgqDaqhSmkozn
	 g9rKcRs+GsefBSc+qVQ7+uciOb8rhs7NHfMehVbOzEp3WYRs6owWFHhaFHk6gfbrOqqTf
	 XzdB61ySX6C/Cbq2rHJn4vfib/Jca6/XddN9fzUfUlhaF8c+LVOHkOjFwrN+Tq0cvfDrM
	 9a+IshpxC4eJLtnx4b8Kr0+UAB7bQyoTodPllT2RG4sWIbIAt/NjydZpl9zGt0Z+NFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=v6dyew7uOT1S+y/HRFm/xHt0HMciB/eCx7yw0lBn+/4=;
	b=zI0kdP7cZoM0JanxPHxYGuP8NzVsk+4sogPFwZb5uiszmmvYm1hA1Q84k6rtMDwyQ1GX
	 mDf9xq+PczY5hJm3pTOR5nylyOaZ7Cq9eaVNItWyBAtH+AWvjReUQesNzbFzBHMfCGiCx
	 nOHCl6pHvWmrdhZ1AgH84LDuX5rje5AD/wwjz5taTlKlAOmW+zaib9lDRlgT/RBrrApTG
	 aaL8RBN9t/MeZ64ROccH83NrWJFxb9n1eRZeAspRjvK0x8Au+tvrgyanOnSdlVS3DAirQ
	 Fqrj0yj8Ub/Yg1KUFLiS3H3G1ACuJKzB/k26fkVd9/dw189AjJbJH8PD5BfKX0YYLdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEP43qiV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA9E606A33E;
	Sat,  7 Nov 2026 14:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VEP43qiV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B301F008A1;
	Sat,  7 Nov 2026 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061397;
	bh=v6dyew7uOT1S+y/HRFm/xHt0HMciB/eCx7yw0lBn+/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEP43qiVxv6ltLXY2NwCtIwoytI9Sl4kOP4SCbJpCGSsVorX1f6ekiikXz5I6deIU
	 ipwbTCROc2FEUG/pRs65NFaDehalH/+hkRPbGkA9rGhNXq6LEp4gnQLrzW01LQIS0w
	 Jt9wlggCDEP8Gj/dh3o02Xc62NVk0s+xeoEX7GmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0516/1536] drm/amd/pm: fix gpu metrics energy accumulator for smu 13.0.0/13.0.7
Date: Sat,  7 Nov 2026 08:42:12 -0500
Message-ID: <20261107135011.923796726@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Wang <kevin.wang@amd.com>

[ Upstream commit 13ddcc7acb9adbed7627e952a61d1d62cd9546fc ]

GPU metrics v1.3 defines energy_accumulator as a 64‑bit field.
The unsupported‑firmware code path assigns UINT_MAX, which is neither the
full‑width invalid value for this field nor its default value.

Fixes: 8de9edb35976 ("drm/amd/pm: remove invalid gpu_metrics.energy_accumulator on smu v13.0.x")
Signed-off-by: Kevin Wang <kevin.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c2b948c4fe16eb13d98ff5d1371956cb2f55cdc6)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 2 --
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 7ecc7537ae2f3..6d178621ade16 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2093,8 +2093,6 @@ static ssize_t smu_v13_0_0_get_gpu_metrics(struct smu_context *smu,
 	if ((mp1_ver == IP_VERSION(13, 0, 0) && smu->smc_fw_version <= 0x004e1e00) ||
 	    (mp1_ver == IP_VERSION(13, 0, 10) && smu->smc_fw_version <= 0x00500800))
 		gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
-	else
-		gpu_metrics->energy_accumulator = UINT_MAX;
 
 	if (metrics->AverageGfxActivity <= SMU_13_0_0_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 46368fc966435..7a0e82a96a1c1 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2074,8 +2074,8 @@ static ssize_t smu_v13_0_7_get_gpu_metrics(struct smu_context *smu,
 					       metrics->Vcn1ActivityPercentage);
 
 	gpu_metrics->average_socket_power = metrics->AverageSocketPower;
-	gpu_metrics->energy_accumulator = smu->smc_fw_version <= 0x00521400 ?
-		metrics->EnergyAccumulator : UINT_MAX;
+	if (smu->smc_fw_version <= 0x00521400)
+		gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
 
 	if (metrics->AverageGfxActivity <= SMU_13_0_7_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;
-- 
2.53.0




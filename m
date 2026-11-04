Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831238;
	b=SvuJwGQJvWzWYDPPmZtmIYyXL9raKKk2TVxgJywI61NyOI0hNuhovf982bPI8H0mIiaN
	 kQISqfY+3w7DtJSQGNXywnWkr2ThhJbDrku4+K3RSB6Hur+auM8YxKrbt+t2fGgG3JpTb
	 6D6SPeyphn5SMKJLlFYi42uxf3nfUoW+4wIhVIRxZ2wIYulJtoxi1Bl92tKxctUSHgJv8
	 BZthSfoZLM6FautqOd781+N4vwmt2YABUeVqJN4ya3PqL6M8T5u6QeNNimjJaE1yYSdI8
	 xX2xyWy61uHNkFOxpLexRqF++gYRpcKB9t9T2eIH77Ab6c4OWloZBGRsjmulFC/T5vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AdAnYSFm2EKESz6SPNSaGeszbZ0HkjD05ORDvF+7ztE=;
	b=1Ao2LnlnPpwiyhDfjI5SoS3ix6F8yayEvzTE3jrAcfMOfI47P7oNtxFS/YKGT+BG+k9X
	 iDReXwDSKeksP1R1km59WXsOIsIotQ1on8azGgq1B1kcRzzWzdj6Yc/J3KZa0qh1gGNC8
	 +zT/s57OdioJ9FjkAPUd0p5Y0UJ0cs5XAHbvtq2wr3+kZ0oMYiDyAkMT86SszEJ+7v9Y4
	 6kjzoGzSbedJeZACapNGKRlw1R1CfY/CvzD80B8E6ssPWtez8iZf0dja+JPLvcsNPnHWk
	 28EX6a9URtRXGSbQhdH8Mc9SVnSAXF1xR3fmk9G3318D9NLsBJaIzBIOiSCE4p6AlOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZ+5uuNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871A1606A842;
	Wed,  4 Nov 2026 22:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZ+5uuNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AB41F000C1;
	Wed,  4 Nov 2026 22:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831238;
	bh=AdAnYSFm2EKESz6SPNSaGeszbZ0HkjD05ORDvF+7ztE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZ+5uuNgjY+dCD4YGrO4w0ZxjN/j760LCdp1W9JIY5o/Hd/hvUrNO124rp0zl3/vV
	 ashtKLdTaOdsKIli5Ie/iBkxqxyJ11zkDElXIrTkLWLB4mTchSCeBVCnUdF7+f3rXQ
	 M5XBsjZ/F5AbiYm+eC9Yzhm7qF3txJ7w7ysNPghU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0582/1005] drm/amd/pm: fix gpu metrics energy accumulator for smu 13.0.0/13.0.7
Date: Wed,  4 Nov 2026 16:05:15 -0500
Message-ID: <20261104211100.152341119@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f5c20f2320621..e463a39efab22 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2169,8 +2169,6 @@ static ssize_t smu_v13_0_0_get_gpu_metrics(struct smu_context *smu,
 	if ((mp1_ver == IP_VERSION(13, 0, 0) && smu->smc_fw_version <= 0x004e1e00) ||
 	    (mp1_ver == IP_VERSION(13, 0, 10) && smu->smc_fw_version <= 0x00500800))
 		gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
-	else
-		gpu_metrics->energy_accumulator = UINT_MAX;
 
 	if (metrics->AverageGfxActivity <= SMU_13_0_0_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 427f3569f1d39..0af98b5bf0ac2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2150,8 +2150,8 @@ static ssize_t smu_v13_0_7_get_gpu_metrics(struct smu_context *smu,
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




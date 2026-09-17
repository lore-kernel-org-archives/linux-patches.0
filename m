Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167D1207E00;
	Thu, 17 Sep 2026 15:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660254; cv=none; b=cpFvPsS0nC6Qeptk1dTH59Nt6ZsiMoQVVQ5T6S4D6T3g1neiHdV7QPyhRGrSB+cyeRc/OwTC8DHKunq9c+ZCMh7U5NVSEi3EDvfvp5rhou0P3IMilnHAFxtdePywwxXPH3NGHtoCx0XSkmL8Ioc8q7LyRSdrVoSTMf+7EVU1lbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660254; c=relaxed/simple;
	bh=f2E2T3buGi/UtDYuAZ7909MV0tMZWvePtNatgG7O5t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pIl44Yn9XwOjeEc56420cn+u+/4PL4qBkasb0BL5rd5hHRFUJpwqVGj/cRj20UjwJxKnUPTmlMjjzkFGKBRHjjPbGuH8aM5mP7IB1NBPLN4koZwPI59/auFsALectMuKyo2ccq1FkyU9rdvCKl8pzHzY8DX8o5VRC491oSts5EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbYThz6U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbYThz6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2818E1F000FF;
	Thu, 17 Sep 2026 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660247;
	bh=6AnzWlsvMJPtNLKGug5bF/Pxa7K76YLbJPn/tmUsa/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbYThz6UAAFRxYPAlBosNgGuKOWNU9XW1rCqH77Avx0ABNPm4FtUvYxyzGHg3TYmr
	 IKiWdvbPycdTOMm79JREmHErepF9R5Ks0YhU19nv9Jt5+IF29+15JpqW+2RNPujgR7
	 fpavu4i4Lnwqbzy64PBUO6FD1cNze0n6LrdOiVt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Wang <kevin.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 527/733] drm/amd/pm: fix gpu metrics energy accumulator for smu 13.0.0/13.0.7
Date: Thu, 17 Sep 2026 16:13:55 +0100
Message-ID: <20260917151405.316517033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Wang <kevin.wang@amd.com>

commit 13ddcc7acb9adbed7627e952a61d1d62cd9546fc upstream.

GPU metrics v1.3 defines energy_accumulator as a 64‑bit field.
The unsupported‑firmware code path assigns UINT_MAX, which is neither the
full‑width invalid value for this field nor its default value.

Fixes: 8de9edb35976 ("drm/amd/pm: remove invalid gpu_metrics.energy_accumulator on smu v13.0.x")
Signed-off-by: Kevin Wang <kevin.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c2b948c4fe16eb13d98ff5d1371956cb2f55cdc6)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    2 --
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2094,8 +2094,6 @@ static ssize_t smu_v13_0_0_get_gpu_metri
 	if ((mp1_ver == IP_VERSION(13, 0, 0) && smu->smc_fw_version <= 0x004e1e00) ||
 	    (mp1_ver == IP_VERSION(13, 0, 10) && smu->smc_fw_version <= 0x00500800))
 		gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
-	else
-		gpu_metrics->energy_accumulator = UINT_MAX;
 
 	if (metrics->AverageGfxActivity <= SMU_13_0_0_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -2096,8 +2096,8 @@ static ssize_t smu_v13_0_7_get_gpu_metri
 					       metrics->Vcn1ActivityPercentage);
 
 	gpu_metrics->average_socket_power = metrics->AverageSocketPower;
-	gpu_metrics->energy_accumulator = smu->smc_fw_version <= 0x00521400 ?
-		metrics->EnergyAccumulator : UINT_MAX;
+	if (smu->smc_fw_version <= 0x00521400)
+		gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
 
 	if (metrics->AverageGfxActivity <= SMU_13_0_7_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;



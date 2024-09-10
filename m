Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637761917FB;
	Tue, 10 Sep 2024 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961502; cv=none; b=ZM7ThZpKkAthkjjRmcng95NRe/uaNFwSDhg8XGP+pNEjPW6nGj9Gv/VoiCpiKcDQ1Fz8N8ix61wxQi90BJk8dGJWb344w41tORdKRjsS/75InB2jzTmMJhglyWPFzTnsCud2WzjY742FSj43RAonNwAHcs1RWg5CoabDl3jERTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961502; c=relaxed/simple;
	bh=x5zLTzWcbHLspxuv6cxRdD8o3gAscpawtZruNyu/ipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAodWhUJ+n/PcQql+DiEzyObD6GVZ2KzovnjNqsS4WvgVVtJ9ppJjJc7lBjYfSvAdG8QSsKzntWwD73ePno8pmdkOIeQASXDFzDtEkCuctBEOjnghXeyK07CbfcnNcJNs9iq4EAFQ8ZakiVvs4qM77QY/CsvIzt1l831tkWG9+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrSr8PRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrSr8PRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB0DC4CEC3;
	Tue, 10 Sep 2024 09:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961502;
	bh=x5zLTzWcbHLspxuv6cxRdD8o3gAscpawtZruNyu/ipU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrSr8PRz4zR65DRNTCo4vlc8L7aTOSUt9PKlaB0M/TTkdDaahUkE6I1LbzmbktJM4
	 m7LuPXWiQRTM1sMcGJ8G3ncG+v1SmsC4+qJALR5vOC1H01A/mZdUAnqlKkLQcUvooQ
	 3oCOr2QrVSn+Ja1vX885Vt09Q4e0/fq/ig5iYwxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 074/375] Revert "drm/amdgpu: align pp_power_profile_mode with kernel docs"
Date: Tue, 10 Sep 2024 11:27:51 +0200
Message-ID: <20240910092624.704260589@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1a8d845470941f1b6de1b392227530c097dc5e0c upstream.

This reverts commit 8f614469de248a4bc55fb07e55d5f4c340c75b11.

This breaks some manual setting of the profile mode in
certain cases.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3600
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7a199557643e993d4e7357860624b8aa5d8f4340)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2257,7 +2257,8 @@ static int smu_adjust_power_state_dynami
 		smu_dpm_ctx->dpm_level = level;
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
+		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
 		index = fls(smu->workload_mask);
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
 		workload[0] = smu->workload_setting[index];
@@ -2336,7 +2337,8 @@ static int smu_switch_power_profile(void
 		workload[0] = smu->workload_setting[index];
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
+		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
 		smu_bump_power_profile_mode(smu, workload, 0);
 
 	return 0;



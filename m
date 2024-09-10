Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F50F18595E;
	Tue, 10 Sep 2024 10:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962802; cv=none; b=ZBbi1dnTF6ppFAnWcUX5OTiMm5kaMSXA79p7telbl4W1NdjULSIE7AM4VhnCBYouNJ1SlPMd9XUMh9LkclKXu3Ar5k62HhSolzDwJgFeKKOHC7+b5RR0J8xBmXGz3T+9pGbpLjWsIGBTm0cgVLZOlzdcOxew7uuTKHkyPbl+zAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962802; c=relaxed/simple;
	bh=Z5ZWS5SH9LILjsMmDesr+hwsqvPpqJEkIktdEv8213U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoY8tLm4B9+9pYMSTe+ZBmS1e1SOjmb/wdfKcNbLrKewI7IBLJEHJtcbBrWWBYtkvy5vtSERW8Sp+1ZnUfMTO1ICTz91Ims5iRURK8n2pPK2sLkQPpF4T/nYu539Dvc6NlR0rT0OG4Rs1C62VzsBTzB/7YrKad7PkCiiSA/oeMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUGmxbXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUGmxbXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BD4C4CEC3;
	Tue, 10 Sep 2024 10:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962802;
	bh=Z5ZWS5SH9LILjsMmDesr+hwsqvPpqJEkIktdEv8213U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUGmxbXEAFXxEvvzBm00vxqc48l1MnhYCd8JbQwieDI7t33M35SgXTXi7xvFJGznm
	 S2uWku0zjVgP4hhicABQbo2FHo34ykwntYTTyfqUDOnwKSyA7Pr5iU675KJIOdA/6l
	 zjFU8FfcqizwakrUch5xD13NKs3No5Aj6HH2d+MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 035/192] Revert "drm/amdgpu: align pp_power_profile_mode with kernel docs"
Date: Tue, 10 Sep 2024 11:30:59 +0200
Message-ID: <20240910092559.411416413@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
@@ -1871,7 +1871,8 @@ static int smu_adjust_power_state_dynami
 		smu_dpm_ctx->dpm_level = level;
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
+		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM) {
 		index = fls(smu->workload_mask);
 		index = index > 0 && index <= WORKLOAD_POLICY_MAX ? index - 1 : 0;
 		workload[0] = smu->workload_setting[index];
@@ -1950,7 +1951,8 @@ static int smu_switch_power_profile(void
 		workload[0] = smu->workload_setting[index];
 	}
 
-	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
+	if (smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_MANUAL &&
+		smu_dpm_ctx->dpm_level != AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM)
 		smu_bump_power_profile_mode(smu, workload, 0);
 
 	return 0;



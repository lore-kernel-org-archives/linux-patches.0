Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F93156225;
	Thu,  5 Sep 2024 09:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530065; cv=none; b=vDSC2yVwPekwl0yx8b0ryAuqfoT3bgf7uBFS6ib+Hl3lG1he/XjD1wi5USpuQ1veJ3ZiGcqjU80noPieUsof5BXtNtTlcNNGlgElTdtHxc8leZMvnXsZXl8wINV9iDmXpJQGzsWXWcw2PSC5U5ghQEn/icZ6F0x4uxageVCC0i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530065; c=relaxed/simple;
	bh=giKp1DvygEKg2H+FU87zpjCPX6jJmTuPBP76bau/2Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqrJIbmThWJBQi7LqlwlKfyqi4OtHcFzLxslgWNYE0FaaLlBtLZZlO54cW1prglIGB0AernajIvZp4IQ/iFLrXTvKaIOPkV2k5x/2C+QKlR0PK4K9YA2ZF7ryT47LH28dBq2gu+y5XrmSm55UIaf4zBT6UOU3dNEbYG4qijUulg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0L4WXca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0L4WXca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56211C4CEC3;
	Thu,  5 Sep 2024 09:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530064;
	bh=giKp1DvygEKg2H+FU87zpjCPX6jJmTuPBP76bau/2Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0L4WXcaas0kgJ+ubIBdB7HUCKH4amr9LpmzvjPsD4Pko2WH4wttkGIuY9E6m/HZ4
	 a7q/R679iNvwtn1EkNnjeSPNcURfo/KnSsb+Z3EYIrE7Az5DyidejnU05ZegiGlBeR
	 anz340s6Ynfkx4i0yG2C60seRfceqygW8NkcDvjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/132] drm/amd/pm: fix uninitialized variable warning
Date: Thu,  5 Sep 2024 11:40:31 +0200
Message-ID: <20240905093723.970862489@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 7c836905520703dbc8b938993b6d4d718bc739f3 ]

Check the return of function smum_send_msg_to_smc
as it may fail to initialize the variable.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 7bf46e4974f8..86f95a291d65 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -99,7 +99,7 @@ static void pp_swctf_delayed_work_handler(struct work_struct *work)
 	struct amdgpu_device *adev = hwmgr->adev;
 	struct amdgpu_dpm_thermal *range =
 				&adev->pm.dpm.thermal;
-	uint32_t gpu_temperature, size;
+	uint32_t gpu_temperature, size = sizeof(gpu_temperature);
 	int ret;
 
 	/*
-- 
2.43.0




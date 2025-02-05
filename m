Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A740126C18;
	Wed,  5 Feb 2025 13:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763268; cv=none; b=OoZSjIXpf1KlsHKQkpUnCnfYNFKrIqske47/M6cbUY7TGW4dvV4AheSg1QgBHgx1A1ARU2wt+3oJbrWvMtdN1uQuKPtHw3Bz/FGpXNagZ9h8X37PXaA64IPOUuwuF02KHoQkp8FfzIq8Cn6QDUdmPmlV06PYOEF/4rDKnAvcYtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763268; c=relaxed/simple;
	bh=fq6UoVuQ+1yt4uQAIdLlDCVHRwgYSF8qxCUx8ivqFBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHPcAnLBS9GMsUzSUzzQ22O0M2p09ZFQ60Tgs3MChAbYxAYvDzYIDN18ap9V+s7Koc/kvzC0gBvupT7lqY8zjqgMp3h7rHs4NF28eyTYTYtMGRPMbxCKL5e7dH9aGhUDwsdEvFylqqvnMbwOgo8Iw1kro0Tyz1lwkJsBrDxw5Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMWbWN+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMWbWN+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A2EC4CED1;
	Wed,  5 Feb 2025 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763267;
	bh=fq6UoVuQ+1yt4uQAIdLlDCVHRwgYSF8qxCUx8ivqFBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMWbWN+sNtBcTuJ1OlEuBnvfAUvmRaKHrara7yoVtXCayXl5JTS8QcznV9Dj0Sjwb
	 Ysvp1tO2Zr4hQ4dw4xkZ6FX+Y3wD+fkJ1i2oW57JEaVjqUiIViZBLgsOuTCTbURZuX
	 aTJcol2BJ3Fkh1UVazhW9M7MQQQhe07qQLNXgYLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/393] drm/amd/pm: Fix an error handling path in vega10_enable_se_edc_force_stall_config()
Date: Wed,  5 Feb 2025 14:39:04 +0100
Message-ID: <20250205134421.263972719@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a3300782d5375e280ba7040f323d01960bfe3396 ]

In case of error after a amdgpu_gfx_rlc_enter_safe_mode() call, it is not
balanced by a corresponding amdgpu_gfx_rlc_exit_safe_mode() call.

Add the missing call.

Fixes: 9b7b8154cdb8 ("drm/amd/powerplay: added didt support for vega10")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c
index 3007b054c873c..776d58ea63ae9 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c
@@ -1120,13 +1120,14 @@ static int vega10_enable_se_edc_force_stall_config(struct pp_hwmgr *hwmgr)
 	result = vega10_program_didt_config_registers(hwmgr, SEEDCForceStallPatternConfig_Vega10, VEGA10_CONFIGREG_DIDT);
 	result |= vega10_program_didt_config_registers(hwmgr, SEEDCCtrlForceStallConfig_Vega10, VEGA10_CONFIGREG_DIDT);
 	if (0 != result)
-		return result;
+		goto exit_safe_mode;
 
 	vega10_didt_set_mask(hwmgr, false);
 
+exit_safe_mode:
 	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
 
-	return 0;
+	return result;
 }
 
 static int vega10_disable_se_edc_force_stall_config(struct pp_hwmgr *hwmgr)
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A7818A6B9;
	Tue, 10 Sep 2024 10:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963303; cv=none; b=NIi/CzFYdRDdQlG2WkdIh0A5fkvlSgs9FYBNaijViH/H4+eJkLK/rt9hK0y78Hz2+b+6+a5Ncb4mHIn/xSR+Zwcx3+cDyEwNwde35ueVt5x8OlvafBQeYA+7Vh1sZ6Ejf82NgursUW0fk+QKIyuRPmAxaxTchAqG/cOfZfMnBfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963303; c=relaxed/simple;
	bh=G3fGXW6QDJJTU5Geu8Ttb0kWu/M8xVcLrIRLxIoKdmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQzpCSeAuFBJyKEtMk2JOzH9DnnZtQMFJ+nEtSpZoa9ZGo+rNFdm5Ej9iNp0zQx+Ze5gnjP8at1XCC0iUmzsG0JTsxYEIuT1J3nMozMNPHLh8whoJKIqq5PD7xMtrxenSp0UrnGTbKpFIHhN7vR5V3ZwZQm4eaij3HYCRTue8t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPALp5pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPALp5pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DA2C4CEC3;
	Tue, 10 Sep 2024 10:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963303;
	bh=G3fGXW6QDJJTU5Geu8Ttb0kWu/M8xVcLrIRLxIoKdmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPALp5plznicz1L026mgH83nU9/FVFrUgHTldJQyHBHZDrm3B/5ckwOfXixkcWzO/
	 RvAdvh2KL18XYVTf5AYqHFvo2q/Nx4yX3JU5tTwJ2LlYbt+qc+phwnzKRuAHDYTXyf
	 LnQU4Fbr/fhzUae5XIg2t+Ug20ChhRGoSfSFRELY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/214] drm/amd/pm: fix warning using uninitialized value of max_vid_step
Date: Tue, 10 Sep 2024 11:30:34 +0200
Message-ID: <20240910092559.232779593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 17e3bea65cdc453695b2fe4ff26d25d17f5339e9 ]

Check the return of pp_atomfwctrl_get_Voltage_table_v4
as it may fail to initialize max_vid_step
V2: change the check condition (Tim Huang)

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index aba8904ac75f..6a0933a78c9d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -2575,8 +2575,11 @@ static int vega10_init_smc_table(struct pp_hwmgr *hwmgr)
 		}
 	}
 
-	pp_atomfwctrl_get_voltage_table_v4(hwmgr, VOLTAGE_TYPE_VDDC,
+	result = pp_atomfwctrl_get_voltage_table_v4(hwmgr, VOLTAGE_TYPE_VDDC,
 			VOLTAGE_OBJ_SVID2,  &voltage_table);
+	PP_ASSERT_WITH_CODE(!result,
+			"Failed to get voltage table!",
+			return result);
 	pp_table->MaxVidStep = voltage_table.max_vid_step;
 
 	pp_table->GfxDpmVoltageMode =
-- 
2.43.0




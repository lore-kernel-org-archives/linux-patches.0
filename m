Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD0D18732F;
	Thu,  5 Sep 2024 09:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530074; cv=none; b=N1YYhYm/nJKYVnBVx893MqP7PnnhRuk4d4yGVzlDGxdCTq1gXgkcpSfaOFA9NRlQfE5nQa3wlybTtDCHDyKUGZV5039ZaXmFr29k/67nlM5lILhKEiQB2rdmdbxj12gPcNE1x0te10HzUkLtqhL0gBWnUY56ru1Wj8nsALUyH7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530074; c=relaxed/simple;
	bh=0o9UzkZjmGoTpVn38wlFFdHvi67lmpNjPz7yewxlsyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZK7OMLwz4XoowGkMn0034kQ/uWxdDBj73dph+nCTF0Q+LL7NPUUh94uxYQUW3ra9vGRgg4jlaw/IdKZAtDyues9RJCfaQyrjWjGjfnTmjbjcuBdd6tFX6pIWZL+CwhlgZDFcaJobbIDIugcquo50x5DlHFBn8wjsxWv5QovCyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd85KiYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd85KiYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C367C4CEC3;
	Thu,  5 Sep 2024 09:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530074;
	bh=0o9UzkZjmGoTpVn38wlFFdHvi67lmpNjPz7yewxlsyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zd85KiYQvPNZz0w/sXw8mKUfXAHOJf9wXZXJVGC3IDZXVLMVjbxt+nGFhxdmTU4Fp
	 +O1mjbDn+Qeg/1EVP8WIVIWGeoTG2blq7ygsB/+JemkzrcxtshbCXvyBs9lwVP4afq
	 NFoOb5LcvXcQsX8UAMfiyGWav3/Hcp4ijv7TAjeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/132] drm/amd/pm: fix warning using uninitialized value of max_vid_step
Date: Thu,  5 Sep 2024 11:40:33 +0200
Message-ID: <20240905093724.049032139@linuxfoundation.org>
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
index d43a530aba0e..d500da8194e2 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -2571,8 +2571,11 @@ static int vega10_init_smc_table(struct pp_hwmgr *hwmgr)
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




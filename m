Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB885346AD3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302107; cv=none; b=uL8ZuqXjvI5MP0HCVm7zVXJJDtCDBaWMH7gI3yLVaCXsGrutNO6FA45WXpmQNvpuDLSNNqi29ohaSy1qD/S8G5AWwvhRIfIyKjL3FSLVFP1dJCC85rCbRsTB8vhQwF5eVl6lODdJ89w+nJ8265BTXmbI/ri+m+FPwEbkRVE+hbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302107; c=relaxed/simple;
	bh=UfC3MoOwIBRK0abys2L8aX616dJwW/EOJXHvCPa4A04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nmyfhh5u18EVKeeawyvGCTN/GDL1O4RYucpD1gw6bNhjQNXtpqP2p8CXBZGjbdpK/dLFJpgRytappJO3n0iRY1wyV27sqdpNj98+Fc2Fc4bsDpKaXTyT/fZmuL//XlvFZqOG9nSEeo5AIW+Q13Zs8eTVWXLFbsWCcv5zuaiXOFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pu6rz+Uw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pu6rz+Uw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34811C19425;
	Sat, 28 Feb 2026 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302106;
	bh=UfC3MoOwIBRK0abys2L8aX616dJwW/EOJXHvCPa4A04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pu6rz+UwTKzWA+DuZUzgtXnyvIVKIWcK9U43NMCs2DfsAJrjcuDCj+MuWt0cIxAMo
	 IAkUahcCXiaIvEZ+UYYVlOueY+f02XfmEaUW0wfczNtfeppdqpxnf/KYoCZaVXp5eG
	 txg8e2iHbKvEW6qVfTrkv7E3rjQ3VR8nXOhUJgNYVP6uNoLXcpqBNHCjW+DH99Qhr1
	 Phm3f76wCb+e+ra2RJDn2wi0k01RIno8GYbFg2Ic6fg/JbQpsWNuFncapSeTnIvRyf
	 0mZ0xeXMnKvedxlKTclca4Pkw43CEePvsAQNKG/Z9d+kd8OiV8LaNaM/HteebhCjVT
	 JlU8OIvNDpiXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Heidelberg <david@ixit.cz>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/283] media: ccs: Accommodate C-PHY into the calculation
Date: Sat, 28 Feb 2026 13:03:56 -0500
Message-ID: <20260228180709.1583486-94-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 3085977e734dab74adebb1dda195befce25addff ]

We need to set correct mode for PLL to calculate correct frequency.
Signalling mode is known at this point, so use it for that.

Fixes: 47b6eaf36eba ("media: ccs-pll: Differentiate between CSI-2 D-PHY and C-PHY")
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: David Heidelberg <david@ixit.cz>
[Sakari Ailus: Drop extra newline.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index 4d31b2bb8f09f..5611db7e1b326 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3530,7 +3530,21 @@ static int ccs_probe(struct i2c_client *client)
 	sensor->scale_m = CCS_LIM(sensor, SCALER_N_MIN);
 
 	/* prepare PLL configuration input values */
-	sensor->pll.bus_type = CCS_PLL_BUS_TYPE_CSI2_DPHY;
+	switch (sensor->hwcfg.csi_signalling_mode) {
+	case CCS_CSI_SIGNALING_MODE_CSI_2_CPHY:
+		sensor->pll.bus_type = CCS_PLL_BUS_TYPE_CSI2_CPHY;
+		break;
+	case CCS_CSI_SIGNALING_MODE_CSI_2_DPHY:
+	case SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK:
+	case SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE:
+		sensor->pll.bus_type = CCS_PLL_BUS_TYPE_CSI2_DPHY;
+		break;
+	default:
+		dev_err(&client->dev, "unsupported signalling mode %u\n",
+			sensor->hwcfg.csi_signalling_mode);
+		rval = -EINVAL;
+		goto out_cleanup;
+	}
 	sensor->pll.csi2.lanes = sensor->hwcfg.lanes;
 	if (CCS_LIM(sensor, CLOCK_CALCULATION) &
 	    CCS_CLOCK_CALCULATION_LANE_SPEED) {
-- 
2.51.0


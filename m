Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD448346E70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302356; cv=none; b=GbPQ/7r5ACME5jscu36rKX8xL1O2Cn8lH/Eq+nqfG1+dwA2aTgpr1KQW5e+f5bdMlvgCx2mN0SvLyPb0W+FYZsosEaH1blRuaWUDivFO+vjNsmMn+opigPoiCtrPDfKm+D9lWgmT4BgNM1spyAA82PRfF9VylWKTFCf/wXugoSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302356; c=relaxed/simple;
	bh=GuPwGc8vr+GZCS1idFPN4wTzkoPIBhpX9tVdCRp9Bas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbfPCW1E9PTrU3/sN/jZ2gexOqCNod41Pvj6dHgMS13Jh8tE9mIXR+BSoC41/GS+fj7eEBHtHKjRWo53zmjeghL1nxKH1vdr3+noQN5BxUtrfvuJWV8CN3bWHT1i75wsdWS7E7agg2Azf0rlHU9LORenb+tw6XNXOYve8iLjEQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8FyEapB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8FyEapB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBFAC116D0;
	Sat, 28 Feb 2026 18:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302356;
	bh=GuPwGc8vr+GZCS1idFPN4wTzkoPIBhpX9tVdCRp9Bas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8FyEapB/fJn0Npc0+44fqQP+D9WF3tD0DHylEBo8ftqqh84GowYIfv2kMUMxhIhD
	 QslYKCVsG/2hf/NMmBS6UiqKJ3KDfi1QopLkl+BzZiacCtS8SFKWEoxITu8v3R2Nft
	 GbQV2eKnbdKh54CCv+DDbZulgYTawof7jbv3WK1uraaPreFsjzITzqGOxaaREWDJ7m
	 3QhpvgIWpigE42dkF1t0h3rDCpvSk8oTW7JRuL+Xo65kHZ/pjL14PqcWWSoQfGbxWZ
	 47XbaUY810OuLPEffgrUkFDAKQARWAmhxu9LVkxVn3OMqyq1m1j/jLA7vFv65k8fWd
	 no/B6D3pya/zA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Heidelberg <david@ixit.cz>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/232] media: ccs: Accommodate C-PHY into the calculation
Date: Sat, 28 Feb 2026 13:08:55 -0500
Message-ID: <20260228181127.1592657-82-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 0579fae3d014f..ed753e4e86bdf 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3521,7 +3521,21 @@ static int ccs_probe(struct i2c_client *client)
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


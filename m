Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D5B344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301755; cv=none; b=qAalSm9DmHqoKsGjco+D4LabetVUJ8yIkdF0sU8A9fMCFskewL+guP50Vtj1goY0cvxn9GfZSBIa9OYI25S9PO7HR5ToUvLdMqVqgxCSg/qomOBR8I4iUZrf1tkb3c3QXJEF2T7DPVEXqBWTmxeycVrdtMvc1GuVFetUsd7TkgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301755; c=relaxed/simple;
	bh=yfCdSD6PcP/MEk2jXG1pjED2+3+UaoxA+Q8ExGP+2RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRFV/svWoDtNpo+V06ytJRHtlhToD1aXQT3qUkJIj0XkyA6+Pxhs/OEeHnUa9IQxPqeWKYB9o1QK4vVmO29rbRpz5Qf8zzcfcWtWvOWPEi51lJwJ4kCPZcS/s/FGr8sIrQMGk+wjQXkD5/qpmjalICmUCcze8MGxymiq2DItUNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvMMpJ4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvMMpJ4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BFBC19424;
	Sat, 28 Feb 2026 18:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301754;
	bh=yfCdSD6PcP/MEk2jXG1pjED2+3+UaoxA+Q8ExGP+2RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvMMpJ4xz3D5iLxjao+vYRCGCDVTZlmz+P+KFIinBMOiJCReVvOtKvl4rV1jNnsA0
	 2vfK4BVzSof243QdYQ8QRYJ/P/zN6dN5/k1GBb5B3vK5banDNqKW1qSQsoDS8iC70O
	 JLdSsq2JTFuHmoMKoZHJwh74p5FTDxIoTIz5XGZ2KrzYq06yd7Tn+19PwdT4zWl5w0
	 db+iNJDZQnbooIcOtt0VwtbKWNa+IbULwkqJ0vmJVS607whmJ8QuF38hav2NOd413h
	 rgtsBh2FyD03Fke93L8a+XeewDruCBZkXKFRxUNO922ssQtqS2GwZ8EknFrAoT0csd
	 N4XRGSwVnyKhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Heidelberg <david@ixit.cz>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/385] media: ccs: Accommodate C-PHY into the calculation
Date: Sat, 28 Feb 2026 12:56:20 -0500
Message-ID: <20260228180011.1568201-158-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 4b7d8039b1c9f..4c1dbd42342ce 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3436,7 +3436,21 @@ static int ccs_probe(struct i2c_client *client)
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


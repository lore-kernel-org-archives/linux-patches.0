Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BAF375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302552; cv=none; b=m5QaR9BbY9Bn/pG9BUrQi3Y+SBMXly0kj/7EgQY3RNUpkh9Nq18iubH79QJggUZ3QOp3CQHsPkDL4SRGeVFgciJW9Tuo7GqiDqlAHmyBzUfEpEfrLVSsFkK71wzdEkWq2+p6jB3GIHMPkMZN7B3bwtBZhmCMatpT+duTJsv42OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302552; c=relaxed/simple;
	bh=fdbi5USS7aYi3363xW4pMUT4Xq/lowpLh7B9yLQi2/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6qtDSI3PpoPtYUTRQKaT36Xk3xnyM39PK9qXIxV44TqX5ddazE/j/BVNCgCqlvT1lwqrhXIegnGVf9J+8/9JgdqPHZ85kRtJQnpo6f7aCRFOH/IxorxIu0HkoXxzduISuwj313pcfYpV1fRFj5fE/yzK1+wYXFXSZjS2gq5a8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zw+N7IIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zw+N7IIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E055C19423;
	Sat, 28 Feb 2026 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302551;
	bh=fdbi5USS7aYi3363xW4pMUT4Xq/lowpLh7B9yLQi2/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zw+N7IIOGkqjthPAVQWaTk5RJfX/Yo41uS0UfJkVD1jaN0R47+OTkeTEvabSnPqDK
	 yX6VUSmw5z42YPfHrRB9hfGVXJv66eF3aqP3zIAnYW5sUKlNvH/F9dh52X4YFyLVJi
	 ZLD5q/QKr+Nuz7Gaxn4DLl5eL7M58Llp1oR9N1/7X5tMzJZu9XnSqs4hSNNhHw6aZG
	 0LvC566N1HwsA3ePObYJuU3ugMvdcpg0equpq+7QBMmKJqwQLaczxeeCjpCZQe5aX4
	 0DLyf3V/Biake2XQyGDAds4UyrPDne4dAP8hJU8BJwpJbnA2TyzFmCnATYdMdk1XmF
	 UvohBNY55IzzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: David Heidelberg <david@ixit.cz>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/164] media: ccs: Accommodate C-PHY into the calculation
Date: Sat, 28 Feb 2026 13:13:14 -0500
Message-ID: <20260228181505.1600663-55-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 789f288bd1ed8..97123d8b326a5 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3524,7 +3524,21 @@ static int ccs_probe(struct i2c_client *client)
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


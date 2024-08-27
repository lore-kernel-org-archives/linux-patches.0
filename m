Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB81CC14E;
	Tue, 27 Aug 2024 14:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770699; cv=none; b=HRkXR2FLI3LrmyWZoBKe/OOQl/DmfXpncgOZVolsQY50UWHM8+OvK1znCMGO5F4PoclOss0Y/JE1HVPxteelZp71xnJHz2HhEmuMd7YahKGEBdkpV9c5c5snKzpC6Yv9t/JE+AgDgoQPJs5/h6PwIreC8zh+PDOtZgI2U5R+7II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770699; c=relaxed/simple;
	bh=OmLTncWUGFyDMBo5l3DbyuuDX7EXqGZ5nvMAeMel7ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSXtWFCmIWrotwHBkm6MokX4kHJjbI1RX7sRrLGz+DPaCGzq4QQcARw2RzGdBw1Xu6DTvYS085MKkH/9BthqQvTTCWBDCIWx6H791+LU3BXEm2nDxkFnbtCrt7vwYy9SU4Joe8S/HH7huTBKDI0LOMxWTe8/Dhg2JKWwSnSY6QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzuQPP4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzuQPP4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1410C61058;
	Tue, 27 Aug 2024 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770699;
	bh=OmLTncWUGFyDMBo5l3DbyuuDX7EXqGZ5nvMAeMel7ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzuQPP4HO4y1crlZKPJfOop5b/qWMX4CJGEw1oRqj68eAdJopkolp71k3+pisUrof
	 DuEEIHW6KyGX2fah/2BZGbFF+JYwCglmERrb92i87OSa0Rv0NX1WmENHhOdpYP8kXf
	 xy/UUDef4wYmVQt83ejBUGj9+iHVKbXjKHOPekCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 307/341] pmdomain: imx: scu-pd: Remove duplicated clocks
Date: Tue, 27 Aug 2024 16:38:58 +0200
Message-ID: <20240827143855.071308712@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit 50359c9c3cb3e55e840e3485f5ee37da5b2b16b6 upstream.

These clocks are already added to the list. Remove the duplicates ones.

Fixes: a67d780720ff ("genpd: imx: scu-pd: add more PDs")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240717080334.2210988-1-alexander.stein@ew.tq-group.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/scu-pd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pmdomain/imx/scu-pd.c b/drivers/pmdomain/imx/scu-pd.c
index 05841b0bf7f3..01d465d88f60 100644
--- a/drivers/pmdomain/imx/scu-pd.c
+++ b/drivers/pmdomain/imx/scu-pd.c
@@ -223,11 +223,6 @@ static const struct imx_sc_pd_range imx8qxp_scu_pd_ranges[] = {
 	{ "lvds1-pwm", IMX_SC_R_LVDS_1_PWM_0, 1, false, 0 },
 	{ "lvds1-lpi2c", IMX_SC_R_LVDS_1_I2C_0, 2, true, 0 },
 
-	{ "mipi1", IMX_SC_R_MIPI_1, 1, 0 },
-	{ "mipi1-pwm0", IMX_SC_R_MIPI_1_PWM_0, 1, 0 },
-	{ "mipi1-i2c", IMX_SC_R_MIPI_1_I2C_0, 2, 1 },
-	{ "lvds1", IMX_SC_R_LVDS_1, 1, 0 },
-
 	/* DC SS */
 	{ "dc0", IMX_SC_R_DC_0, 1, false, 0 },
 	{ "dc0-pll", IMX_SC_R_DC_0_PLL_0, 2, true, 0 },
-- 
2.46.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055551;
	b=J7fj6dCxg+0JV+55hOVU7LiIwGsbOEj5ZwVE0j4JcIp9gKX3l7UH8FCS7kmPXEi0mBP1
	 e6XYvgEtsYD8HaNJh9gz+chmlm4YGYoWBEMLztG6lgg/QQuaz3vqjODG3u9wpUtukDFzy
	 wYpast0deAdn3YrfnzpaFg6ts7QHW7cWkFANxhYrCCkK2O7QAqZDsPs+530Wew/Z3arqw
	 1SgIB7d9HbCKF/pO+Q0m4+9tP/sFlwhvIFkOfVKhRnRDfK79U92ooSmB0AzeU6TS7EYw/
	 AxRraQLiZN3zq+KPI9z8orab2zxpC/frLX0wSXCAO/+THHmiioUkO7ksSQC0M4zNM0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOG4IPfdO9s3s0B8yYqCVtD+7Vm66bFKAEH1Gn2d1GA=;
	b=vR3sTIJQoceH8Hd1v3b6Ft3y1geyn4ohooLVhgSH4WRloK4GBaeLiu9+/rSC6c9ynIft
	 5QTBniVohjBdIBij0vaLpGDCOKp2Us20M94nrQhnx/iOWtq8anPfoeZjuidEKYnkZb6nf
	 FFpjCVESW7Jp4h4AlRTOLZ61/c723PAHW4YvU73C24j4zFu469O2PpTAb7J2CAXxr4I9/
	 uMEnc7+cLg5i2TaMw+HPx4ZE9SndZYWpsjDSK6fQeAoNvo0jeaXdw/PeQdY6/fbmgphTV
	 ms0nhosaIxpuLVlJRzV3OqLG1T9XglhwK7r+rsip51kRbkx8JJMOyXPI+jMuhQOiQkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hb4o/e/t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EEE606A325;
	Thu, 19 Nov 2026 02:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hb4o/e/t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BC11F000C4;
	Thu, 19 Nov 2026 02:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055551;
	bh=WOG4IPfdO9s3s0B8yYqCVtD+7Vm66bFKAEH1Gn2d1GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hb4o/e/tdwRAFkUvpZv6WLTTZEiVYjy1LgbOVY2DxUJO8jGlOD3oGw2VLdnVA1Rmz
	 08QKGwLL/atGGKlTDRHOoc5ZNj2q9ZAO1dIbWBFbWbOz1Cjl53mLZmJBR+jnLCUbNH
	 IcoH5VZZmC1nw0IzVwCXe7jKILem0NmOi3GxbM+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Pengpeng Hou <hppiscas@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1671/2214] clk: si5351: fail prepare when PLL reset times out
Date: Wed, 18 Nov 2026 15:55:47 +0100
Message-ID: <20261118150118.685796867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit b6685c30d15cd7f28c40b2daaeacc00f21b2f12a ]

The clock prepare path requests a PLL reset when the platform data
requires a deterministic output phase. The reset helper logs polling
errors but returns no status, so prepare still enables the output and
reports success when the reset did not complete.

Return the poll result to prepare, restore the output power-down bit on
failure, and leave the output disabled. XTAL and CLKIN inputs continue
to bypass PLL reset successfully.

The issue was found by our static-analysis tool.

Fixes: 5142cbcea324 ("clk: si5351: Wait for bit clear after PLL reset")
Reviewed-by: Brian Masney <bmasney@redhat.com>
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si5351.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 57e4597cdf4c2..360bcf86fd51d 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -899,7 +899,7 @@ static int _si5351_clkout_set_disable_state(
 	return 0;
 }
 
-static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num)
+static int _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num)
 {
 	u8 val = si5351_reg_read(drvdata, SI5351_CLK0_CTRL + num);
 	u8 mask = val & SI5351_CLK_PLL_SELECT ? SI5351_PLL_RESET_B :
@@ -910,7 +910,7 @@ static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num
 	switch (val & SI5351_CLK_INPUT_MASK) {
 	case SI5351_CLK_INPUT_XTAL:
 	case SI5351_CLK_INPUT_CLKIN:
-		return;  /* pll not used, no need to reset */
+		return 0;  /* pll not used, no need to reset */
 	}
 
 	si5351_reg_write(drvdata, SI5351_PLL_RESET, mask);
@@ -923,6 +923,8 @@ static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num
 	dev_dbg(&drvdata->client->dev, "%s - %s: pll = %d\n",
 		__func__, clk_hw_get_name(&drvdata->clkout[num].hw),
 		(val & SI5351_CLK_PLL_SELECT) ? 1 : 0);
+
+	return err;
 }
 
 static int si5351_clkout_prepare(struct clk_hw *hw)
@@ -939,8 +941,18 @@ static int si5351_clkout_prepare(struct clk_hw *hw)
 	 * Do a pll soft reset on the parent pll -- needed to get a
 	 * deterministic phase relationship between the output clocks.
 	 */
-	if (pdata->clkout[hwdata->num].pll_reset)
-		_si5351_clkout_reset_pll(hwdata->drvdata, hwdata->num);
+	if (pdata->clkout[hwdata->num].pll_reset) {
+		int ret;
+
+		ret = _si5351_clkout_reset_pll(hwdata->drvdata, hwdata->num);
+		if (ret) {
+			si5351_set_bits(hwdata->drvdata,
+					SI5351_CLK0_CTRL + hwdata->num,
+					SI5351_CLK_POWERDOWN,
+					SI5351_CLK_POWERDOWN);
+			return ret;
+		}
+	}
 
 	si5351_set_bits(hwdata->drvdata, SI5351_OUTPUT_ENABLE_CTRL,
 			(1 << hwdata->num), 0);
-- 
2.53.0




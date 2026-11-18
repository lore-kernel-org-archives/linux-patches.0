Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030479;
	b=EbN3woNXHzkaz5cdtOi1u0dNSYwC/C87f4/+42Gw/Iuh4JhVQVmzVD3ANWw/mU1Pd+sc
	 o82/AZwsLjSDRP6FjNtOGZ9ycl8aRFQrHrifSnNy+qavLG1++xkqAm5DYx0kchPUvXqT5
	 0y9wvDXMflfuPTwgTD5pB2+aAjc4YlA3T/IXTw/pSKho74RYo1PAdPhxxD81J0cPb5aJx
	 JaoEBs5qCqtfHgruwMfb+Ik9TN6Kn5uwyJKh+3Gp5jMbfL4neVNndvgYYhQbdMOvegEzM
	 WUgZZUSVAo0aP1rS423y3eQ3ml1NA3EoCENSbIPuJN15lKS3Lumwk9F03ARDkE015cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S4mvK94t7m+UXyFDXnQrOP+xCduGbJv4mcCM72PZOug=;
	b=Zq9261MkqoDD3dpGFfU77/EBD3xs20e4761IOxhLWcEMAoyzbxWTTZ9n3TnzEZ9leoen
	 o85fdMjs/9iLRqfTRXSfvpYFQ+DBMUjwIe4WLynCOVOOLlvNG5+OBZu+BYkVx25/UCwXA
	 b53804T6LvjTahsDq4ULX4P7fPB4SHRMp5LM2eiHRmCsVO1ts33oJhfHgiYSsLR4vFR7H
	 QHD2IlQGZZqGQJS6sAer/uM10LYPVpGwvab39/W2iiv5bNl8nWfpvPVjJzHMRYgvdtdAg
	 dfRzLJk5VK86qQm+z3UDTaWRekEWW69DCzR7DwZQx+X2yMY44mmXl0cQGUmTye1JNSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNlFFyYX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20881606BB4A;
	Wed, 18 Nov 2026 19:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNlFFyYX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8871F000C7;
	Wed, 18 Nov 2026 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030478;
	bh=S4mvK94t7m+UXyFDXnQrOP+xCduGbJv4mcCM72PZOug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNlFFyYXLfiqVtuhIOp6njKtJ8G2jqGvXagRV7JrGNi3mnEfb5wWOeM55kLMW7668
	 5qjf8Sz41NnUkgniHhCyUtkmW6R0d1P3EYnvcBsv2ooAvNwvy4htYSR8LMRNYwXFqD
	 WJTRd3Tc4jo/lWPei4g1igC+XZvK/UQwH6mPBmp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Pengpeng Hou <hppiscas@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0692/1756] clk: si5351: fail prepare when PLL reset times out
Date: Wed, 18 Nov 2026 15:46:59 +0100
Message-ID: <20261118150036.758424316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a4c92c5ef3ff7..e4d165e2b5c2f 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -907,7 +907,7 @@ static int _si5351_clkout_set_disable_state(
 	return 0;
 }
 
-static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num)
+static int _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num)
 {
 	u8 val = si5351_reg_read(drvdata, SI5351_CLK0_CTRL + num);
 	u8 mask = val & SI5351_CLK_PLL_SELECT ? SI5351_PLL_RESET_B :
@@ -918,7 +918,7 @@ static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num
 	switch (val & SI5351_CLK_INPUT_MASK) {
 	case SI5351_CLK_INPUT_XTAL:
 	case SI5351_CLK_INPUT_CLKIN:
-		return;  /* pll not used, no need to reset */
+		return 0;  /* pll not used, no need to reset */
 	}
 
 	si5351_reg_write(drvdata, SI5351_PLL_RESET, mask);
@@ -931,6 +931,8 @@ static void _si5351_clkout_reset_pll(struct si5351_driver_data *drvdata, int num
 	dev_dbg(&drvdata->client->dev, "%s - %s: pll = %d\n",
 		__func__, clk_hw_get_name(&drvdata->clkout[num].hw),
 		(val & SI5351_CLK_PLL_SELECT) ? 1 : 0);
+
+	return err;
 }
 
 static int si5351_clkout_prepare(struct clk_hw *hw)
@@ -947,8 +949,18 @@ static int si5351_clkout_prepare(struct clk_hw *hw)
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




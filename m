Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024974;
	b=NvGT5x/vYu1nfqwTMLiX5Z2Ylc7P+Ff33fElOEeEqOwtHPBrU/Nm1YTppgUymXShKBkV
	 VlT5SNlhVBQPQCCdAHNwlDgZERYDnBelcz3PbwO9hL3xaAG+vhH60wcp1yPF8xNQSU33C
	 NHSv9kBm6T7nGyvDBy58B4zeprZmtyXr0ttc+g5Ks8HBzEYJrpEb3qJsuTLTfGc2ry5c/
	 zYWu/v1xKTaIft1ae8jimjk1c65Xcs5Oy9Ixz7spxk3ES49Ly6ZDmXWyMR7CrqjhrTOMh
	 COW5s3dVPubVTX7CPMzJSpFsoW+lEMAVFz2W1p3NsBNsZpWlWFd54BdOPkX6PXxV9zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eE74+xD2s1fbryu9MFnKKEBY6033rR2FEwRffYxcjJ4=;
	b=A9YYHxtv0Xs0bDzXuYX7KY6z9Z6tQuBM7CqmyMeeW7g5k6h4xn6tcAFSklZdcNNkoQxy
	 C6PQCiqdMqAGqoItZP6FE3xsiOx60hCHswyua6GV3AnCcDEsTKbwIdxNnYG1W6wQ5BmCp
	 Iq3qt/eU4pWQefxvMQcfVpHW8eCLZEEngn1r1WPLYIdV7f0Nr9xNwUdf9Mu+OeSyblcwd
	 ALQyVYquoU8WCNYQuIdIr0CgGnLfgH7x4cnQNvpGQGkx/b4irFfHnw57Mx9THmUAAPjI9
	 mUMBsddda0yCDI0AZZd5mBHuBYeHxf4tbrPAeGymAQ8g14vG78tx30usbTPtD8SSILQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lLP1Vz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC91606A320;
	Wed, 18 Nov 2026 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lLP1Vz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125651F000C4;
	Wed, 18 Nov 2026 18:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024974;
	bh=eE74+xD2s1fbryu9MFnKKEBY6033rR2FEwRffYxcjJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lLP1Vz30yTExJjkdUjr9YGLwGsIcUWy4Z2ABnFJOveKXw3S3FKKKh5zvi58Ofpzu
	 NiXAoSPL8GbYpIEmEkWg1D5Uzsvb5owsH2Xt8R7UK//8KnEQxAYbtF1whPavtUsxmT
	 DHu1UsP+9NeRMjo6SZWJngnlFdJ7BwcMXOextrS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Pengpeng Hou <hppiscas@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0874/2151] clk: si5351: fail prepare when PLL reset times out
Date: Wed, 18 Nov 2026 15:43:29 +0100
Message-ID: <20261118150154.031889839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e755db545e2ee..6cffdd009612f 100644
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




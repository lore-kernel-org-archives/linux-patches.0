Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774837;
	b=OFucWG+A/RlUMuMoIBS06/seKUr3Dy5lcs8JK+OvZx0B2xDk5WQ7B68Zg+U5m6d88dGT
	 3ju1sh2+yagYvdCb9WGrbcCg8Z1WflcUUNoJsl/M5O9AZCP1yEdYoaRG8TBaExA2gqvtU
	 tcsXGTOM7E82gs8mrf/3/qwTAO7pCOSnBuQm+agxEscMY51EvzPKtsO3knj/YPaBNYd47
	 uGqOdcpuXOf6oXjMWIeaxYrxk/cdcyBCKt0UNErYA/BvfYhqzXMYgLnfVu72cTyfZCw4a
	 oybpqrTOkbJ0qldrrGrh02ib9mng6eHyimTj82kjjIwKR3hYuVE2p8TqpUz/QU4Yh5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EPJNBZuJv7VTTm2LjStZnmBSBelUsBVu/BbhG1Ax3PI=;
	b=bLmx5tI2BEoJsQUOPf07YNElV+/6zOn80frc5BueZnTnOWDSb2hrGIau0D2kzQhMC8v5
	 8f836e/dQdO45qJr61LNO4lYXdw79JHYKk6OiJY6eFbKYJisB2K0UUJfnk9Ze6qrG9ymS
	 8RLX+MuyyM07irN2mHrEH4eYZWJZ53AnW8C9BrdCbXp/j8DEMyns5ul/elBWCnA9Zmrnp
	 OLk362u9LZmOxZHV8VY7tiI6skmO4kysSdwFJ8KcfY+fnVSHZ3xD3OKzesvfOZVDs1J9L
	 sMEtfbQxD/koDAvxTSRzLZk1ebUu3i2+TwzsNsexPkAfcdcdQ3WEtsJ/Wiq4ca1bjKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZQxzNcNq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FE7606A31B;
	Fri, 23 Oct 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZQxzNcNq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6CE1F01825;
	Fri, 23 Oct 2026 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774837;
	bh=EPJNBZuJv7VTTm2LjStZnmBSBelUsBVu/BbhG1Ax3PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQxzNcNqr0oYGhev497Q7NDavLfT3/pF48wNOOyYcuZWtWeBJmf2uJjXlT1OIamiu
	 z3xRjaoLim3J5E163Bdopf/Uug2TkJxdTJ2kWmM+rM03Evq4W1hpJ1dTks5WXZCkee
	 dX6wZ9Txzar8kVw2uvkUmP5JRnlwn4f4kqF+32D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Fran=C3=A7ois=20Roux?= <franzelfranzel@gmail.com>,
	Dale Whinham <daleyo@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 127/242] power: sequencing: qcom-wcn: power off WLAN at probe
Date: Fri, 23 Oct 2026 18:39:29 +0200
Message-ID: <20261023163716.786484967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: François Roux <franzelfranzel@gmail.com>

commit dbd674ccf30f66f5eccf637964a93910df8dbf84 upstream.

The WLAN enable GPIO is requested with GPIOD_ASIS and then kept at its
current level, so that a WLAN module left powered on by the firmware is
not switched off. The FIXME explains why: toggling it would take the
PCIe link down, and the controller driver could not recover from that.

That reasoning held while the PCIe link was trained before the
sequencer probed. Since commit b921aa3f8dec ("PCI/pwrctrl: Switch to
pwrctrl create, power on/off, destroy APIs"), qcom_pcie_host_init()
powers the endpoint through pwrctrl before it starts link training, and
defers until the pwrctrl driver is bound. That driver cannot bind
before this sequencer has probed. Power-on therefore always comes
before link training, and keeping the firmware state is now harmful.

On the Microsoft Surface Pro 11 (X1E80100), the WCN7850 sits on a
PCIe port without a PERST# GPIO. While pci-pwrctrl-pwrseq is not yet
bound, the host init is deferred about ten times, and each attempt
powers the PHY and controller back down. The later power-on only sets
a GPIO that is already high, so the chip is never reset and the link
never comes up:

  qcom-pcie 1c08000.pcie: Device found, but not active

The endpoint is not enumerated and ath12k never probes. Bluetooth on
the same chip fails too ("QCA Failed to send TLV segment (-110)").

Request the GPIO as GPIOD_OUT_LOW. The chip is then off when the
sequencer probes, and pwrctrl powers it up cleanly right before link
training. Drop the FIXME and the code that preserved the firmware
state.

Tested on a Surface Pro 11:
 - b921aa3f8dec plus a one-line version of this change: endpoint
   enumerated at 2.4 s, ath12k and Bluetooth working.
 - next-20260929 plus this patch: "PCIe Gen.3 x2 link up" at 3.4 s,
   ath12k and Bluetooth working, Wi-Fi connected.
Without the change, neither kernel enumerates the endpoint.

The culprit was found by bisecting v6.17..v7.1, with the DTB and
.config held constant.

Fixes: b921aa3f8dec ("PCI/pwrctrl: Switch to pwrctrl create, power on/off, destroy APIs")
Closes: https://lore.kernel.org/all/CAPjyS8dY0Q_o3XmFjuKZZsjhzhoSNL+ZGJtw5cQt8HiV3sUtxA@mail.gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: François Roux <franzelfranzel@gmail.com>
Tested-by: Dale Whinham <daleyo@gmail.com>
Link: https://patch.msgid.link/20261004165124.4277-1-franzelfranzel@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/pwrseq-qcom-wcn.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/power/sequencing/pwrseq-qcom-wcn.c b/drivers/power/sequencing/pwrseq-qcom-wcn.c
index d41793e1fcd9..34146d6372f3 100644
--- a/drivers/power/sequencing/pwrseq-qcom-wcn.c
+++ b/drivers/power/sequencing/pwrseq-qcom-wcn.c
@@ -496,15 +496,8 @@ static int pwrseq_qcom_wcn_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(ctx->bt_gpio),
 				     "Failed to get the Bluetooth enable GPIO\n");
 
-	/*
-	 * FIXME: This should actually be GPIOD_OUT_LOW, but doing so would
-	 * cause the WLAN power to be toggled, resulting in PCIe link down.
-	 * Since the PCIe controller driver is not handling link down currently,
-	 * the device becomes unusable. So we need to keep this workaround until
-	 * the link down handling is implemented in the controller driver.
-	 */
 	ctx->wlan_gpio = devm_gpiod_get_optional(dev, "wlan-enable",
-						 GPIOD_ASIS);
+						 GPIOD_OUT_LOW);
 	if (IS_ERR(ctx->wlan_gpio))
 		return dev_err_probe(dev, PTR_ERR(ctx->wlan_gpio),
 				     "Failed to get the WLAN enable GPIO\n");
@@ -515,13 +508,6 @@ static int pwrseq_qcom_wcn_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(ctx->xo_clk_gpio),
 				     "Failed to get the XO_CLK GPIO\n");
 
-	/*
-	 * Set direction to output but keep the current value in order to not
-	 * disable the WLAN module accidentally if it's already powered on.
-	 */
-	gpiod_direction_output(ctx->wlan_gpio,
-			       gpiod_get_value_cansleep(ctx->wlan_gpio));
-
 	ctx->clk = devm_clk_get_optional(dev, NULL);
 	if (IS_ERR(ctx->clk))
 		return dev_err_probe(dev, PTR_ERR(ctx->clk),
-- 
2.56.0




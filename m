Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216811;
	b=QXqWhVgDoCw6RDORJx8MxxOhPTG/CQ5pnMXwey6N0EuuqCbm131hpZM4gzg8z3Jhwdfo
	 uQpbWuHvn8HD8ipSObKUfrA9xGtRk6IQY5AL7x8KWFWOGPUtGhirxWKTBPIy64JtdiBjV
	 dOzT4aurvPyYrpoWojgjgapLVnWOnIOmZyoov+8MhTDZDRHFF1Z4PsfgpVfZzgRBFoS64
	 VXhRC4s5VIfXRgNVyJU1PF7iuhM+ylqkjG0G2icdYtvWUmhpvzJ1u8Ttdi1TM5Zw7/zuB
	 h241v4yAtmHE5UZicoNFyKy0Zb0ntsTdxLKJa7muw9UZMWvQOKvib8z1WjksGK5lfIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PH088OB9ENNO7et+0ZDdF819bp1tXyoU8V5K4DKyzuI=;
	b=iI4ptXMNZ+gnA3E6l9bOQvI1lSGP6XIxmjvy0/nS2JMAPTljztzgez0r74b8sR8sfvk7
	 7QviFcwo4Eb9EiYLwa62sXT8umiXCdxSSNmA8ybI7u/TFuuf7BlPueE4BT8iBGKIp/Ept
	 9sWzKy5ymEkF0PTRmb1Qmg4rX7TDC4LjRGurjwdZHETQV3fmZSL0Q0b4gaFT52JVV7OQ+
	 TGKhipPN8Uj9M4ltz1HlK+QJgro/ya0YgyLmjNGSXkDpIbMrJZ+ERXilcz8BHB8SENbZb
	 bHHn10nHfPD1a20zODN5AocRYP0zcJn6AzX8RNasksAuTz9R8WHzFReiffR6U52J94A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s/f/i9hZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CCD606A31A;
	Wed, 28 Oct 2026 19:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s/f/i9hZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985EE1F01825;
	Wed, 28 Oct 2026 19:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216811;
	bh=PH088OB9ENNO7et+0ZDdF819bp1tXyoU8V5K4DKyzuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/f/i9hZxoHrmzkSC4rvlxmytRXXkWxfjTSPu1+Tcq7tBCZJwmhsgf9cwP68qR9cZ
	 TSfXrAFrS76hwJVI+EzkAv6YGeehuBGvqVyfC9JU5UaawkQJPaOQPu0Fy1Vd9eHJBC
	 r15pMfTMvB8Dqu6Vl3YCcyJrk5ulEskInXNuYtzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1685/1887] spi: spi-qcom-qspi: Fix incomplete error handling in runtime PM
Date: Wed, 28 Oct 2026 18:03:01 +0100
Message-ID: <20261028170537.801503677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit d283d5d4d9f6d081ddb65e371be26fffeb611c42 ]

The runtime PM functions had incomplete error handling that could leave the
system in an inconsistent state. If any operation failed midway through
suspend or resume, some resources would be left in the wrong state while
others were already changed, leading to potential clock/power imbalances.

Reorder the suspend/resume sequences to avoid brownout risk by ensuring the
performance state is set appropriately before clocks are enabled and clocks
are disabled before dropping the performance state.

Fix by adding proper error checking for all operations and using goto-based
cleanup to ensure all successfully acquired resources are properly released
on any error.

Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260429-spi-nor-v5-2-993016c9711e@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qcom-qspi.c | 44 ++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-qcom-qspi.c b/drivers/spi/spi-qcom-qspi.c
index 3fb9cc85d554f..4db034da54b73 100644
--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -571,20 +571,34 @@ static int __maybe_unused qcom_qspi_runtime_suspend(struct device *dev)
 	struct qcom_qspi *ctrl = spi_master_get_devdata(master);
 	int ret;
 
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(dev, 0);
 	clk_bulk_disable_unprepare(QSPI_NUM_CLKS, ctrl->clks);
 
 	ret = icc_disable(ctrl->icc_path_cpu_to_qspi);
 	if (ret) {
 		dev_err_ratelimited(ctrl->dev, "%s: ICC disable failed for cpu: %d\n",
 			__func__, ret);
-		return ret;
+		goto err_enable_clk;
 	}
 
-	pinctrl_pm_select_sleep_state(dev);
+	ret = pinctrl_pm_select_sleep_state(dev);
+	if (ret)
+		goto err_enable_icc;
+
+	/* Drop the performance state vote */
+	ret = dev_pm_opp_set_rate(dev, 0);
+	if (ret)
+		goto err_select_default_state;
 
 	return 0;
+
+err_select_default_state:
+	pinctrl_pm_select_default_state(dev);
+err_enable_icc:
+	icc_enable(ctrl->icc_path_cpu_to_qspi);
+err_enable_clk:
+	if (clk_bulk_prepare_enable(QSPI_NUM_CLKS, ctrl->clks))
+		dev_err_ratelimited(ctrl->dev, "Failed to re-enable clocks\n");
+	return ret;
 }
 
 static int __maybe_unused qcom_qspi_runtime_resume(struct device *dev)
@@ -593,20 +607,34 @@ static int __maybe_unused qcom_qspi_runtime_resume(struct device *dev)
 	struct qcom_qspi *ctrl = spi_master_get_devdata(master);
 	int ret;
 
-	pinctrl_pm_select_default_state(dev);
+	ret = dev_pm_opp_set_rate(dev, ctrl->last_speed * 4);
+	if (ret)
+		return ret;
+
+	ret = pinctrl_pm_select_default_state(dev);
+	if (ret)
+		goto err_opp_set_rate_zero;
 
 	ret = icc_enable(ctrl->icc_path_cpu_to_qspi);
 	if (ret) {
 		dev_err_ratelimited(ctrl->dev, "%s: ICC enable failed for cpu: %d\n",
 			__func__, ret);
-		return ret;
+		goto err_select_sleep_state;
 	}
 
 	ret = clk_bulk_prepare_enable(QSPI_NUM_CLKS, ctrl->clks);
 	if (ret)
-		return ret;
+		goto err_disable_icc;
 
-	return dev_pm_opp_set_rate(dev, ctrl->last_speed * 4);
+	return 0;
+
+err_disable_icc:
+	icc_disable(ctrl->icc_path_cpu_to_qspi);
+err_select_sleep_state:
+	pinctrl_pm_select_sleep_state(dev);
+err_opp_set_rate_zero:
+	dev_pm_opp_set_rate(dev, 0);
+	return ret;
 }
 
 static int __maybe_unused qcom_qspi_suspend(struct device *dev)
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B0E1F707A;
	Tue,  3 Dec 2024 15:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239597; cv=none; b=PsbBogAc2gstHK82yvcdHd2IghwWwoXCnL598B2dJN+SANvaYHsIgPoTX7DeZdHRrw/xYqnj5IZ0lSyiOk4D6nZZGqfcZUme3Lz36c5u+RMz/VJzTQt1NIm0nBfIPNFMj+/NKzK8DrbNMtILj9cabm/msRROpVvg+s4SGkJWc/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239597; c=relaxed/simple;
	bh=m9zedYvgZqm+jUD+9kQl36tBD5pHpDWe9qX/WH0fzJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqIqy84n3TztXbgIesq1j2F9OKxU/4PDwrad34gpRNgWatxJYMmTofR8MfNlkDdHgUocm8cjJ/KsYDzgoNMMod0F4T84AIKbjsVForMV1zBKeSYicp+RB9GU4d0Gfs8F0SQAmaTadAUfeX8G6iqGHOCfcV3827z0d4QDq8mFl1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAsrZ1ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAsrZ1ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE29CC4CECF;
	Tue,  3 Dec 2024 15:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239597;
	bh=m9zedYvgZqm+jUD+9kQl36tBD5pHpDWe9qX/WH0fzJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAsrZ1otBukzZytYzMAr+CpMSrBuCmaWViTojoQ+cQP0WPiVwvrDWP4FmjfPM4Kur
	 dLtVuVh/+xJfxiT4Mai19mwyzOdv0Lwl25txypH3I72FGEz/fGttSfangY065nzvv4
	 Xv/pLe8XvpEoaVntQKqS851Rk1k6qdDEUiPm66ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjelique Melendez <quic_amelende@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.11 668/817] pinctrl: qcom: spmi: fix debugfs drive strength
Date: Tue,  3 Dec 2024 15:44:00 +0100
Message-ID: <20241203144022.031672566@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 6bc0ebfb1d920f13c522545f114cdabb49e9408a upstream.

Commit 723e8462a4fe ("pinctrl: qcom: spmi-gpio: Fix the GPIO strength
mapping") fixed a long-standing issue in the Qualcomm SPMI PMIC gpio
driver which had the 'low' and 'high' drive strength settings switched
but failed to update the debugfs interface which still gets this wrong.

Fix the debugfs code so that the exported values match the hardware
settings.

Note that this probably means that most devicetrees that try to describe
the firmware settings got this wrong if the settings were derived from
debugfs. Before the above mentioned commit the settings would have
actually matched the firmware settings even if they were described
incorrectly, but now they are inverted.

Fixes: 723e8462a4fe ("pinctrl: qcom: spmi-gpio: Fix the GPIO strength mapping")
Fixes: eadff3024472 ("pinctrl: Qualcomm SPMI PMIC GPIO pin controller driver")
Cc: Anjelique Melendez <quic_amelende@quicinc.com>
Cc: stable@vger.kernel.org	# 3.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/20241025121622.1496-1-johan+linaro@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -667,7 +667,7 @@ static void pmic_gpio_config_dbg_show(st
 		"push-pull", "open-drain", "open-source"
 	};
 	static const char *const strengths[] = {
-		"no", "high", "medium", "low"
+		"no", "low", "medium", "high"
 	};
 
 	pad = pctldev->desc->pins[pin].drv_data;



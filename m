Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A402215762;
	Thu, 12 Dec 2024 16:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020108; cv=none; b=dKCa50N3AzDSluW79NoXAiBRafeqLMfc/zd3uE+W4L3IB7l3XREy4m9sy3txMQNUSamEwGjrN9hwe4a66kE9sylBAPJxA9Z4rJIlDFLRNtrC311bzZxYaFdIwX5htB9y2AhRzDmMdoyNBnQ9n/lq6eZWzMtpcINBX68xC55cZr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020108; c=relaxed/simple;
	bh=gAIH7298//nmMWW1s1kCFgM641YA0cWeFc1UithLN4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbB526OV+Xa6nekHWQU48szaxFwGC0TMp7XXfZsTKubdHd/Ldy7oaj0uuEBxJKCf/v5xw0rkJTrkR5I2BexFiN/bU+Sz7xnT6aoWZVvnGlq5Wpyq9Q8CxANOKrzGYyWqXPyzqg3SlmgKdkpvRxeyNwrnAaQNkx/gQb5BrrbuyaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQWaU7FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQWaU7FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91744C4CECE;
	Thu, 12 Dec 2024 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020108;
	bh=gAIH7298//nmMWW1s1kCFgM641YA0cWeFc1UithLN4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQWaU7FUma5Yd7iFCxECViqTFBUGy4YWwE3GqGMf7GSADNHARgUXIdBhl9tZF4rrs
	 Uk3rZh8a/WprIiSBLH08TWrK1S+A68svMojVYsTLwQzUMvS/G0PjgCpaxAbGpWhiwm
	 K8Ib2L1GV/HZ+3hZitXr3iT671VW5eBuLm8MKAKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjelique Melendez <quic_amelende@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 379/772] pinctrl: qcom: spmi: fix debugfs drive strength
Date: Thu, 12 Dec 2024 15:55:24 +0100
Message-ID: <20241212144405.560839167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -665,7 +665,7 @@ static void pmic_gpio_config_dbg_show(st
 		"push-pull", "open-drain", "open-source"
 	};
 	static const char *const strengths[] = {
-		"no", "high", "medium", "low"
+		"no", "low", "medium", "high"
 	};
 
 	pad = pctldev->desc->pins[pin].drv_data;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD48A7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADA8C433D6;
	Wed,  2 Nov 2022 02:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357170;
	bh=8cQc6Un0w4KR/P54r8bLXsLCmMqaMkPwhP7ER2pMUu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7Mr2m5XM6joPblCtN9y5rbeLgHtch0oxJjB8xoQAuWkPI+RM4be/nwJ1FXJb4otq
	 DOevnAKy+m5iO4jgZl5qWF64+jWGvNKsvFkfwiJT1v3OsIAl/EC2FGPMOUqDFYcFck
	 4NzSZoqIwSWH1HVsTKXMHGBY26Q/WY5oRp3YOAdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.0 096/240] Revert "pinctrl: pinctrl-zynqmp: Add support for output-enable and bias-high-impedance"
Date: Wed,  2 Nov 2022 03:31:11 +0100
Message-Id: <20221102022113.565800229@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

commit 9989bc33c4894e0751679b91fc6eb585772487b9 upstream.

This reverts commit ad2bea79ef0144043721d4893eef719c907e2e63.

On systems with older PMUFW (Xilinx ZynqMP Platform Management Firmware)
using these pinctrl properties can cause system hang because there is
missing feature autodetection.
When this feature is implemented in the PMUFW, support for these two
properties should bring back.

Cc: stable@vger.kernel.org
Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20221017130303.21746-2-sai.krishna.potthuri@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-zynqmp.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-zynqmp.c b/drivers/pinctrl/pinctrl-zynqmp.c
index 7d2fbf8a02cd..c98f35ad8921 100644
--- a/drivers/pinctrl/pinctrl-zynqmp.c
+++ b/drivers/pinctrl/pinctrl-zynqmp.c
@@ -412,10 +412,6 @@ static int zynqmp_pinconf_cfg_set(struct pinctrl_dev *pctldev,
 
 			break;
 		case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
-			param = PM_PINCTRL_CONFIG_TRI_STATE;
-			arg = PM_PINCTRL_TRI_STATE_ENABLE;
-			ret = zynqmp_pm_pinctrl_set_config(pin, param, arg);
-			break;
 		case PIN_CONFIG_MODE_LOW_POWER:
 			/*
 			 * These cases are mentioned in dts but configurable
@@ -424,11 +420,6 @@ static int zynqmp_pinconf_cfg_set(struct pinctrl_dev *pctldev,
 			 */
 			ret = 0;
 			break;
-		case PIN_CONFIG_OUTPUT_ENABLE:
-			param = PM_PINCTRL_CONFIG_TRI_STATE;
-			arg = PM_PINCTRL_TRI_STATE_DISABLE;
-			ret = zynqmp_pm_pinctrl_set_config(pin, param, arg);
-			break;
 		default:
 			dev_warn(pctldev->dev,
 				 "unsupported configuration parameter '%u'\n",
-- 
2.38.1




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217403;
	b=n4RC6g4g9NJUaWwmCWJqMiKMLxpNhBfppOrWH1F+0CrqjpZMzu/OUetyJezi2fCj7eys
	 9SQG8p7uo64ZQxu9OeSKQJYVKEqFxIWVM9NR8kkIakdL8bYXStOfwVBiYIwk5Jrvc58AO
	 cpJ4wLdZRWi1RKYO4tI3qVvFOsw9gQG7jk4hEXE66nyHnQTjZ6m8wCBO3a4WyZfmHMJ6T
	 512W4Q++tLMDRGW272p6y2M3q/vjIfR86Wn3qI2evDluphTP/+zOXbcagr+FVeZTorgJ9
	 1YIGS9E9bqDrMzGCjBYaf74CN1TU2YsmPACOrqhLfM1/5GU4FjyDQ3KjsjaDflFFAdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A+utrLaNEJck9Hkmws4SisPQYRstgMxpiFg7DFYFPSA=;
	b=y3IcrE5sl9P+TZ5EQwHAnRMqA9Ca7VjmDRnARZKipJC5xqRI5vBgn1I0TQpx0d5YHmCt
	 FRMwuEcmCv3CQhOjUx9ao1DPKfo9k99WEczv2skAV7/krs9KqUkf+S11DpknjpTTsDZfN
	 ucafQQeg8bHGqNJIll3sHASblB/DJB7ij80Bd0i+er4tW9zKQKS8Hq3KA4u50cc2XF09Q
	 ZnFtakyoFpffBmEGBplaOA0SvNNhazqYK3a2SQDtiiwMPnQPTkGR4QpPrzYwt8VWBrDN1
	 bhzYb4L8b2Nn9IF1NwWuduScC/b4guZeTeomqtU5olAU0nKtz6yonTyruAlj3SO5B2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMSCpOQI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F3B606A31C;
	Wed, 28 Oct 2026 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMSCpOQI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DF41F031E1;
	Wed, 28 Oct 2026 19:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217403;
	bh=A+utrLaNEJck9Hkmws4SisPQYRstgMxpiFg7DFYFPSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMSCpOQIDn5Z53wlY2Ue7h+A0A7BMNDifgLor/3QFpvu6P/lO0tuRkNP5TwgyWDAa
	 K08xv1DPjVXwpX9rlPALmxBKC2cz4XOLBdZojemOTP0kOrwg4IUtfRBUFX+NLeDB48
	 CUnwwr+bKM6YNahozExeiPyLk0E63Wq3/22qO6d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1885/1887] gpio: mxc: map Both Edge pad wakeup to Rising Edge
Date: Wed, 28 Oct 2026 18:06:21 +0100
Message-ID: <20261028170542.353340786@linuxfoundation.org>
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

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit c720fb57d56274213d027b3c5ab99080cf62a306 ]

Suspend may fail on i.MX8QM when Falling Edge is used as a pad wakeup
trigger due to a hardware bug in the detection logic. Since the hardware
does not support Both Edge wakeup, remap requests for Both Edge to Rising
Edge by default to avoid hitting this issue.

A warning is emitted when Falling Edge is selected on i.MX8QM.

Fixes: f60c9eac54af ("gpio: mxc: enable pad wakeup on i.MX8x platforms")
cc: stable@vger.kernel.org
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Link: https://patch.msgid.link/20260324192129.2797237-1-shenwei.wang@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 36dcd082ef893..97186bce32bba 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -541,12 +541,13 @@ static bool mxc_gpio_set_pad_wakeup(struct mxc_gpio_port *port, bool enable)
 	unsigned long config;
 	bool ret = false;
 	int i, type;
+	bool is_imx8qm = of_device_is_compatible(port->dev->of_node, "fsl,imx8qm-gpio");
 
 	static const u32 pad_type_map[] = {
 		IMX_SCU_WAKEUP_OFF,		/* 0 */
 		IMX_SCU_WAKEUP_RISE_EDGE,	/* IRQ_TYPE_EDGE_RISING */
 		IMX_SCU_WAKEUP_FALL_EDGE,	/* IRQ_TYPE_EDGE_FALLING */
-		IMX_SCU_WAKEUP_FALL_EDGE,	/* IRQ_TYPE_EDGE_BOTH */
+		IMX_SCU_WAKEUP_RISE_EDGE,	/* IRQ_TYPE_EDGE_BOTH */
 		IMX_SCU_WAKEUP_HIGH_LVL,	/* IRQ_TYPE_LEVEL_HIGH */
 		IMX_SCU_WAKEUP_OFF,		/* 5 */
 		IMX_SCU_WAKEUP_OFF,		/* 6 */
@@ -561,6 +562,13 @@ static bool mxc_gpio_set_pad_wakeup(struct mxc_gpio_port *port, bool enable)
 				config = pad_type_map[type];
 			else
 				config = IMX_SCU_WAKEUP_OFF;
+
+			if (is_imx8qm && config == IMX_SCU_WAKEUP_FALL_EDGE) {
+				dev_warn_once(port->dev,
+					      "No falling-edge support for wakeup on i.MX8QM\n");
+				config = IMX_SCU_WAKEUP_OFF;
+			}
+
 			ret |= mxc_gpio_generic_config(port, i, config);
 		}
 	}
-- 
2.53.0




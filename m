Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F69E31730
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5cRp/6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C876AC433C8;
	Wed, 15 Nov 2023 19:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077516;
	bh=uQ2KDbkNx3ZDknNRS8CIEbofQJc5yDOEwzExSDyNqXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5cRp/6XWyuK6a3Zrb1GA0Cf4abuO9p+HoF24/5JGfhhlCe8sCHnuwsCfUwo1W2lM
	 gE/GHFPeK3E8Dx3tNlv7PKiUa0xeyW1lirS0WmugXRX0l5PvJOhwBH4JMgnRlkUcEy
	 itYtivfhVVUkXr0eAWbusQv6s+8yspZncI6TXsgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Ser <contact@emersion.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 325/603] soc: qcom: pmic_glink: fix connector type to be DisplayPort
Date: Wed, 15 Nov 2023 14:14:30 -0500
Message-ID: <20231115191635.997548588@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f86955f2b1ff9fbc7ae4f6595112b2f896885366 ]

As it was pointed out by Simon Ser, the DRM_MODE_CONNECTOR_USB connector
is reserved for the GUD devices. Other drivers (i915, amdgpu) use
DRM_MODE_CONNECTOR_DisplayPort even if the DP stream is handled by the
USB-C altmode. While we are still working on implementing the proper way
to let userspace know that the DP is wrapped into USB-C, change
connector type to be DRM_MODE_CONNECTOR_DisplayPort.

Fixes: 080b4e24852b ("soc: qcom: pmic_glink: Introduce altmode support")
Cc: Simon Ser <contact@emersion.fr>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Acked-by: Simon Ser <contact@emersion.fr>
Link: https://lore.kernel.org/r/20231010225229.77027-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink_altmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pmic_glink_altmode.c b/drivers/soc/qcom/pmic_glink_altmode.c
index d05e0d6edf493..974c14d1e0bfc 100644
--- a/drivers/soc/qcom/pmic_glink_altmode.c
+++ b/drivers/soc/qcom/pmic_glink_altmode.c
@@ -465,7 +465,7 @@ static int pmic_glink_altmode_probe(struct auxiliary_device *adev,
 		alt_port->bridge.funcs = &pmic_glink_altmode_bridge_funcs;
 		alt_port->bridge.of_node = to_of_node(fwnode);
 		alt_port->bridge.ops = DRM_BRIDGE_OP_HPD;
-		alt_port->bridge.type = DRM_MODE_CONNECTOR_USB;
+		alt_port->bridge.type = DRM_MODE_CONNECTOR_DisplayPort;
 
 		ret = devm_drm_bridge_add(dev, &alt_port->bridge);
 		if (ret)
-- 
2.42.0




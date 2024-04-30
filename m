Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D0A12DD83;
	Tue, 30 Apr 2024 11:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475668; cv=none; b=eozxCgy3lAmRndOxDqCBSoI6xClLFVNwWJinjnNSoC+bb/SkYbE5fPUar8cUtoNchd8zrs6yVmvs7Us/4SnYpP2Een8LRsfspdTa/HrRjAoHDjZd+uQ2PS6FPP1+3hJhwqnh+8WVOp8qfkehM/I+l5Xx1WJFn03VFtTPDhNUYJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475668; c=relaxed/simple;
	bh=g+j3IfE/ag/EQvhhSlBi65O7wtIQpFJaY010pFAJ1gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kba9ohAKcTtXJ2EASQ6ykEoo3dOs0yfyyt9ZB4e5FkYslCjGqeGfFuj6+RZi88S6Wdxm5lbSW232JcJPsj6rbX7Cx7w2OkaKIG9Uc+QwgXqikMuWJJT/r1Z+XxAEpdhx+nkAXd9MjOG4NPWYHa70mTa9IPDIg4JuZmwqcjjMBTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nbm6hWu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nbm6hWu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAFAC4AF1A;
	Tue, 30 Apr 2024 11:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475668;
	bh=g+j3IfE/ag/EQvhhSlBi65O7wtIQpFJaY010pFAJ1gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nbm6hWu3vwRLsZE5I8iy4anWif08sA486jxozXT5udlKt5V9QQ1UFovrnXEvEmc4O
	 M0A0UK8/GE9klejvfM90QaPRrPzH4dRQATKZ8vowX7asshWrALY5Ammsd8VJ5t/32D
	 h84EPtWNSF5HxJ5IqvAxAdzup0+WnR4JClFYLAvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/186] phy: qcom: m31: match requested regulator name with dt schema
Date: Tue, 30 Apr 2024 12:40:20 +0200
Message-ID: <20240430103102.908573730@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 47b3e2f3914ae5e8d9025d65ae5cffcbb54bc9c3 ]

According to the 'qcom,ipq5332-usb-hsphy.yaml' schema, the 5V
supply regulator must be defined via the 'vdd-supply' property.
The driver however requests for the 'vdda-phy' regulator which
results in the following message when the driver is probed on
a IPQ5018 based board with a device tree matching to the schema:

  qcom-m31usb-phy 5b000.phy: supply vdda-phy not found, using dummy regulator
  qcom-m31usb-phy 5b000.phy: Registered M31 USB phy

This means that the regulator specified in the device tree never
gets enabled.

Change the driver to use the 'vdd' name for the regulator as per
defined in the schema in order to ensure that the corresponding
regulator gets enabled.

Fixes: 08e49af50701 ("phy: qcom: Introduce M31 USB PHY driver")
Reviewed-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240406-phy-qcom-m31-regulator-fix-v2-1-c8e9795bc071@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-m31.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-m31.c b/drivers/phy/qualcomm/phy-qcom-m31.c
index 5cb7e79b99b3f..89c9d74e35466 100644
--- a/drivers/phy/qualcomm/phy-qcom-m31.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31.c
@@ -253,7 +253,7 @@ static int m31usb_phy_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(qphy->phy),
 						"failed to create phy\n");
 
-	qphy->vreg = devm_regulator_get(dev, "vdda-phy");
+	qphy->vreg = devm_regulator_get(dev, "vdd");
 	if (IS_ERR(qphy->vreg))
 		return dev_err_probe(dev, PTR_ERR(qphy->vreg),
 						"failed to get vreg\n");
-- 
2.43.0




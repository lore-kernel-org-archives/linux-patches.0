Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03DE7BAF0;
	Mon,  4 Mar 2024 21:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587998; cv=none; b=saV3Ci6ecAnLINCymZAOdSzr+B1xLdihaD4CMRJjgM73+2OJPGzpFzyuNGREV4X/g92YX7NviyEy6uIrh9796v+1JUA8Izf0A10iFarSwhiXTpNINaeBP1sBQ8bheryJ2NjZo+aw6kwHPJ7esk1jFIebjcF+J78iWEMXlqbWhZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587998; c=relaxed/simple;
	bh=JoZ1zzBTxPqmADWaJmWvPCIEkBHUXYx/zHeu4VF7VPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTQ/+U5t0pNt/VX7XghYlw5gs6P1fkk4jA8t7HsEMW005pJHYMQfuSSLZ9sBEPQP8xwHhjsHe1HFmYQvNOtdlB6fvzFOA27yFn7JrdbM7ojdwGDLlJBv5L3wAT2X2QRM80XKwIGQ94mmY2ne1NC3i1XUgGLRF0y4CRw08cdiOVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BBzG979; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BBzG979"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8168AC433F1;
	Mon,  4 Mar 2024 21:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587997;
	bh=JoZ1zzBTxPqmADWaJmWvPCIEkBHUXYx/zHeu4VF7VPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BBzG979Fx4hERXcqifY6GLw/LOm8SOkKjtjSGtNFY6Yx+6X9SPfC7PPKof1ArCKh
	 D1cW10IOhJrtCpp4bp6v9my6QNoN//zedtd3hH0eqCGXvo4Ic8+7HW1ukFmAbr2ok1
	 VFUsx/QwkB1mPwvBVC7aDfHz+HZUpHlvSJ7VQ0/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 142/162] phy: qcom: phy-qcom-m31: fix wrong pointer pass to PTR_ERR()
Date: Mon,  4 Mar 2024 21:23:27 +0000
Message-ID: <20240304211556.256611378@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 95055beb067cb30f626fb10f7019737ca7681df0 ]

It should be 'qphy->vreg' passed to PTR_ERR() when devm_regulator_get() fails.

Fixes: 08e49af50701 ("phy: qcom: Introduce M31 USB PHY driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Link: https://lore.kernel.org/r/20230824091345.1072650-1-yangyingliang@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-m31.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-m31.c b/drivers/phy/qualcomm/phy-qcom-m31.c
index c2590579190a9..03fb0d4b75d74 100644
--- a/drivers/phy/qualcomm/phy-qcom-m31.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31.c
@@ -299,7 +299,7 @@ static int m31usb_phy_probe(struct platform_device *pdev)
 
 	qphy->vreg = devm_regulator_get(dev, "vdda-phy");
 	if (IS_ERR(qphy->vreg))
-		return dev_err_probe(dev, PTR_ERR(qphy->phy),
+		return dev_err_probe(dev, PTR_ERR(qphy->vreg),
 				     "failed to get vreg\n");
 
 	phy_set_drvdata(qphy->phy, qphy);
-- 
2.43.0




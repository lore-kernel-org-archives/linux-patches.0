Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DA120C488;
	Tue, 29 Apr 2025 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950159; cv=none; b=t7LUwWbGfGfyaydM/BqHrW4Rz9F1DZYTlB2fHOtECg4QwkLBTi6fbtmxY2LaP/zboE9KtPJIXB0Yp1pq5CEJ0JskiQVh649PRv+Bj8cV1c6JAg/nc33Ty4S2IbWHHeseuSHPdRq2Ax8uYG0E8d2agH89c3Wb/LCCQZhwuP2JcsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950159; c=relaxed/simple;
	bh=HL/2BcVi+bImFtcSQFumLNUZ+qGozjMiv7kKJ5S3ni4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adyKlVZRUReV91ff4OEr0vovskxs/iWf1YATRGamPgh/T/bvE3iAjfDkDOkNcxDWizI/G5NQFRSx9ckKNAc+5m5EyqFrvT9iqOSo2FnY/28Eh94SVslpXDwwFn5rrN8I889DglZIHNbu++jgvhndPCHipYYIJXnazLegC07/kpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+vKTWQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+vKTWQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2780C4CEE3;
	Tue, 29 Apr 2025 18:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950159;
	bh=HL/2BcVi+bImFtcSQFumLNUZ+qGozjMiv7kKJ5S3ni4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+vKTWQOHswMCNHofcJ/cKieL7f5/3HObtinPfVA6iPnAmWlwiwpUdnmbForvB85I
	 ai4jZBwWfyCEWiXb3GQoKCFd63VJtzsbzDnbJbMQFEd8sI+z4hDfq7aKJiuGEG/+Fk
	 Hfmewf0MPEQVTs5zA2TxzkjJSbm6yUHJnx66ZqDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Marek Vasut <marex@denx.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 163/167] phy: freescale: imx8m-pcie: Add one missing error return
Date: Tue, 29 Apr 2025 18:44:31 +0200
Message-ID: <20250429161058.320485973@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Richard Zhu <hongxing.zhu@nxp.com>

commit b574baa64cf84e7793fe79f4491ae36c16e65a0b upstream.

There should be one error return when fail to fetch the perst reset.
Add the missing error return.

Fixes: dce9edff16ee ("phy: freescale: imx8m-pcie: Add i.MX8MP PCIe PHY support")

Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/1671433941-2037-1-git-send-email-hongxing.zhu@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/freescale/phy-fsl-imx8m-pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
+++ b/drivers/phy/freescale/phy-fsl-imx8m-pcie.c
@@ -271,7 +271,7 @@ static int imx8_pcie_phy_probe(struct pl
 		imx8_phy->perst =
 			devm_reset_control_get_exclusive(dev, "perst");
 		if (IS_ERR(imx8_phy->perst))
-			dev_err_probe(dev, PTR_ERR(imx8_phy->perst),
+			return dev_err_probe(dev, PTR_ERR(imx8_phy->perst),
 				      "Failed to get PCIE PHY PERST control\n");
 	}
 



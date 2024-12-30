Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F151C1ACEA1;
	Mon, 30 Dec 2024 15:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574057; cv=none; b=qsMiaDoLUs/TjscFW/32AacCjQZrAINe7E2qKF5qF7PO4HYR99HjPB1jyLnXSQM7ATGqLaupZCkzzJ4J+Z1g9ec71j6dtni+xfN28utp+RtF4G7IxPuC7GOS2f4h/qI4rWnRsuQll6Hn013LEfuZ952EilGuMGlZQI52Hrc1XyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574057; c=relaxed/simple;
	bh=co1MyJN1LMgwbbFt2kkb01uZKdK+AZjIujUTea2VZ1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ7IdppRrRC2ItCJLkqWquTsnkYqDVbTE8Q34nWhNpBUWQSHCVHUsQn7hDYampliSDNgaPvw90gCjoe7WUeKlXwLIFF6xf6xplrQJ04tr7h57XYqFBuHfsPQ3rsQwvlpKE+CV6Mc5vbcPwUexhbMy8gAGGmxKwKVOBgSEzyPPxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlPyRdbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlPyRdbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4A4C4CED2;
	Mon, 30 Dec 2024 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574056;
	bh=co1MyJN1LMgwbbFt2kkb01uZKdK+AZjIujUTea2VZ1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlPyRdbYHWgzs40SquO4ZQWyydfd/79ttsgyE/dA5zf+Vm0yrDa14jNp4zwIixrCC
	 FNNYFUdT3kXqaxRSiAsDuzBjqCTJWy25DorfMxmVMdwVF0u0/y3PQMcTpvNclt3bWz
	 CvkGNw0t964Clx766r50fZNCYcu2Q++sEofMF0sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 018/114] phy: qcom-qmp: Fix register name in RX Lane config of SC8280XP
Date: Mon, 30 Dec 2024 16:42:15 +0100
Message-ID: <20241230154218.763704933@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <quic_kriskura@quicinc.com>

commit 8886fb3240931a0afce82dea87edfe46bcb0a586 upstream.

In RX Lane configuration sequence of SC8280XP, the register
V5_RX_UCDR_FO_GAIN is incorrectly spelled as RX_UCDR_SO_GAIN and
hence the programming sequence is wrong. Fix the register sequence
accordingly to avoid any compliance failures. This has been tested
on SA8775P by checking device mode enumeration in SuperSpeed.

Cc: stable@vger.kernel.org
Fixes: c0c7769cdae2 ("phy: qcom-qmp: Add SC8280XP USB3 UNI phy")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241112092831.4110942-1-quic_kriskura@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -1008,7 +1008,7 @@ static const struct qmp_phy_init_tbl sc8
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_FO_GAIN, 0x2f),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_COUNT_LOW, 0xff),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_COUNT_HIGH, 0x0f),
-	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_SO_GAIN, 0x0a),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FO_GAIN, 0x0a),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_VGA_CAL_CNTRL1, 0x54),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_VGA_CAL_CNTRL2, 0x0f),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_EQU_ADAPTOR_CNTRL2, 0x0f),



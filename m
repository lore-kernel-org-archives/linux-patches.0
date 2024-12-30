Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ADE15E8B;
	Mon, 30 Dec 2024 15:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573713; cv=none; b=pXFPHCTieqe7bp4WlJj9FPvMLG+o3GtfoZnDHs893uFIRpLPiZVc6Zg8Ml725gZ5TFDgdrO29tTPD/dGh2r1RC/sanmxqG1L1+PdhEiof0IfVJ5r+7dKMDCwflRzuqJ6DCixmHljsL0K9480XUpKNdyU98UaVynq7yeW1lXWXsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573713; c=relaxed/simple;
	bh=gxnDXKjLyv9PfdjryxkQ8vtTYxt6M5Ubwb0ExdJrLgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k108no8WXHm4WpeDatyOEOMq9R3ztxN70jju0X7mOAyOQXTpmhM2GxbouSLya7RVg0qpSaDZ/qiJjYvqcvQ/Z/2u3QPlLUzWZBhvYbf0tOKiFkUPq+PDMiHjrSg9XGJucB6oERFr4ZHFarQmy72uJAEsG0NitPjlj20Uw14rqJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyxjrgiO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyxjrgiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653E4C4CED0;
	Mon, 30 Dec 2024 15:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573712;
	bh=gxnDXKjLyv9PfdjryxkQ8vtTYxt6M5Ubwb0ExdJrLgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MyxjrgiOAo1JzuZ+b2oYbwTqhankNaiB+M0fJdDVZvYkU4+fLrK086ad/KPmsfz+Q
	 XbWss/wN/GKkdRo8E80DXlSqcVjzgj7YVOuesCAdVDO2TmemDB8cUTTOvmV++M+dJK
	 z9dh1kCPWxFFdPW0OxQF9oTqPeiiwm63ejJdYB0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 14/86] phy: qcom-qmp: Fix register name in RX Lane config of SC8280XP
Date: Mon, 30 Dec 2024 16:42:22 +0100
Message-ID: <20241230154212.257616264@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1088,7 +1088,7 @@ static const struct qmp_phy_init_tbl sc8
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_FO_GAIN, 0x2f),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_COUNT_LOW, 0xff),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_COUNT_HIGH, 0x0f),
-	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_SO_GAIN, 0x0a),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FO_GAIN, 0x0a),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_VGA_CAL_CNTRL1, 0x54),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_VGA_CAL_CNTRL2, 0x0f),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_EQU_ADAPTOR_CNTRL2, 0x0f),



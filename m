Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2DC126C13;
	Mon, 30 Dec 2024 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573485; cv=none; b=gRcHKuNy25n1bHZHpRNWbzn0DQHhoHTEntxIfDxaqCQ/jxcSekPxsvkhNNEPTBAWHWnbiUrSSldghBQ8JQshFGpMXHVeSlnPaal8HIQv2CIAQfZ0UUfon8LdK31l+Zn33HyxOD7L5GGStHdtuuJxebSNa97btlIZFapnIgWnHT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573485; c=relaxed/simple;
	bh=6zBgGMgpq+lf5Yo7DkFDLBaDNy9qaWIkXOiAUOFzSm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVAfRaXnhFm0epAYO+6CvgdIdQdqSolVswQzl8Oyc+N+2j2PKBilxwTtOE9FjtrROzsQjWb1ad4l+P6pIzqg+UJ9ofE0LNuYrruZERvkfLrcoCaeKKg+UzNuaTYLcrSigwNjtWydgAf/xIC9OetJzq9hTA/dQsGFCLB1TPj0DKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXeHSLC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXeHSLC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50AAC4CED0;
	Mon, 30 Dec 2024 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573485;
	bh=6zBgGMgpq+lf5Yo7DkFDLBaDNy9qaWIkXOiAUOFzSm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXeHSLC9eD24tg0hZ5b0SeR0X2jTgmDrn+1s8dNVuG2hXTHp/R0MyujXYiM8K0W8V
	 GmcHJi0B4265qdFv0lS6AGIZE+UZDc2FMT+UGvDYo9KcJFAhvH8n+rQis3fJua/kif
	 lHoIHvXM7rXquzJpU+Ku3rjs0OZiIm/04WzF5Fx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 10/60] phy: qcom-qmp: Fix register name in RX Lane config of SC8280XP
Date: Mon, 30 Dec 2024 16:42:20 +0100
Message-ID: <20241230154207.676261088@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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
@@ -1393,7 +1393,7 @@ static const struct qmp_phy_init_tbl sc8
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_FO_GAIN, 0x2f),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_COUNT_LOW, 0xff),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FASTLOCK_COUNT_HIGH, 0x0f),
-	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_SO_GAIN, 0x0a),
+	QMP_PHY_INIT_CFG(QSERDES_V5_RX_UCDR_FO_GAIN, 0x0a),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_VGA_CAL_CNTRL1, 0x54),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_VGA_CAL_CNTRL2, 0x0f),
 	QMP_PHY_INIT_CFG(QSERDES_V5_RX_RX_EQU_ADAPTOR_CNTRL2, 0x0f),



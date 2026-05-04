Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A943DE43C;
	Mon,  4 May 2026 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904278; cv=none; b=C3oLqd/QaGZmp8kqEz4hqE9Af0dS3AuR6xyLP0sEuFxWDIzrVapmvEBa+kfp0N9FMY7qLAXkiP2/TRr/yOPlLRh84pC4HIJK+hBIzZwr88Utzt2BpCArBKKUQhiAP/2MNo5zVoeeGylp/Y6pv6lZJSmfjF+NglN0X+FEwxdJ4TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904278; c=relaxed/simple;
	bh=Tfk/xu+xV+GKHLXj3/rzgGA6Ggk9Tju3F4ADY9QaJnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5wxJMtKx7pkCGV2uWNE4+JmZp0PMopd3C7h02aVjJeqe/PC4fQ1aY8pi2tbAqmcQwsWco3tPT8Jb4Exf3+NxAiggTtwLkJl7kWxdyIANg8KHVfQIM5mNrKHteoKTQomy4h4OaZf+6WB8w9EcQOzWDNj2R2CMmusMnOqP18BVKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpaNX2BN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpaNX2BN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A037C2BCB8;
	Mon,  4 May 2026 14:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904277;
	bh=Tfk/xu+xV+GKHLXj3/rzgGA6Ggk9Tju3F4ADY9QaJnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpaNX2BNE862OdAdulnNtb3klRYykvsJGsrvipV6qCeKpzlAWa+7dqMuYND1Un4Kz
	 vvpHZ/PNi6RNwnPgcWZ6fW4PQdcBWn27xTLvpeQGkQEyojbaUwQb0KCOYklSDqbpUh
	 Y0P+oCTwmpdTppzqgzjnRGXRw9h0JJxc6uVgMQLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronak Raheja <ronak.raheja@oss.qualcomm.com>,
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 252/275] phy: qcom: m31-eusb2: Update init sequence to set PHY_ENABLE
Date: Mon,  4 May 2026 15:53:12 +0200
Message-ID: <20260504135152.400163481@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronak Raheja <ronak.raheja@oss.qualcomm.com>

[ Upstream commit 7044ed6749c8a7d49e67b2f07f42da2f29d26be6 ]

Certain platforms may not have the PHY_ENABLE bit set on power on reset.
Update the current sequence to explicitly write to enable the PHY_ENABLE
bit.  This ensures that regardless of the platform, the PHY is properly
enabled.

Signed-off-by: Ronak Raheja <ronak.raheja@oss.qualcomm.com>
Signed-off-by: Wesley Cheng <wesley.cheng@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20250920032158.242725-1-wesley.cheng@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 520a98bdf7ae ("phy: qcom: m31-eusb2: clear PLL_EN during init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-m31-eusb2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
@@ -25,6 +25,7 @@
 #define POR				BIT(1)
 
 #define USB_PHY_HS_PHY_CTRL_COMMON0	(0x54)
+#define PHY_ENABLE			BIT(0)
 #define SIDDQ_SEL			BIT(1)
 #define SIDDQ				BIT(2)
 #define FSEL				GENMASK(6, 4)
@@ -81,6 +82,7 @@ struct m31_eusb2_priv_data {
 static const struct m31_phy_tbl_entry m31_eusb2_setup_tbl[] = {
 	M31_EUSB_PHY_INIT_CFG(USB_PHY_CFG0, UTMI_PHY_CMN_CTRL_OVERRIDE_EN, 1),
 	M31_EUSB_PHY_INIT_CFG(USB_PHY_UTMI_CTRL5, POR, 1),
+	M31_EUSB_PHY_INIT_CFG(USB_PHY_HS_PHY_CTRL_COMMON0, PHY_ENABLE, 1),
 	M31_EUSB_PHY_INIT_CFG(USB_PHY_CFG1, PLL_EN, 1),
 	M31_EUSB_PHY_INIT_CFG(USB_PHY_FSEL_SEL, FSEL_SEL, 1),
 };



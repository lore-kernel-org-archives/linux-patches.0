Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C48D24B34;
	Mon, 14 Oct 2024 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916670; cv=none; b=jWSmQ28TFrGmZz+qqjJgX325lNaZtbYab0zsjT4S1VNi4/sAU8muIpZ7va64QE3aarqZm9WqZ8a4vmPaqWwI4gaFi/xtEC05QsPfMu7O43c9kokzysjcI8ZJmsG5r7k/O6tK5Njb5KvCa0ePXAl/zSmris5+/3L/OmGf4hl+69A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916670; c=relaxed/simple;
	bh=G1iDkE22l+fjjjL8LrdPLpJOo0SS0VIBtN/LWWEiEHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdBJiODRsxUrSxSgsqxcVldHr1ujtKQFRuctnA/iOJ4QHzT5iow9p+c+VHz6xreRgdsptZ4PZULzvdwn/2uYaXNopDMsvvGn875tiL/SUEX4/MkEaSWGy2G+/xLAxZcKB1G17f33Aqmb7wkaAWZRS3NMoTGyPUbLK+wnC2eTl3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qC9mzXE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qC9mzXE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377DEC4CEC3;
	Mon, 14 Oct 2024 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916669;
	bh=G1iDkE22l+fjjjL8LrdPLpJOo0SS0VIBtN/LWWEiEHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qC9mzXE5wosOtVeEu+uGxnFb1SRonV8ZRgwRgP1x9MsJKibYe/ZU7R9VzkzMnwYuA
	 sEUpjN3QNXcPXSd/BylqYjk6pBSPjZuKUDihy0rWH3iIzDRnFp3M8AwYRvYPllWT3r
	 Hhc48i6sztaVGo72LvKXgeGTsdUD2VsM4bfxdaqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/213] phy: qualcomm: phy-qcom-eusb2-repeater: Add tuning overrides
Date: Mon, 14 Oct 2024 16:18:31 +0200
Message-ID: <20241014141043.185943925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 56156a76e765d32009fee058697c591194d0829f ]

There are devices in the wild, like the Sony Xperia 1 V that *require*
different tuning than the base design for USB to work.

Add support for overriding the necessary tuning values.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230830-topic-eusb2_override-v2-4-7d8c893d93f6@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 734550d60cdf ("phy: qualcomm: eusb2-repeater: Rework init to drop redundant zero-out loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
index d4fb85c20eb0f..a623f092b11f6 100644
--- a/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
+++ b/drivers/phy/qualcomm/phy-qcom-eusb2-repeater.c
@@ -142,7 +142,9 @@ static int eusb2_repeater_init(struct phy *phy)
 {
 	struct reg_field *regfields = eusb2_repeater_tune_reg_fields;
 	struct eusb2_repeater *rptr = phy_get_drvdata(phy);
-	const u32 *init_tbl = rptr->cfg->init_tbl;
+	struct device_node *np = rptr->dev->of_node;
+	u32 init_tbl[F_NUM_TUNE_FIELDS] = { 0 };
+	u8 override;
 	u32 val;
 	int ret;
 	int i;
@@ -163,6 +165,19 @@ static int eusb2_repeater_init(struct phy *phy)
 			regmap_field_update_bits(rptr->regs[i], mask, 0);
 		}
 	}
+	memcpy(init_tbl, rptr->cfg->init_tbl, sizeof(init_tbl));
+
+	if (!of_property_read_u8(np, "qcom,tune-usb2-amplitude", &override))
+		init_tbl[F_TUNE_IUSB2] = override;
+
+	if (!of_property_read_u8(np, "qcom,tune-usb2-disc-thres", &override))
+		init_tbl[F_TUNE_HSDISC] = override;
+
+	if (!of_property_read_u8(np, "qcom,tune-usb2-preem", &override))
+		init_tbl[F_TUNE_USB2_PREEM] = override;
+
+	for (i = 0; i < F_NUM_TUNE_FIELDS; i++)
+		regmap_field_update_bits(rptr->regs[i], init_tbl[i], init_tbl[i]);
 
 	ret = regmap_field_read_poll_timeout(rptr->regs[F_RPTR_STATUS],
 					     val, val & RPTR_OK, 10, 5);
-- 
2.43.0




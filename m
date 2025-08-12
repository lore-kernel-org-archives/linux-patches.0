Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A8E2C21F6;
	Tue, 12 Aug 2025 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024570; cv=none; b=bEwf8aMlIJEqf3+A2gSWXDcXu4hYNPkNcZ9GPEgkVFwap40GnKFfyOCK4LohGgtmWMdUHThfgwGMPx/5MkBzT3ZMacuO0zKG8GYn7cZIvM2IGohXVz6msNPCgplWWncdr/4M5EfobxHnJhDuPB7td+TuUkktrFdPQRb7Bf1E2P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024570; c=relaxed/simple;
	bh=/W6M5VR89C/hKq7MKPm0uQ6wC+QJxl5yqIRhD4zf+EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9LY10UCcJ3qbaCYK1U7fgHb6SioquH9zWgS86keCtRCfRxJGfnqG6aQIZkfNjQXAjB17Gya3Ujs7d/QOFBdEcrn6zNy3zpqVZ8u+2QgH5L9FKjFJE9z2mMpTeuaa0/LOJn5XN9jU1BV/PJAfNeWxyo0Lg0xT3CBhxn1BifcpEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8wXe6lX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8wXe6lX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C607C4CEF0;
	Tue, 12 Aug 2025 18:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024570;
	bh=/W6M5VR89C/hKq7MKPm0uQ6wC+QJxl5yqIRhD4zf+EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8wXe6lX2nygvcWeeesuDY9mLKeqtjwYMrlmIQiWl7yyIZ8nJ4oZePiHThGvTsjbe
	 HAvsWUPtpISVID3RJQVWwuKBOshoCPesAvejJwXVZCL/wxfLvt8NcIolOmkSxppd9z
	 sYxvhq7s9pMngyYSvF47Ugxi3ydEXWw12oHIbmOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 411/627] phy: qcom: phy-qcom-snps-eusb2: Add missing write from init sequence
Date: Tue, 12 Aug 2025 19:31:46 +0200
Message-ID: <20250812173434.915402869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 7f5f703210109366c1e1b685086c9b0a4897ea54 ]

As per a commit from Qualcomm's downstream 6.1 kernel[0], the init
sequence is missing setting the CMN_CTRL_OVERRIDE_EN bit back to 0 at
the end, as per the 'latest' HPG revision (as of November 2023).

[0] https://git.codelinaro.org/clo/la/kernel/qcom/-/commit/b77774a89e3fda3246e09dd39e16e2ab43cd1329

Fixes: 80090810f5d3 ("phy: qcom: Add QCOM SNPS eUSB2 driver")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20250715-sm7635-eusb-phy-v3-3-6c3224085eb6@fairphone.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-snps-eusb2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/phy-snps-eusb2.c b/drivers/phy/phy-snps-eusb2.c
index 751b6d8ba2be..e78d222eec5f 100644
--- a/drivers/phy/phy-snps-eusb2.c
+++ b/drivers/phy/phy-snps-eusb2.c
@@ -437,6 +437,9 @@ static int qcom_snps_eusb2_hsphy_init(struct phy *p)
 	snps_eusb2_hsphy_write_mask(phy->base, QCOM_USB_PHY_HS_PHY_CTRL2,
 				    USB2_SUSPEND_N_SEL, 0);
 
+	snps_eusb2_hsphy_write_mask(phy->base, QCOM_USB_PHY_CFG0,
+				    CMN_CTRL_OVERRIDE_EN, 0);
+
 	return 0;
 }
 
-- 
2.39.5




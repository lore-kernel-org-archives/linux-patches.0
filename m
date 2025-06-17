Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F8B235071;
	Tue, 17 Jun 2025 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178627; cv=none; b=BgSabzaOrQbBx8d0YdSSiJmRG3VlmqHJl50PMtDcI0b3Dgq/TNM1me+SRMxqhWi28s3cu5A2ceCvTZBV6walGUCQtbhbXTXc0drxhsQVxl9A5J4SEvPfOKuzNqGjIHQ8h69LFDN+S2Ub2hV3wSJMfpWO8tBLRyl8ghreTzkjwfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178627; c=relaxed/simple;
	bh=aEZoANTy29/Is4dCxCLfSh3rUmCXc2hdur3PHeYhIOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+dp4tKYLgnW5Ed8cblznvC9M2+EQ7meUH+nrvu909kNpA965IGxL3SH5puQbzU5cMT7hpLVUSVjjC0ddgBXdkYu/igkVdenpXGpfK2dZ8KB1fZfIx7l+vVkcbxzGyoyKHFUiHTG4axeQNyn3L5l8b160bg06b8W7n1nOyDGTdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e41kr7+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e41kr7+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E59AC4CEE3;
	Tue, 17 Jun 2025 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178627;
	bh=aEZoANTy29/Is4dCxCLfSh3rUmCXc2hdur3PHeYhIOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e41kr7+BcIC4Ch83d6/CC81oUUX2sPueKHy7PAtoZXGsUvS3jD7rHXu3IxPK+B2sK
	 QUhxWagfKTEGD7Ea6ERuTY3FbAJNW+m3hkjl8fcEs3BS5+i/3AiAiG2Kiq8CVgNrrP
	 hneCWR7Ro9inFaXPbnt2F0p1y5IsVHIexDd6xNUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 504/780] phy: qcom-qusb2: reuse the IPQ6018 settings for IPQ5424
Date: Tue, 17 Jun 2025 17:23:32 +0200
Message-ID: <20250617152512.021254101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 25c36b54eafc98b3ef004e2037cea1328d9b8bc5 ]

With the settings used in the commit 9c56a1de296e ("phy: qcom-qusb2: add
QUSB2 support for IPQ5424"), compliance test cases especially
eye-diagram (Host High-speed Signal Quality) tests are failing.

Reuse the IPQ6018 settings for IPQ5424 as mentioned in the Hardware
Design Document which helps to meet all the complaince requirement test
cases.

Fixes: 9c56a1de296e ("phy: qcom-qusb2: add QUSB2 support for IPQ5424")
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250415-revert_hs_phy_settings-v3-2-3a8f86211b59@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qusb2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qusb2.c b/drivers/phy/qualcomm/phy-qcom-qusb2.c
index 81b9e9349c3eb..49c37c53b38e7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-qusb2.c
@@ -929,6 +929,9 @@ static const struct phy_ops qusb2_phy_gen_ops = {
 
 static const struct of_device_id qusb2_phy_of_match_table[] = {
 	{
+		.compatible	= "qcom,ipq5424-qusb2-phy",
+		.data		= &ipq6018_phy_cfg,
+	}, {
 		.compatible	= "qcom,ipq6018-qusb2-phy",
 		.data		= &ipq6018_phy_cfg,
 	}, {
-- 
2.39.5




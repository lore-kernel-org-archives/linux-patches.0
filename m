Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50111362;
	Tue,  3 Dec 2024 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241247; cv=none; b=MzO/9MQxQubQqA2yI4E3XL/e8aacUB6PR2Up+4Iz2JEu2PaaLI/tdcOvTv+ixIVMTMsFh/CkbmloT10bbUTgDm4mEFdjxXa92tpdgeU45Ba/iY5f8kAOrV0/MIEUkxtspacME6qI4tge9KSzLQPCibX/lxDTgZdCYWk82s4xUj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241247; c=relaxed/simple;
	bh=pMkwjLm+aKxBT6u55ZIuIDoeHCrvP5l8I6jep7P4J3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2Pan2YH7L5JnqYNdNmT9DWbb+su4YfpG2hATgxDCdaw5kJJR9rfWUVQWbinEmbevxNLdeUJnnPLz0CYic7dGCQru33QJoghDxfImiE9PLKOklWvRmAnR42p+5xMuu4x9cfPgxSXeLS4h4dYwBhJSq1M9vzGhgxiQkEOy6LMzRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbetGlHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbetGlHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E8BC4CECF;
	Tue,  3 Dec 2024 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241247;
	bh=pMkwjLm+aKxBT6u55ZIuIDoeHCrvP5l8I6jep7P4J3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbetGlHA4CI3OUP5oCJ4wJYKai4zAr0TSisj8IjrFISXU3dWUEAO7bEc1H54sm//z
	 zkUQMGZXtkpF9SUhoVeOCnvITB9kUH5lK1StcMtxATcvr1QA0+yZEyRHm/9iGUnxOP
	 GbGi//UGBZmkSZyCyk0sfRDzbHvKJOm2la1Jdm3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 366/826] clk: qcom: videocc-sm8550: depend on either gcc-sm8550 or gcc-sm8650
Date: Tue,  3 Dec 2024 15:41:33 +0100
Message-ID: <20241203144758.038589480@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit aab8d53711346d5569261aec9702b7579eecf1ab ]

This driver is compatible with both sm8550 and sm8650, fix the Kconfig
entry to reflect that.

Fixes: da1f361c887c ("clk: qcom: videocc-sm8550: Add SM8650 video clock controller")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241005144047.2226-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index a3e2a09e2105b..4444dafa4e3df 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -1230,11 +1230,11 @@ config SM_VIDEOCC_8350
 config SM_VIDEOCC_8550
 	tristate "SM8550 Video Clock Controller"
 	depends on ARM64 || COMPILE_TEST
-	select SM_GCC_8550
+	depends on SM_GCC_8550 || SM_GCC_8650
 	select QCOM_GDSC
 	help
 	  Support for the video clock controller on Qualcomm Technologies, Inc.
-	  SM8550 devices.
+	  SM8550 or SM8650 devices.
 	  Say Y if you want to support video devices and functionality such as
 	  video encode/decode.
 
-- 
2.43.0




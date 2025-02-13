Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3BE281375;
	Thu, 13 Feb 2025 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457342; cv=none; b=PZzR7dihdXkkC3LVQGtc5++Er2gVHy0ZHlWNxGIDjvHnkqrfl1PeQ3RyuIz/RE1W2cixoRKfcIqdo/wr3QGw+oUo2Q8tXbMgtwqKhazNlfYkYuOQk7wFOgq1XVRFBs0i5GH6K237n+l4c2/Cp1EJ+LoXr/EtF1MTG/XzX7d/fK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457342; c=relaxed/simple;
	bh=ksk3X8k6gmmOhfJWbaSXtRoedjr4x+1RUzd+QRw2OEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W39WiMDUCQkA89rh1KY2aEN8K+ToXKaXhJM/yQb1oWae+nyHa+qv8r5cLDSkukmVnDs6++mkBoLevXKsD3IoHE8Nwkexz95qY5tt1A6Jpb9D3QWYGODuvRmb/+Y0evW4/ZAxynbkhVb9zPASAiCcO4RxLAleuy9rkYfChMC4Ci4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/WclMJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/WclMJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727C9C4CED1;
	Thu, 13 Feb 2025 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457341;
	bh=ksk3X8k6gmmOhfJWbaSXtRoedjr4x+1RUzd+QRw2OEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/WclMJMPyUMoMNEjUNowrprorGqLTX7qQLm+h09xbcMgrhe3NWlZ6Nvk3Rh9yYD8
	 vNu2JM0RAJ+loF1xDCWYSRXjaGXfttVRQHlOKYsqLxs1KDejvTzzNedYyOSMFXtjSi
	 sS2k1ggfEB4TMWySrvPgxnGW025YZ9LhnW+fFeu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/422] clk: qcom: Make GCC_8150 depend on QCOM_GDSC
Date: Thu, 13 Feb 2025 15:23:25 +0100
Message-ID: <20250213142438.723605790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 1474149c4209943b37a2c01b82f07ba39465e5fe ]

Like all other non-ancient Qualcomm clock drivers, QCOM_GDSC is
required, as the GCC driver defines and instantiates a bunch of GDSCs.

Add the missing dependency.

Reported-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Closes: https://lore.kernel.org/linux-arm-msm/ab85f2ae-6c97-4fbb-a15b-31cc9e1f77fc@linaro.org/
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20241026-topic-8150gcc_kconfig-v1-1-3772013d8804@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 9ba675f229b14..16145f74bbc85 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -1022,6 +1022,7 @@ config SM_GCC_7150
 config SM_GCC_8150
 	tristate "SM8150 Global Clock Controller"
 	depends on ARM64 || COMPILE_TEST
+	select QCOM_GDSC
 	help
 	  Support for the global clock controller on SM8150 devices.
 	  Say Y if you want to use peripheral devices such as UART,
-- 
2.39.5




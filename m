Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4E22915
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647CDC433D2;
	Mon,  8 May 2023 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542487;
	bh=959LLQuJHBKPM9WzYb640TfBFilYrILejgFJUnaJ8kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lfa4PI31hnuggOvXxbvxHfz510piOeciulYr6kOwVkTaUPREjYpRRJtblDewv95ZA
	 qBuKcClftHy/8HwLCh8CbqL544R878ggT10S7McB9LIfADaGPt6mvZqV9aYb4KmAUy
	 jLx7yjrhh+I6d4p9udYB+arjC0T2bt3EbrejKCNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 450/663] interconnect: qcom: drop obsolete OSM_L3/EPSS defines
Date: Mon,  8 May 2023 11:44:36 +0200
Message-Id: <20230508094442.695475140@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 4c4161b4c81b632fc29002c324e996cbb79894e7 ]

Since Qualcomm platforms have switched to the separate OSM_L3/EPSS
driver, old related defines became unused. Drop them now.

Suggested-by: Bjorn Andersson <andersson@kernel.org>
Fixes: 4529992c9474 ("interconnect: qcom: osm-l3: Use platform-independent node ids")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230103045717.1079067-1-dmitry.baryshkov@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc7180.h  | 2 --
 drivers/interconnect/qcom/sc7280.h  | 2 --
 drivers/interconnect/qcom/sc8180x.h | 2 --
 drivers/interconnect/qcom/sdm845.h  | 2 --
 drivers/interconnect/qcom/sm8150.h  | 2 --
 drivers/interconnect/qcom/sm8250.h  | 2 --
 6 files changed, 12 deletions(-)

diff --git a/drivers/interconnect/qcom/sc7180.h b/drivers/interconnect/qcom/sc7180.h
index c6212a10c2f61..c2d8388bb8809 100644
--- a/drivers/interconnect/qcom/sc7180.h
+++ b/drivers/interconnect/qcom/sc7180.h
@@ -145,7 +145,5 @@
 #define SC7180_SLAVE_SERVICE_SNOC			134
 #define SC7180_SLAVE_QDSS_STM				135
 #define SC7180_SLAVE_TCU				136
-#define SC7180_MASTER_OSM_L3_APPS			137
-#define SC7180_SLAVE_OSM_L3				138
 
 #endif
diff --git a/drivers/interconnect/qcom/sc7280.h b/drivers/interconnect/qcom/sc7280.h
index 1fb9839b2c14b..175e400305c51 100644
--- a/drivers/interconnect/qcom/sc7280.h
+++ b/drivers/interconnect/qcom/sc7280.h
@@ -150,7 +150,5 @@
 #define SC7280_SLAVE_PCIE_1			139
 #define SC7280_SLAVE_QDSS_STM			140
 #define SC7280_SLAVE_TCU			141
-#define SC7280_MASTER_EPSS_L3_APPS		142
-#define SC7280_SLAVE_EPSS_L3			143
 
 #endif
diff --git a/drivers/interconnect/qcom/sc8180x.h b/drivers/interconnect/qcom/sc8180x.h
index 2eafd35543c78..ce32295af8f3a 100644
--- a/drivers/interconnect/qcom/sc8180x.h
+++ b/drivers/interconnect/qcom/sc8180x.h
@@ -168,8 +168,6 @@
 #define SC8180X_SLAVE_EBI_CH0_DISPLAY		158
 #define SC8180X_SLAVE_MNOC_SF_MEM_NOC_DISPLAY	159
 #define SC8180X_SLAVE_MNOC_HF_MEM_NOC_DISPLAY	160
-#define SC8180X_MASTER_OSM_L3_APPS		161
-#define SC8180X_SLAVE_OSM_L3			162
 
 #define SC8180X_MASTER_QUP_CORE_0		163
 #define SC8180X_MASTER_QUP_CORE_1		164
diff --git a/drivers/interconnect/qcom/sdm845.h b/drivers/interconnect/qcom/sdm845.h
index 776e9c2acb278..bc7e425ce9852 100644
--- a/drivers/interconnect/qcom/sdm845.h
+++ b/drivers/interconnect/qcom/sdm845.h
@@ -136,7 +136,5 @@
 #define SDM845_SLAVE_SERVICE_SNOC			128
 #define SDM845_SLAVE_QDSS_STM				129
 #define SDM845_SLAVE_TCU				130
-#define SDM845_MASTER_OSM_L3_APPS			131
-#define SDM845_SLAVE_OSM_L3				132
 
 #endif /* __DRIVERS_INTERCONNECT_QCOM_SDM845_H__ */
diff --git a/drivers/interconnect/qcom/sm8150.h b/drivers/interconnect/qcom/sm8150.h
index 97996f64d799c..3e01ac76ae1db 100644
--- a/drivers/interconnect/qcom/sm8150.h
+++ b/drivers/interconnect/qcom/sm8150.h
@@ -148,7 +148,5 @@
 #define SM8150_SLAVE_VSENSE_CTRL_CFG		137
 #define SM8150_SNOC_CNOC_MAS			138
 #define SM8150_SNOC_CNOC_SLV			139
-#define SM8150_MASTER_OSM_L3_APPS		140
-#define SM8150_SLAVE_OSM_L3			141
 
 #endif
diff --git a/drivers/interconnect/qcom/sm8250.h b/drivers/interconnect/qcom/sm8250.h
index b31fb431a20fc..7eb6c709c30d1 100644
--- a/drivers/interconnect/qcom/sm8250.h
+++ b/drivers/interconnect/qcom/sm8250.h
@@ -158,7 +158,5 @@
 #define SM8250_SLAVE_VSENSE_CTRL_CFG		147
 #define SM8250_SNOC_CNOC_MAS			148
 #define SM8250_SNOC_CNOC_SLV			149
-#define SM8250_MASTER_EPSS_L3_APPS		150
-#define SM8250_SLAVE_EPSS_L3			151
 
 #endif
-- 
2.39.2




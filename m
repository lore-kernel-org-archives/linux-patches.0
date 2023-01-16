Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C9A46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25DCC433EF;
	Mon, 16 Jan 2023 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885367;
	bh=ZnKi7p6tPj+I2fGNRPNJV5b1W4kPvyZaq8OLSFyqDnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2D3Tv0ajZe8jLrXN+RwBONECG006tqq3RmlQiC70lMOxRFgWv95x3HYjclxUH8lv
	 m1wD1a36fkWj1KufcFLG9nQu1iYrmu73IYRx/HhQ+8NK5hQRyWjdN+Kb4TO2d/DXFy
	 3BFAc7PogMmRG8QIORPMiA6CBsXVUTVHI5V8/ki0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Gautam <vivek.gautam@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/658] soc: qcom: Rename llcc-slice to llcc-qcom
Date: Mon, 16 Jan 2023 16:41:52 +0100
Message-Id: <20230116154910.739882443@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vivek Gautam <vivek.gautam@codeaurora.org>

[ Upstream commit a0e72a5ba48ae9c6449a32130d74506a854b79d2 ]

The cleaning up was done without changing the driver file name
to ensure a cleaner bisect. Change the file name now to facilitate
making the driver generic in subsequent patch.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: c882c899ead3 ("soc: qcom: llcc: make irq truly optional")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/Makefile                      | 2 +-
 drivers/soc/qcom/{llcc-slice.c => llcc-qcom.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/soc/qcom/{llcc-slice.c => llcc-qcom.c} (100%)

diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 28d45b2e87e8..2559fe948ce0 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -21,6 +21,6 @@ obj-$(CONFIG_QCOM_SMSM)	+= smsm.o
 obj-$(CONFIG_QCOM_SOCINFO)	+= socinfo.o
 obj-$(CONFIG_QCOM_WCNSS_CTRL) += wcnss_ctrl.o
 obj-$(CONFIG_QCOM_APR) += apr.o
-obj-$(CONFIG_QCOM_LLCC) += llcc-slice.o
+obj-$(CONFIG_QCOM_LLCC) += llcc-qcom.o
 obj-$(CONFIG_QCOM_RPMHPD) += rpmhpd.o
 obj-$(CONFIG_QCOM_RPMPD) += rpmpd.o
diff --git a/drivers/soc/qcom/llcc-slice.c b/drivers/soc/qcom/llcc-qcom.c
similarity index 100%
rename from drivers/soc/qcom/llcc-slice.c
rename to drivers/soc/qcom/llcc-qcom.c
-- 
2.35.1




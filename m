Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAA18820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150AFC433EF;
	Fri, 10 Mar 2023 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459729;
	bh=q32WouwlW/oQlXDtB9DVJNGGDT3wUatS07rS1fyIyk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCsiv6nWtQXm+rkrS45fJnv2CsKeyAgJwjjtxSGOSWgwJbpQ6Kf30HuBIKoIqE3o5
	 5JXANunMKXMTXj9V17ZJsZ+nc4wpxsttsCN/FDZZta15JOFkjrzfvM0edLcOWt/64J
	 zjWxw4bXwZab7zzE/71fc9KDBD5G2L7cIOZkpzAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/529] thermal/drivers/tsens: Add compat string for the qcom,msm8960
Date: Fri, 10 Mar 2023 14:33:46 +0100
Message-Id: <20230310133808.824434941@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit 2caf73969de6675318a711d0622406c8c66afc03 ]

On apq8064 (msm8960) platforms the tsens device is created manually by
the gcc driver. Prepare the tsens driver for the qcom,msm8960-tsens
device instantiated from the device tree.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220406002648.393486-3-dmitry.baryshkov@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Stable-dep-of: a7d3006be5ca ("thermal/drivers/tsens: Sort out msm8976 vs msm8956 data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index cb4f4b5224460..9e4a60db6e23b 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -902,6 +902,9 @@ static const struct of_device_id tsens_table[] = {
 	}, {
 		.compatible = "qcom,msm8939-tsens",
 		.data = &data_8939,
+	}, {
+		.compatible = "qcom,msm8960-tsens",
+		.data = &data_8960,
 	}, {
 		.compatible = "qcom,msm8974-tsens",
 		.data = &data_8974,
-- 
2.39.2




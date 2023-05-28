Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E65D611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E526C433EF;
	Sun, 28 May 2023 19:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303008;
	bh=eMteYxD8jdNy708V92ts+HhmtjGc3sqamFCberiMVow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjitB8Dkmrwp/z1DeNtRC38uUfSarNeiA+w98KugIpARpTFMQzPu9AFf5V6gYoftM
	 0DqAXnMqpCpnVpavoFC1BgTytldg9POw4iqSvm0DvPTe+XuryM1iPNwtqt6MTAZhWq
	 iK+F6DRma97LnmXC40f+8CY95NLsK5UYnhWkgkzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/211] drm/msm/dpu: Remove duplicate register defines from INTF
Date: Sun, 28 May 2023 20:10:11 +0100
Message-Id: <20230528190845.848164512@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 202c044203ac5860e3025169105368d99f9bc6a2 ]

The INTF_FRAME_LINE_COUNT_EN, INTF_FRAME_COUNT and INTF_LINE_COUNT
registers are already defined higher up, in the right place when sorted
numerically.

Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/534231/
Link: https://lore.kernel.org/r/20230411-dpu-intf-te-v4-8-27ce1a5ab5c6@somainline.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
index 108882bbd2b8b..7aa6accb74ad3 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
@@ -51,11 +51,6 @@
 #define   INTF_TPG_RGB_MAPPING          0x11C
 #define   INTF_PROG_FETCH_START         0x170
 #define   INTF_PROG_ROT_START           0x174
-
-#define   INTF_FRAME_LINE_COUNT_EN      0x0A8
-#define   INTF_FRAME_COUNT              0x0AC
-#define   INTF_LINE_COUNT               0x0B0
-
 #define   INTF_MUX                      0x25C
 
 static const struct dpu_intf_cfg *_intf_offset(enum dpu_intf intf,
-- 
2.39.2




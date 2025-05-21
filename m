Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313761514F6
	for <patches@lists.linux.dev>; Wed, 21 May 2025 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747790484; cv=none; b=K5J2ykHmQXV6AcFMwIC+TTXb03gt9bEUoNIB5U9+lilWTycF2z03p2Fc6NQCEud6p33OWBYyuAaB9/dS/nw1V3s5Uvgy2CJPbXvz4t7i5fvH+0ni5nFGJ+fte2+YoXucxmMZQhYaHHEtw4XVTNfoTgNaYtcGeI/pVDB2NrUjTsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747790484; c=relaxed/simple;
	bh=DQ/uhrXFki3GETA4re1GZrkES0oFIanWxCPcsts1edI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m4HYtrJ3YrcAvMzeIdhL9gYyxw283CLpEMk1XUNyHwlILDosZauLVcDT6HEU+5uvzx8N/YTOm9SahMpZgH3cNvtFf1DRTfXtuzrLKuj3qwpXwQ3LFgkRiXCqtT++Q5eXKJtxiBsk11i+HPrwpHIxuKB5ZpEzPdTKIkmIMmv005I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L0xhoa001909;
	Tue, 20 May 2025 18:21:15 -0700
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46rwfr8ku7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 20 May 2025 18:21:15 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Tue, 20 May 2025 18:20:57 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Tue, 20 May 2025 18:20:51 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <robdclark@gmail.com>,
        <quic_abhinavk@quicinc.com>, <dmitry.baryshkov@linaro.org>,
        <sean@poorly.run>, <airlied@gmail.com>, <daniel@ffwll.ch>,
        <sashal@kernel.org>, <quic_vpolimer@quicinc.com>,
        <quic_jesszhan@quicinc.com>, <linux-arm-msm@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <freedreno@lists.freedesktop.org>,
        <quic_kalyant@quicinc.com>
Subject: [PATCH 6.1.y v2 1/2] drm/msm/disp/dpu: use atomic enable/disable callbacks for encoder functions
Date: Wed, 21 May 2025 09:21:09 +0800
Message-ID: <20250521012109.1977775-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAxMSBTYWx0ZWRfX0uT5eiRX5P6c iJz/4lCRK0VGGuJNnqNP0zXIC1DSJrT4DQWxburqjVlp6v2CoghZbK2nr/x8jldete+7SkRukxs tPUOF9x30YPCqZlKno8rZ3XjyX3uYDuvMVx3ZuRy0U49Ao+uiCmdIODjHdxQRTlN+sb4/mJV6g2
 jipXqfZNAhnRli/HW41JnjRIRJTeHac2K5WJ2rADWssvjZ4gxwn84b8PP589n10sn7ZGDv80IcT DH3Q31AZg4hVWvaq6ZJP58DeKREK1nV7+jIsneaA5Y2FQ5/Xw91uEDw5Gud4Htue3d5gTi20Kxu Wbhcy/mF2Ag+0QCPyUdxYMjSVdB+GEq7AuN4HB8WGz8otTRIKhieQ7HMhEj5FF1jGljWFTcZi+w
 MmS0EqIm/D8FvUxhsb3b7U4JSjTDOkv5esa+Ypud0HMaTJeKlpx5naV8yLuk06AlWyjFF8P9
X-Proofpoint-ORIG-GUID: 7tabCjBKCtR5h2Ydfpj9PvwtODm_wyLo
X-Proofpoint-GUID: 7tabCjBKCtR5h2Ydfpj9PvwtODm_wyLo
X-Authority-Analysis: v=2.4 cv=TrPmhCXh c=1 sm=1 tr=0 ts=682d2a8b cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=dt9VzEwgFbYA:10 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=KKAkSRfTAAAA:8 a=t7CeM3EgAAAA:8
 a=txotuCt1tKXyWzYZ5sMA:9 a=Vxmtnl_E_bksehYqCbjh:22 a=TjNXssC_j7lpFel5tvFf:22 a=cvBusfyB2V15izCimMoJ:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2505160000
 definitions=main-2505210011

From: Vinod Polimera <quic_vpolimer@quicinc.com>

[ Upstream commit c0cd12a5d29fa36a8e2ebac7b8bec50c1a41fb57 ]

Use atomic variants for encoder callback functions such that
certain states like self-refresh can be accessed as part of
enable/disable sequence.

Signed-off-by: Kalyan Thota <quic_kalyant@quicinc.com>
Signed-off-by: Vinod Polimera <quic_vpolimer@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/524738/
Link: https://lore.kernel.org/r/1677774797-31063-12-git-send-email-quic_vpolimer@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 5f8345016ffe..c7fcd617b48c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1182,7 +1182,8 @@ void dpu_encoder_virt_runtime_resume(struct drm_encoder *drm_enc)
 	mutex_unlock(&dpu_enc->enc_lock);
 }
 
-static void dpu_encoder_virt_enable(struct drm_encoder *drm_enc)
+static void dpu_encoder_virt_atomic_enable(struct drm_encoder *drm_enc,
+					struct drm_atomic_state *state)
 {
 	struct dpu_encoder_virt *dpu_enc = NULL;
 	int ret = 0;
@@ -1218,7 +1219,8 @@ static void dpu_encoder_virt_enable(struct drm_encoder *drm_enc)
 	mutex_unlock(&dpu_enc->enc_lock);
 }
 
-static void dpu_encoder_virt_disable(struct drm_encoder *drm_enc)
+static void dpu_encoder_virt_atomic_disable(struct drm_encoder *drm_enc,
+					struct drm_atomic_state *state)
 {
 	struct dpu_encoder_virt *dpu_enc = NULL;
 	int i = 0;
@@ -2407,8 +2409,8 @@ static void dpu_encoder_frame_done_timeout(struct timer_list *t)
 
 static const struct drm_encoder_helper_funcs dpu_encoder_helper_funcs = {
 	.atomic_mode_set = dpu_encoder_virt_atomic_mode_set,
-	.disable = dpu_encoder_virt_disable,
-	.enable = dpu_encoder_virt_enable,
+	.atomic_disable = dpu_encoder_virt_atomic_disable,
+	.atomic_enable = dpu_encoder_virt_atomic_enable,
 	.atomic_check = dpu_encoder_virt_atomic_check,
 };
 
-- 
2.34.1


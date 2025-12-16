Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85C7350A38;
	Tue, 16 Dec 2025 12:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887228; cv=none; b=tQS91AX2g2wAoCBwBLtQHzwl7AZmOmKjY7UTuA+CCbUxMjlne7pP1iHPNoTU0d/3myTzOINMzlyzilmUGlAlfmHBbnwAucMbr3hLNGZi5/Ekl1PfcpFlFKRgM+pZHGfFM0+lLhnVTv7h2v4mPOUwVprKHFTI7K+xh6Sfmcc57EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887228; c=relaxed/simple;
	bh=zJdqszvSVwcx+ItQ8N5r2Yjp3KqXJWbnxOWk2D0nuDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5t5mWH7M0wEsAD5CTa1xg7bnsOvSZJ1ZvXx+Z9M8nEb6nK+BC1OtCBIcutfUwkx7KtVBKWh7txltrEI7gkEWB6/JNbg4o7wZIDr9LZxBtRHRgylxICswlkzuRS4eC/1hct6h0rwzIrtiUMy1WxVl+dkTyaQQahOJ+n1IIG8g8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3dsOgTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3dsOgTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F8C4CEF1;
	Tue, 16 Dec 2025 12:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887227;
	bh=zJdqszvSVwcx+ItQ8N5r2Yjp3KqXJWbnxOWk2D0nuDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3dsOgTKDg8l5/0FqaYcdS2q1seyqEb8c5gExmCyB3I/hJLbNwpMgRIxXyHe7CYBK
	 n1P6wK2EUW/AgZaP1KP1ybUHjK2vaZe6mHIBTK8QLNaNWUsqJs42+W9SdO6PFWWfvT
	 4KX1NY+HtaYwG0NOQZhYPrFEp1MIG5cA5m0PVRds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/614] interconnect: qcom: msm8996: add missing link to SLAVE_USB_HS
Date: Tue, 16 Dec 2025 12:08:52 +0100
Message-ID: <20251216111407.313720936@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 8cf9b43f6b4d90e19a9341edefdd46842d4adb55 ]

>From the initial submission the interconnect driver missed the link from
SNOC_PNOC to the USB 2 configuration space. Add missing link in order to
let the platform configure and utilize this path.

Fixes: 7add937f5222 ("interconnect: qcom: Add MSM8996 interconnect provider driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251002-fix-msm8996-icc-v1-1-a36a05d1f869@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/msm8996.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/msm8996.c b/drivers/interconnect/qcom/msm8996.c
index b73566c9b21f9..84cfafb22aa17 100644
--- a/drivers/interconnect/qcom/msm8996.c
+++ b/drivers/interconnect/qcom/msm8996.c
@@ -552,6 +552,7 @@ static struct qcom_icc_node mas_venus_vmem = {
 static const u16 mas_snoc_pnoc_links[] = {
 	MSM8996_SLAVE_BLSP_1,
 	MSM8996_SLAVE_BLSP_2,
+	MSM8996_SLAVE_USB_HS,
 	MSM8996_SLAVE_SDCC_1,
 	MSM8996_SLAVE_SDCC_2,
 	MSM8996_SLAVE_SDCC_4,
-- 
2.51.0




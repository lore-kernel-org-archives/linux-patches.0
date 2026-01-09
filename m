Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B2222F77B;
	Fri,  9 Jan 2026 11:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959612; cv=none; b=cUcUrHZ3ctGViksCRKf/N/9FNlDeE5QPhQ4KfXnsP+la60LD9vobIGLXTCSm4VNeAqzM641BTDEv14acNxv6xzuxmKjjXJorSgIXAuKQ2d4ifye9SVbMqwQbAyp9O7F2mwmjnZ300t2ygR7H7fTep9YrBoI0u0wWFT3RTWYRcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959612; c=relaxed/simple;
	bh=kehUzPxIDzcYMGMhQuDmPjdPZUE7vQI4PfarQeG+Cz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGeRJFh0D/J2cmlcU+zkVvo2z/h4l7G3YV0QRYPeRwnhpMjwKZ8/PnJxTqys4JmqW+b7Opv8yupKIAVOy+3wxN6NbCUcPNCeM6YCF4HBUgwfCA9nwMnxV/cl10bmTYU8ABXKXF87rDk1PrHvhotCxm9J4wUSQ/4OTp1E5XKpKvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuSwgXJ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuSwgXJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43824C4CEF1;
	Fri,  9 Jan 2026 11:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959612;
	bh=kehUzPxIDzcYMGMhQuDmPjdPZUE7vQI4PfarQeG+Cz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuSwgXJ56/vIPu4fzfPv2tw9F2mDMyMlWOGe9EuW5NxpK6evzybQCmkiu96LD2rRU
	 IQvqC0BrTC0+UM+JsqzbdcEXwexvSUohheZ2qpjTOXv8f85pGVJujJsw2NquYZRDPu
	 aXdOMccICFh2/ISbOaFXezLGP9R3NCF4K4R8o8Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/737] interconnect: qcom: msm8996: add missing link to SLAVE_USB_HS
Date: Fri,  9 Jan 2026 12:34:05 +0100
Message-ID: <20260109112137.989857717@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 88683dfa468f6..84811fe32782f 100644
--- a/drivers/interconnect/qcom/msm8996.c
+++ b/drivers/interconnect/qcom/msm8996.c
@@ -550,6 +550,7 @@ static struct qcom_icc_node mas_venus_vmem = {
 static const u16 mas_snoc_pnoc_links[] = {
 	MSM8996_SLAVE_BLSP_1,
 	MSM8996_SLAVE_BLSP_2,
+	MSM8996_SLAVE_USB_HS,
 	MSM8996_SLAVE_SDCC_1,
 	MSM8996_SLAVE_SDCC_2,
 	MSM8996_SLAVE_SDCC_4,
-- 
2.51.0




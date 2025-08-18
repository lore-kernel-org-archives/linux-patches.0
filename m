Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0060D310640;
	Mon, 18 Aug 2025 12:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521727; cv=none; b=CzRtqKfTuk5BvMJPDzYsIYtfAm2hxNdshrzH3R72rsbeGX3RoF+JK5szsf5ZcEkmrD23b5+YvzcaiJVrinqEOT3OnHdOJ/0H/TsOFvturUlNUTwBi9eNBMjd9zFcKj0jpFilBaxTMAH6rhlA0Ea5hGx3SBQesJsoPMcBSjewz60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521727; c=relaxed/simple;
	bh=A5GcRvSQIZn+344FMYLZlGCQOg5yPwlfsbJONMMAszw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZBzgj7Si7gPhRFc7H1an9Rd+Fr30ljmhxfgdOkus4KTNwVn8zrizzuE5R46b+tc9fIGpjX5wqZTCrq7LVDLEH9R7FSPWd0Z1V7xdAvbGvorUiCc4Z/cuvLQuDBCnFF5NZwVDxIuccXg+DeC/VlnffOYZGMQqHHvUIOX2cDGo5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Htf/EgM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Htf/EgM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186DDC4CEEB;
	Mon, 18 Aug 2025 12:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521726;
	bh=A5GcRvSQIZn+344FMYLZlGCQOg5yPwlfsbJONMMAszw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Htf/EgM71t/+THrI4Ii/x5oqDp04hY1WqUkwDxLM68GZqj/cVvT6lHyfq794z4l+H
	 K5Ktth71Z9ykTJUSE/HCBW2pBwYdDaKCBf3+erAYenIvE5XODaVuLCFVLpf9SE+NCl
	 spHxw8pRaSWiQLk2reF6yEBf9ZK3x+yLpy7DX1Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/444] soc: qcom: rpmh-rsc: Add RSC version 4 support
Date: Mon, 18 Aug 2025 14:42:10 +0200
Message-ID: <20250818124452.840138073@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Maulik Shah <maulik.shah@oss.qualcomm.com>

[ Upstream commit 84684c57c9cd47b86c883a7170dd68222d97ef13 ]

Register offsets for v3 and v4 versions are backward compatible. Assign v3
offsets for v4 and all higher versions to avoid end up using v2 offsets.

Signed-off-by: Maulik Shah <maulik.shah@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250623-rsc_v4-v1-1-275b27bc5e3c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index de86009ecd91..641f29a98cbd 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -1075,7 +1075,7 @@ static int rpmh_rsc_probe(struct platform_device *pdev)
 	drv->ver.minor = rsc_id & (MINOR_VER_MASK << MINOR_VER_SHIFT);
 	drv->ver.minor >>= MINOR_VER_SHIFT;
 
-	if (drv->ver.major == 3)
+	if (drv->ver.major >= 3)
 		drv->regs = rpmh_rsc_reg_offset_ver_3_0;
 	else
 		drv->regs = rpmh_rsc_reg_offset_ver_2_7;
-- 
2.39.5




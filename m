Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6388331B13A;
	Mon, 18 Aug 2025 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523283; cv=none; b=Fa0uqdytcng1UmZXGFWl/mzpZM6nJkmexotoWj1dqSKhWPZuCq+8JZQpx64TvF1Dm63g1P6RDEF1UsTYZeq25s9CyCwL2jQYlpyVzMhGibzfBKAxht4ydYHPfj/+kfrvjyFnlzPO16YqGntDzrIuY3mBV9ytgOKnyJi8I0FmRB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523283; c=relaxed/simple;
	bh=N4fmo9/fOg9Gmbm860xTuSDfDx+jPfNszRFlTWVzuzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCk2Ukr0vMV+0xN4YJvCbO/yjKSUfZt4kUMNpYizIf9hkW/+TB6vxyjtUWQE3kp8n3/Y7JStHsSNnINqMIyFbE5+SHRaleeHs9SK60pxnFVSYcsT3W/H1xpu3rFlEq3/0lWvx5MqbKGA3/UjzpVNl+LpERTD3d3qgATadC6NmJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gq4YrxCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gq4YrxCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAB4C4CEF1;
	Mon, 18 Aug 2025 13:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523283;
	bh=N4fmo9/fOg9Gmbm860xTuSDfDx+jPfNszRFlTWVzuzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gq4YrxCm1ZSKA9ctqRrq5pFToarVVFcv+RWRIx95RiHh2bCoZU20tpzTIlq23FdL+
	 HnDy/njb9TzhpUuA106/gc/ouOwZjgvOiOpFklDMBKxgumLGhFUYhh42+sM4/suoDn
	 EfU+Jr/qWPsxtdj8DznsW7BH/lmNZfCAChJnJW1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maulik Shah <maulik.shah@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 124/515] soc: qcom: rpmh-rsc: Add RSC version 4 support
Date: Mon, 18 Aug 2025 14:41:50 +0200
Message-ID: <20250818124503.138884452@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index cb82e887b51d..fdab2b1067db 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -1072,7 +1072,7 @@ static int rpmh_rsc_probe(struct platform_device *pdev)
 	drv->ver.minor = rsc_id & (MINOR_VER_MASK << MINOR_VER_SHIFT);
 	drv->ver.minor >>= MINOR_VER_SHIFT;
 
-	if (drv->ver.major == 3)
+	if (drv->ver.major >= 3)
 		drv->regs = rpmh_rsc_reg_offset_ver_3_0;
 	else
 		drv->regs = rpmh_rsc_reg_offset_ver_2_7;
-- 
2.39.5




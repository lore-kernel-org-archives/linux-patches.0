Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3CC3446B1;
	Tue, 16 Dec 2025 12:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886900; cv=none; b=ZT9pstND3pPG1rItH9nOT34LU8y4bX3ToQuc7y8RElhyLRebdiboT4KGj9W1mDF+VlykRtm5gHe26xfKpAsurwIAI1l1BgSUhnNCacolDUAPGqRZjuR3LsncnS3jzqrzOuOhPyvruIs6ZKeCMIg5bmd8po7I3qDxVGs6jpYV0ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886900; c=relaxed/simple;
	bh=Pm+QvV5WIkoIC9a8ok+XcDPQ+83S/WQLGWzL3LlvF7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEBRobRy/nOv8PVi3HtCcHhoTRmLp4q0M+O0/xzZirRPpQIOoqwFL26FauKgfHQSlkFfXUDIhEoeJXDbLUoMafGnr9kTbcjj2ickvntwweNhws11i0ANFnoQXmVEDIZ2YtiXey88cAzDXTmt6piZkBym94ydXrMn9KoFdG7IHDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=071c8kXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="071c8kXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC74C19424;
	Tue, 16 Dec 2025 12:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886899;
	bh=Pm+QvV5WIkoIC9a8ok+XcDPQ+83S/WQLGWzL3LlvF7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=071c8kXjajln6Wwv8J2/9MogTvqdquhGaOcksgleNhs2koo4HdnD1IL5i4q6dCRkT
	 XRcqhcXjT4J8V69xAZYFM0QEjH8gU0pvFh1ZAlZfPcVxwr5nXCbMXLGmBLIoL51RkV
	 HPR4LGh0cgFXlKZd2bGj1XY5jujogow6IralxBHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/614] pinctrl: qcom: glymur: Drop unnecessary platform data from match table
Date: Tue, 16 Dec 2025 12:06:31 +0100
Message-ID: <20251216111402.180446744@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 37e7b536061a33c8f27030e3ffc5a717a6c319e3 ]

The platform specific configuration is already passed on to the generic
msm probe. So it's useless to exist in the match table next to the
compatible. So drop it from match table.

Fixes: 87ebcd8baebf ("pinctrl: qcom: Add glymur pinctrl driver")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-glymur.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-glymur.c b/drivers/pinctrl/qcom/pinctrl-glymur.c
index 9913f98e95311..9781e7fcb3a11 100644
--- a/drivers/pinctrl/qcom/pinctrl-glymur.c
+++ b/drivers/pinctrl/qcom/pinctrl-glymur.c
@@ -1743,7 +1743,7 @@ static const struct msm_pinctrl_soc_data glymur_tlmm = {
 };
 
 static const struct of_device_id glymur_tlmm_of_match[] = {
-	{ .compatible = "qcom,glymur-tlmm", .data = &glymur_tlmm },
+	{ .compatible = "qcom,glymur-tlmm", },
 	{ }
 };
 
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFF722333E;
	Thu, 12 Dec 2024 16:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021150; cv=none; b=aCt8jkJBSxCeo5nfZz+sC6L6Cx7JLX3AaDCgpKQxxY2TidOBZe3mqLuxqnWzV0O2WwCd7mBPbJ2dGgmUd7/XR6KpM3tEgtnzFMDNmY38WVC//6cNJoWaWeXglr7nVa/Qk9nHJXYHthQDvr1C1u80t1kXSvepAo1HtVCq3f9qslI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021150; c=relaxed/simple;
	bh=79NnoUeh9OBmXuBaGNsYHubYBPhedgFx0sBbM/N3qXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4Wf/zEUueiqJjmihv/4FDU2R+G+s8sRX84CfcwH+r0WwCIHkes7ISxxtHBrCBoX81buoINaCc8bMpc9tGknxb48TPmBme644g2txIuWTalvDrYrAeVfFiAwouD02QicynmMDstWfy8deqfRIKHbRorVwifMFW8A/Df5CE+ou3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5cYnv49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5cYnv49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551ABC4CED3;
	Thu, 12 Dec 2024 16:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021150;
	bh=79NnoUeh9OBmXuBaGNsYHubYBPhedgFx0sBbM/N3qXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5cYnv49g/KFQ7BBRLKZFR8bGJ3eNRNGtm/yPmH3ftUBJzi4mz0Jy/FWet+hq//ot
	 GyLy0lu5vzewVHPk+y3ByGjhJhg3GmX3Zxi+5ryMhK3HjulEehePZFq2L9Iif4A3+y
	 TMIJW/ORUMyNqhE6nqy0+V/oid8AY+P1iBQHS7kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 659/772] drm/mcde: Enable module autoloading
Date: Thu, 12 Dec 2024 16:00:04 +0100
Message-ID: <20241212144417.152875100@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 8a16b5cdae26207ff4c22834559384ad3d7bc970 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240902113320.903147-4-liaochen4@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mcde/mcde_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mcde/mcde_drv.c b/drivers/gpu/drm/mcde/mcde_drv.c
index 1c4482ad507d9..78bdfd855d11b 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -468,6 +468,7 @@ static const struct of_device_id mcde_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mcde_of_match);
 
 static struct platform_driver mcde_driver = {
 	.driver = {
-- 
2.43.0




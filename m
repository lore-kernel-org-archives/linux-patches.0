Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD942153EC;
	Thu, 12 Dec 2024 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024711; cv=none; b=q+RxDsJe00pxr5kvT0MLfzAk11lkPI7F7mdalLCKLCBtyJtcB1ytMeFpF6iiGRKM8I+omtlFTuDnKaXlR/THs7oLJdxbeR7TFtCzXPrYKQryGPSI6ZtoLVKZn3M3K3hTkrHssSOmvWwNg8FAMKFoxWdLbVhUVl4dBchFUnUSwo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024711; c=relaxed/simple;
	bh=Bd7qrqqR4+i2r6fBnEnunWEjWUj6xaK8PcmMlZJgijI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hg2VVWrnetTHDA4mAgamOD0rM1vGk7HT8DBk4uc3xPB68+/J1p/0giC0UB3Z2oa8P7ddMyUYNNSYsGzfCNVksrKakK8mgeN/31fENzQZ5Yd+NHYKXBEyyLoCqaX/QcwFJSqkpslWKZMSvjiqG9sKv9pPGpNsrNEdxMK9Q6U82EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqfg/AOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqfg/AOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F351C4CECE;
	Thu, 12 Dec 2024 17:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024711;
	bh=Bd7qrqqR4+i2r6fBnEnunWEjWUj6xaK8PcmMlZJgijI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqfg/AOh59xGXmRoNwvOkOxRsC0bkm7clv2u3Ep/ccnbApzbbE/ZcgiJ0AJ6Iryjs
	 FIOkDUApsjYYHmOjnKf/qJQp8dwXCdp8Qmdio2UwC5Z+LtnJ+tJpUdkTBk4MjpCHCV
	 stLptl+0lEwMJMVb7afKL0OXY4t0Q7oQlsa6i/vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/459] drm/mcde: Enable module autoloading
Date: Thu, 12 Dec 2024 16:02:05 +0100
Message-ID: <20241212144309.057708674@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 210f5e1630081..eb1c87fe65e6c 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -453,6 +453,7 @@ static const struct of_device_id mcde_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mcde_of_match);
 
 static struct platform_driver mcde_driver = {
 	.driver = {
-- 
2.43.0




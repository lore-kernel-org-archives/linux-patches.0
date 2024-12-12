Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA952080FC;
	Thu, 12 Dec 2024 15:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016780; cv=none; b=jPKwBK3qeg2UeD7W1wQygIJEOU5850ywGjiXF3ch6pvAG5G/anRCkY1HfHDCQJjQIWVG7U6dU3h0Vvy+tP/mw4hBYPsf5FFg1qicCjFOuXtG5flIpd5ut6L+dl96jOR72F7IdDzYT/cgzh18ru1q4l6jaummMRMZtbYvo10pNQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016780; c=relaxed/simple;
	bh=PrS9UxlefrobjjbV5/lOpia4IFSFRbh6oi2JfoCCD0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSoJitjSknhg2nJxgjo8xBWPdBvhRWoVuLT0G6ifXM0aod/FTLUKvI9DVzUFErYzrAw7oDwuHcSqWLVqwxc90o9Kf4GgRKoaJakinuq035gd93evhUJ3vEcPULtx50jl2Kl+NBZomAZg4GnnWNZb+ecoTC/vKO2jleiNE7GcvkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oH7JFrLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oH7JFrLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839A5C4CECE;
	Thu, 12 Dec 2024 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016780;
	bh=PrS9UxlefrobjjbV5/lOpia4IFSFRbh6oi2JfoCCD0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oH7JFrLAU3xG/uVja9euALcc6JOAig8bstY52RTZMwaMOnx5DCXi8FIQlwqj3K5r+
	 E1bY/pWKLz0qCxj12iSWHUiLdNq152pWvSwpo9Pt3UxC7WPyMT2bSXeLq8+NbJwm0E
	 S7k1OjutOjFA7jIZJc8tad7BioUsO1SThUfGivCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/466] drm/mcde: Enable module autoloading
Date: Thu, 12 Dec 2024 15:57:13 +0100
Message-ID: <20241212144317.227290344@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 10c06440c7e73..f1bb38f4e6734 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -473,6 +473,7 @@ static const struct of_device_id mcde_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mcde_of_match);
 
 static struct platform_driver mcde_driver = {
 	.driver = {
-- 
2.43.0




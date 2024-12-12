Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DFD22331E;
	Thu, 12 Dec 2024 17:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023393; cv=none; b=DFpV4dSFqHSxcvkwn7u0ILoppAehOzAHyOceDjYqWejevfccQnEdukcbnH9e2eTX/Fxp86sTj2YvnhobB8uKiLhW7zoMMFFX6z2ecapOzH6ubxk/p+2eTHaNwpVpgZm5NRrWpl7wWrjVdYOz6vw9RfujVFcKNxbOfmGIi7qXC4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023393; c=relaxed/simple;
	bh=4V3Z8Dnmm90z1oLmBnQp0wRAqZuut6R1frrUczq5Al8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKIyDGkVsbz6ke+gAEFlxgS8In6s+aciiGx1SoNyMmqkDNM9tQoCpu1Sb3qbCu9Gxh2Sgv31J7JIDU23q/091mfX6cNgQXn3zfElhkAV0K35Dju+gojEn2yxZ98d7rS38VkbG/Heetk+wy8qAa4tWFp4Xgwu4OeVmHPILSZJb3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2tcKpzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2tcKpzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66D9C4CECE;
	Thu, 12 Dec 2024 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023393;
	bh=4V3Z8Dnmm90z1oLmBnQp0wRAqZuut6R1frrUczq5Al8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2tcKpzhXcMWEPWF/C3PEq71/bbT+jfqgVUuoUOlMw1vYriq6OGJVj72cgauWj2am
	 V5V3eORo4lKYYREn/JI3frB5qrchY3clLKMA0vjl1jc+x+MivpKU9rqtGHdbYhHfQX
	 Lgvr3Vp16kanQbxJC4zGtnAEX7LP5mEQ2XXkI/d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/565] drm/mcde: Enable module autoloading
Date: Thu, 12 Dec 2024 16:01:14 +0100
Message-ID: <20241212144330.688185359@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e60566a5739c7..be14d7961f2e4 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -475,6 +475,7 @@ static const struct of_device_id mcde_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mcde_of_match);
 
 static struct platform_driver mcde_driver = {
 	.driver = {
-- 
2.43.0




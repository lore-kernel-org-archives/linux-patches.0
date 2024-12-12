Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B5322370C;
	Thu, 12 Dec 2024 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025731; cv=none; b=N3Lh/kklwlPaIyDSatho0Hnenezr7fmzVpRClJRTmhQCuu/H3mTrRDltOVP35IcrCTsd/cMZMHPjVSjdj6ilWzzYbT4+2waZANu/lbQJOAJnjnlic/102paBnnTH1mV52NJnUeK6E/UWa98BEy5KGpF4IApowgnLvSpgbihFue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025731; c=relaxed/simple;
	bh=hOgcKfnlPRp9g6TolWArQCmxY3HEfV+fhLSUqAsrh+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqJ71ZiSr5DG2RpEZPuXBBOXANaU7cdL9BhXKhmTU/9Wnb8w5ZMRepvklFiCBkbzUtBwd9ZpIcTqyl/HhsA2E3PaKSZK64yDM/0rmAawvi8iB+KFyohqsfKYUqHSaHbIxYA5liFyBR7fj3mrAMWkAE/xGi7OptHGh3YHdIB/U7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ir8ceXxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ir8ceXxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDE2C4CECE;
	Thu, 12 Dec 2024 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025731;
	bh=hOgcKfnlPRp9g6TolWArQCmxY3HEfV+fhLSUqAsrh+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ir8ceXxvgrE1f1MMMaHDmNHIf1ab5fl7xyFmJgc0iygUP8u+KpkDIDFnv3J41/a8g
	 mgj5Fnghbv23uuhRZOBIi+UiyhXfnas2t1P+ByNnb1ls0tVZ+f+v1ARnKk3l6Hv8dX
	 hOXpFT8II3gl9jn5j205FDN5TfrFcdslU+FHvYKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 268/321] drm/mcde: Enable module autoloading
Date: Thu, 12 Dec 2024 16:03:06 +0100
Message-ID: <20241212144240.566663789@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 82946ffcb6d21..9a767fbb86c95 100644
--- a/drivers/gpu/drm/mcde/mcde_drv.c
+++ b/drivers/gpu/drm/mcde/mcde_drv.c
@@ -533,6 +533,7 @@ static const struct of_device_id mcde_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mcde_of_match);
 
 static struct platform_driver mcde_driver = {
 	.driver = {
-- 
2.43.0




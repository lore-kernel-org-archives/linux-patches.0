Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483243563DD;
	Tue,  6 Jan 2026 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722579; cv=none; b=onGBWaBqsVwXu4pm4S+HKMZ9jO9aBP5M6HrLQqz0Y6DrMHS41/kM7Vch8nC28hORjrkaX6oR6ahVF9s5Dtcd5ewmNKTQiEEut+vlncQ9TUyzNMXTIuo4Ce7XCKzik2I/fijxinBbHiEU5UhkUJJSE24XdmKevkHF7JjY2xf0mHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722579; c=relaxed/simple;
	bh=fpEusjWtGtlqVLOho9mVh/KYcwBOStHlIEKSGCmJVbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqDzw8vW4uo3K15qFkRk9IHHiefXMLWRobVEUZXpXjgrindFukHNS9NMZ8k5L9Kl3vV5dHycN05wu/IRxH3QVATmmzeTE7vh59Jry3/hBMiWxoGaoN3zSSMZTRxIVu/agfECy51h8uY8T0IyE7LQft6OHdD56mXXvOPiFba7bcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM6dDaRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM6dDaRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC84C116C6;
	Tue,  6 Jan 2026 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722579;
	bh=fpEusjWtGtlqVLOho9mVh/KYcwBOStHlIEKSGCmJVbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM6dDaREzTRGig9jJKHNwg5dept+hVpA0/G/HlomAdaqKpU6A0ukPT6ONmlUYfHyK
	 GToqBdMAY4lMmE0a+6+VD/IWkCb3SYiP3H8FQ+zAXZfzyM0G6eRBpEHTOI2N747v1H
	 dIWcwjCfEMrJ2BSIlpOV7wMcKwg9Ac2yycR7Pyrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Stone <daniels@collabora.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 273/312] drm/rockchip: Set VOP for the DRM DMA device
Date: Tue,  6 Jan 2026 18:05:47 +0100
Message-ID: <20260106170557.723661730@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 7d7bb790aced3b1b8550b74e02fdfc001d044bee upstream.

Use VOP for DMA operations performed by DRM core. Rockchip DRM driver
is backed by a virtual device that isn't IOMMU-capable, while VOP is the
actual display controller device backed by IOMMU. Fixes "swiotlb buffer
is full" warning messages originated from GEM prime code paths.

Note, that backporting is non-trivial as this depends on
commit 143ec8d3f9396 ("drm/prime: Support dedicated DMA device for dma-buf
imports"), which landed in v6.16 and commit 421be3ee36a4 ("drm/rockchip:
Refactor IOMMU initialisation"), which landed in v5.19.

Reported-by: Daniel Stone <daniels@collabora.com>
Fixes: 2048e3286f34 ("drm: rockchip: Add basic drm driver")
Cc: stable@vger.kernel.org # v6.16+
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Tested-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20251022161948.199731-1-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_drv.c
@@ -96,6 +96,9 @@ void rockchip_drm_dma_init_device(struct
 		private->iommu_dev = ERR_PTR(-ENODEV);
 	else if (!private->iommu_dev)
 		private->iommu_dev = dev;
+
+	if (!IS_ERR(private->iommu_dev))
+		drm_dev_set_dma_dev(drm_dev, private->iommu_dev);
 }
 
 static int rockchip_drm_init_iommu(struct drm_device *drm_dev)



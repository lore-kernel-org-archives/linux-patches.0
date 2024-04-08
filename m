Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2597D417;
	Mon,  8 Apr 2024 13:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581917; cv=none; b=kchftN/kCbFDcuF+F57viQOVTqhKs4kTr80aIURKFYKaYj6KnXYBRCSYi4+b9hv10dezPkGVmQRpEQYyxTmuEu8tHs8nkERuOk3jiiU+PNsewRPejZBTQM4KXMH/aMyLPiU/5lXq8JEW3yUqp+zqMjtwkLO37CSAlPApmV55knQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581917; c=relaxed/simple;
	bh=hNJpPvtYDFACIqVA0e0ziCVUGh3TgdEBImGOWw8/1so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouUaSQ7/rf9usNLnrxK/7QZn8mcNv/rNa1fLr1NG3rgtXbi4LIrjQC169SWoG1AIg/pmNkHrx7Swq0A5lg+FAPuo9doa6rdF8F936Az2VA/9Uf1NkHDGpvF0noChln+DzdLV+ix6/r5LBQk37iIMLT4vCuHsOXQ8vrLnwMdnlnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSGaCUzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSGaCUzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1E2C433C7;
	Mon,  8 Apr 2024 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581916;
	bh=hNJpPvtYDFACIqVA0e0ziCVUGh3TgdEBImGOWw8/1so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSGaCUzCeE1ttjzI+zldhrIpnGakIdpcwSkWedjHEx/qb4mgk6oLnROPc0BLRkeVE
	 hMIOmXqZym83P//vl/NUjoairqly9tuR0/B+VqC2HY3Gd1+poNKFVPnVtMiaPzD6K1
	 Xg20sudzYS1cZ+6nSMVRbgGBIAWflWjRlVO6/hXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 030/273] drm/rockchip: vop2: Remove AR30 and AB30 format support
Date: Mon,  8 Apr 2024 14:55:05 +0200
Message-ID: <20240408125310.224732679@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 905f7d53a1bc105b22d9ffd03dc11b6b42ec6ba6 ]

The Alpha blending for 30 bit RGB/BGR are not
functioning properly for rk3568/rk3588, so remove
it from the format list.

Fixes: bfd8a5c228fa ("drm/rockchip: vop2: Add more supported 10bit formats")
Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240304100952.3592984-1-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_vop2_reg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
index 48170694ac6b8..18efb3fe1c000 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop2_reg.c
@@ -17,9 +17,7 @@
 
 static const uint32_t formats_cluster[] = {
 	DRM_FORMAT_XRGB2101010,
-	DRM_FORMAT_ARGB2101010,
 	DRM_FORMAT_XBGR2101010,
-	DRM_FORMAT_ABGR2101010,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_ARGB8888,
 	DRM_FORMAT_XBGR8888,
-- 
2.43.0




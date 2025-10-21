Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA85350A3C;
	Tue, 21 Oct 2025 20:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076930; cv=none; b=f7Uekk2x22cG21kT3g8qmcCvhye6W4YKknpTesUk+TYrYoxqoJ2qfRIp9mMZ1Dt3v/bZgbSxTy6KVY3c85jrG7ZSD/N4JeBf0vxoGRPA957/PfehDR/sczgAPiC4vD6jqvoFVMBiYIq5ProVM9s36Wi/tfvAAQRo7ukpico6Tno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076930; c=relaxed/simple;
	bh=TrvWM8qTvKS46o2MBefGmlrdrPERCJPDCuF+tW1XSY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOPVRWPohj2s7iF406VB06MEiy6kOs8RxK5T/ohHWH4/curZPtL3sXRBYt49HrfpkRdfx6e1Re1DUjMYrVFyb5vL8myfgt0CZ6wGgFQqBPSKnGcWLCL0ozkkCmeYQ9lehno96SU5FZLx1Ov6pDA2zuGjyKlDgnxarWDNRDLYcOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvW2+DNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvW2+DNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6F1C4CEF1;
	Tue, 21 Oct 2025 20:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076930;
	bh=TrvWM8qTvKS46o2MBefGmlrdrPERCJPDCuF+tW1XSY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zvW2+DNLtseU17mOfyAMJrYAkvFuNfkDIyDzihJx6kKROJaj6/G6R7W4wocXsWOvO
	 6sIocKJzRKwoht9mbPoDYbpyWtgwsZcOJUSCuKV9c1QnxPyBfPB36KBW5XP54wxbar
	 lOtLsAPS4olt/cEO42QCdpDU+TKUXcwgnS1h6j00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/136] drm/rockchip: vop2: use correct destination rectangle height check
Date: Tue, 21 Oct 2025 21:51:09 +0200
Message-ID: <20251021195037.913929617@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 7f38a1487555604bc4e210fa7cc9b1bce981c40e ]

The vop2_plane_atomic_check() function incorrectly checks
drm_rect_width(dest) twice instead of verifying both width and height.
Fix the second condition to use drm_rect_height(dest) so that invalid
destination rectangles with height < 4 are correctly rejected.

Fixes: 604be85547ce ("drm/rockchip: Add VOP2 driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Andy Yan <andy.yan@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20251012142005.660727-1-alok.a.tiwari@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index 5d7df4c3b08c4..a551458ad4340 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1118,7 +1118,7 @@ static int vop2_plane_atomic_check(struct drm_plane *plane,
 		return format;
 
 	if (drm_rect_width(src) >> 16 < 4 || drm_rect_height(src) >> 16 < 4 ||
-	    drm_rect_width(dest) < 4 || drm_rect_width(dest) < 4) {
+	    drm_rect_width(dest) < 4 || drm_rect_height(dest) < 4) {
 		drm_err(vop2->drm, "Invalid size: %dx%d->%dx%d, min size is 4x4\n",
 			drm_rect_width(src) >> 16, drm_rect_height(src) >> 16,
 			drm_rect_width(dest), drm_rect_height(dest));
-- 
2.51.0




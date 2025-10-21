Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FB22773DA;
	Tue, 21 Oct 2025 20:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077476; cv=none; b=knybDHSla38gV9WrSd/euN0HL7lkij5jh2IAWfm3+HcyBxuX6SJr18jq39VpCntiwTbzbDAvSGeYJ54YgcUoZJJgCWJg9H6hRlLppA/A/mGuAhkj69DLmCX10bc3ZlGlUuMwtycFbZZNf7PaIaLACL9aoC+Q9Lbo3CIPw4Y1xQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077476; c=relaxed/simple;
	bh=RSqLpOVdIBc1CF6vdtKA0RS3Uxdlmdk+5RYieTfUTEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwHmBTFLot6R1euYc7wduqHGKWot5ykIPkxJDFMVUde9GfLQCxURO2fmOrn7Bg3YGQuGovgk8K1TSs/faccgJzEbXOm8OFILRBErgDfO1lZ9tQlYf6qKCak5sVDvXAxMISV97DC6Ilf9Lk3eVP71h3TLZ/TOonZN7c2iuYqMBr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCxDpmKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCxDpmKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413DFC4CEF1;
	Tue, 21 Oct 2025 20:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077475;
	bh=RSqLpOVdIBc1CF6vdtKA0RS3Uxdlmdk+5RYieTfUTEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCxDpmKVhgKGo/SOwaMpJImePZFFviA0s4zJWiHPkOZndbwOJUNCIbKYl30T3B0/g
	 qD2/NKsCHsS0lI5orF4MBRgIOaa9GTs7u/YeWu9QRXM+5Dr8+XvDALPpOtNmsbmW7t
	 o3qJJdQ2bjRjFN0IhSdYV4DnyEGeGr3HuGWaWDNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Andy Yan <andy.yan@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 116/159] drm/rockchip: vop2: use correct destination rectangle height check
Date: Tue, 21 Oct 2025 21:51:33 +0200
Message-ID: <20251021195045.953315121@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b50927a824b40..7ec7bea5e38e6 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -1031,7 +1031,7 @@ static int vop2_plane_atomic_check(struct drm_plane *plane,
 		return format;
 
 	if (drm_rect_width(src) >> 16 < 4 || drm_rect_height(src) >> 16 < 4 ||
-	    drm_rect_width(dest) < 4 || drm_rect_width(dest) < 4) {
+	    drm_rect_width(dest) < 4 || drm_rect_height(dest) < 4) {
 		drm_err(vop2->drm, "Invalid size: %dx%d->%dx%d, min size is 4x4\n",
 			drm_rect_width(src) >> 16, drm_rect_height(src) >> 16,
 			drm_rect_width(dest), drm_rect_height(dest));
-- 
2.51.0




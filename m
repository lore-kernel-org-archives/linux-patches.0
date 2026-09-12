Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45737204A;
	Sat, 12 Sep 2026 07:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197067; cv=none; b=rR+5iWRmErLJHWvAv7DFGb8p64M0yuSTJAnUvG0w0pBJTopRFbIRjFSkGawDOr9PYIbkKeopyIo6xYNw6915kVSrvoWMo+la2aDy9piXhW40h6kEvlruXFGXN2LzRGFO2ru1hpAcv2UIh/s8mf8tojNkOi4V/aFeaDvdnCCeoJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197067; c=relaxed/simple;
	bh=rYS7ougJmZjL7pcwv+ta7futfpizkt6EG79wtS24L/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=an2eqXmS6NopzwPfqRCXLGkTuiqICuXl60YaoFmpRBOiz5W1U7qzQCfwLiWEPlluigaCYUxVa2HzrFflizC7pu19dEZE+BFmCwPToeur3a972KhVvB76X+/kPfjiZxKGDpJC2i0kPuTpQJUEr6tx8VaqDU4wUvsDN7elQ64EgA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VH6+vhGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VH6+vhGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30F71F000FF;
	Sat, 12 Sep 2026 07:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197066;
	bh=Oz6Tvd1oq/CWaJUA1ooVSVW/tWnCdhoIiERX2gLzxTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VH6+vhGPoulGORrp70zN3B6tiys5jc4DCJNKRU3M66sXqdV+aCJnHLDSDg4X9zOeO
	 UgwKPhgoWmK0OXwlTa2503iNu2kJPITjlrIP2OJ66zx55eFl4HtAHx67hlPc9Mcug5
	 UOLsnWhOtJ1UsyFgjmYyf8CZ+EnWUrK7JPMzb5SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Daniel Stone <daniel@fooishbar.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0051/1815] drm/rockchip: vop2: Add RK3576 to the RG swap special case
Date: Sat, 12 Sep 2026 08:30:01 +0200
Message-ID: <20260912065650.217145703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit ae4a4e69389d576941522c3c2e01a2254fd00d10 ]

Much like RK3588, RK3576 requires an RG swap to be performed for YUV444
8-bit and YUV444 10-bit bus formats.

Add its version to the already existing check for RK3588, so that YUV444
output is correct on this platform.

Fixes: 944757a4cba6 ("drm/rockchip: vop2: Add support for rk3576")
Reviewed-by: Andy Yan <andyshrk@163.com>
Reviewed-by: Daniel Stone <daniel@fooishbar.org>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://patch.msgid.link/20260609-color-format-v17-12-35739b5782cc@collabora.com
Signed-off-by: Daniel Stone <daniels@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
index a160077a507f2..be7830c9001c9 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -337,7 +337,8 @@ static bool vop2_output_uv_swap(u32 bus_format, u32 output_mode)
 
 static bool vop2_output_rg_swap(struct vop2 *vop2, u32 bus_format)
 {
-	if (vop2->version == VOP_VERSION_RK3588) {
+	if (vop2->version == VOP_VERSION_RK3588 ||
+	    vop2->version == VOP_VERSION_RK3576) {
 		if (bus_format == MEDIA_BUS_FMT_YUV8_1X24 ||
 		    bus_format == MEDIA_BUS_FMT_YUV10_1X30)
 			return true;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258774BEE54;
	Sat, 12 Sep 2026 09:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205951; cv=none; b=gStYkRrhQJjJgUpCCR6Cbk5Ro9Z/YOIVMMCK/4k9Kn58iDmRgwf6ZZI1EYt2aGwPoNiYxS87+kNZ0uzBhoyS2XGxTIMPOYhwHjwLwmZG7mZS2wxD2Gf0Ut2qxqKGnnZiF/AGXKM4bCKcPt6WU0JAgvlk7yiUja4K7kWUXmHKYD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205951; c=relaxed/simple;
	bh=63wOIQ/C8bbFESJhxw5qtXRoM3t+VnR1pR9Fi3v1gsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZL7+0fcHp7GRmJgz2405Yot6K8VVFe2T4sVyDopofacC4Gl6FVNODR+Q+DS4iv7qDAdxnWBCNw/MjODHtewXkDQqlA1lwUydVkP568PD37RaQsCS4u7Uyemda18dUEVoQBoTb2GbRhbRYT+qpoSfbJHkUI7313OJ8oc/SqzaT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpUBG8sY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpUBG8sY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245DB1F000FF;
	Sat, 12 Sep 2026 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205950;
	bh=2mhy6cFMGBQinVDyztK1h7Oa5yYavK3ZGwDOZM3nFV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpUBG8sYNFAOI/cdxseU8/kfPT+xZHSF+Bt8DnjNJPHy6+LgfiBuBK/knC+tSR4uY
	 uULjvBb/fNIo5AfiUipL315eKtFe4hrfd4OVkNetkpr1Hn1O8fm052DT70LFCN8mTH
	 3gBYKj2HDVX3j+Wlwy/8mnoHtETnNxKI9eQC391E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Daniel Stone <daniel@fooishbar.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0107/1518] drm/rockchip: vop2: Add RK3576 to the RG swap special case
Date: Sat, 12 Sep 2026 08:37:56 +0200
Message-ID: <20260912065625.898496657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 7ec7bea5e38e6..a9ae9e472f56b 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -336,7 +336,8 @@ static bool vop2_output_uv_swap(u32 bus_format, u32 output_mode)
 
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




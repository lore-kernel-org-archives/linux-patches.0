Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3D246AA77;
	Tue, 21 Jul 2026 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648035; cv=none; b=Oj08FDRJcTqtxUAc2O/O19R7JCQ+sDPjUZlEs2ru6fvgv8JXD2+fvyWH0khi/3ssPC2ZYkOjKpwyF1p01U/k0shII7ybeeppjS0+//O0ncqS91UzZljg1CgO5AZeSLciEGbsoLsSVKOls8JdpOrkK+9DKm/9m61bJBaUC+aVZ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648035; c=relaxed/simple;
	bh=jGMcn6fJ7DEI24mV2MFb0Drzo/FNlrjhoKE7NKcQCqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnDMEzrKRmVJdAdAUE1hRjp5d7lxYWdqnOiWAL0Epgnv6/kfw2d7ncXtvtu3qPgHvmQhb5p14TxZwNWZxIebQrTdzGtE0lzx2Zqi4EOKGZEkIVTQ3ltyl4K0UZSFxk8438KXRy3tzGNzwfT0Fzkf31t4w+fOGbB5rlwTJU25mQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgmKnrQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgmKnrQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656271F00A3A;
	Tue, 21 Jul 2026 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648033;
	bh=/uOlw14Bum/L3LOAPG5sOZGL3BeEr58Z5NKb0aw7jEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgmKnrQqPHqSKsFatZbE1GRlR8I5FH4EHOpUUeME9zcPkOqsBfiF/Fe95uPymzdJy
	 wQmEcDb900t4OBsusJY0QGtMXWgjQOA2os6J4OHrfhoiyyKWp3Tg6/jGw8ouIQUR46
	 IEszLgl8uwshsG0oIDEt/MkKDe97R9vs6kg0rPPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sandy Huang <hjc@rock-chips.com>,
	=?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
	Andy Yan <andy.yan@rock-chips.com>,
	linux-rockchip@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0048/2077] drm/rockchip: Test for imported buffers with drm_gem_is_imported()
Date: Tue, 21 Jul 2026 16:55:21 +0200
Message-ID: <20260721152553.823322780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 9fc0da81916250f343599a4dd259f097196bf0fb ]

Instead of testing import_attach for imported GEM buffers, invoke
drm_gem_is_imported() to do the test. The test itself does not change.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sandy Huang <hjc@rock-chips.com>
Cc: Heiko Stübner <heiko@sntech.de>
Cc: Andy Yan <andy.yan@rock-chips.com>
Cc: linux-rockchip@lists.infradead.org
Fixes: b57aa47d39e9 ("drm/gem: Test for imported GEM buffers with helper")
Closes: https://lore.kernel.org/dri-devel/38d09d34.4354.196379aa560.Coremail.andyshrk@163.com/
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260227133113.235940-11-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
index 09d14a072d274e..b188539dca0b25 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -334,7 +334,7 @@ void rockchip_gem_free_object(struct drm_gem_object *obj)
 	struct rockchip_drm_private *private = drm->dev_private;
 	struct rockchip_gem_object *rk_obj = to_rockchip_obj(obj);
 
-	if (obj->import_attach) {
+	if (drm_gem_is_imported(obj)) {
 		if (private->domain) {
 			rockchip_gem_iommu_unmap(rk_obj);
 		} else {
-- 
2.53.0




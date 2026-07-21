Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB613F825F;
	Tue, 21 Jul 2026 19:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661416; cv=none; b=IwyKifqvBpJZb1dWpmgIM5qo+T9RNHwzOPmIK6Tbo2atugGtYmnAOaZwiaZyorlrBnhDGTlppDwXlCQUS5a9FkvAaQXZiIoHkL/yQ2MmjSJojrLN1x2s3ZthjC+hrxChkN6d71IUbaPedI/9W+4Go0WyvndB4Bjls9MuiFg8ASI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661416; c=relaxed/simple;
	bh=NAuNPgC+kUC3+RLPLhjADMjKEEx2+UIeHt/okuqSjGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VY6+yJ4F+UaDRIoqyANlqAt/9WiTUJK858nuLHnIuiH3L2ba1yA1FoXTPhCRC+6TmLmWtKtusB7LzAdJvXi9LIfLAebwGdldn8iVd/A69YwblrLwEhqCf2T+Sod7t4L7b0oroNv+0OkiQXaMqks+pnxPTvMjJ30RP6EKC6liR0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1ub1NGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1ub1NGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5A31F000E9;
	Tue, 21 Jul 2026 19:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661415;
	bh=Q/kU09kCJP9HuucSaTnPcPEjwknPeB+ZRmwbLppqKFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1ub1NGwHBXt7iiOQeC6AKaYOP6QVE2uQ+hI+139x+vUYH5E8myx6yZp6b0CdgIGB
	 KcgM4EpQmM4FQBWWZ9zSktHKpGhdOqbbpe41Ha3U6Uqhfa1fDH9VRAkKdoPVa6xuhC
	 gnYLPrKDbFmR8YZupn/trsYKqJBLbTqGyqguo+sc=
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
Subject: [PATCH 6.12 0059/1276] drm/rockchip: Test for imported buffers with drm_gem_is_imported()
Date: Tue, 21 Jul 2026 17:08:22 +0200
Message-ID: <20260721152447.404714983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 93ed841f5dceae..04879e23797fb7 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -332,7 +332,7 @@ void rockchip_gem_free_object(struct drm_gem_object *obj)
 	struct rockchip_drm_private *private = drm->dev_private;
 	struct rockchip_gem_object *rk_obj = to_rockchip_obj(obj);
 
-	if (obj->import_attach) {
+	if (drm_gem_is_imported(obj)) {
 		if (private->domain) {
 			rockchip_gem_iommu_unmap(rk_obj);
 		} else {
-- 
2.53.0




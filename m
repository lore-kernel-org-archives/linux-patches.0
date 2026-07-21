Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97583CF1E0;
	Tue, 21 Jul 2026 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655576; cv=none; b=r+zcD1SrH0Ne4NFpvgWfoYB8O9rIISgPu09fCWz2cCEjnYKJSfJzg7x2Kru7ZcRbBNRvYxtyYPq+klZv2QCZgBR6rIhyMGxWgGYRK43Vc9woBHSODepdfJONhmxQutQOA3QIGDIUKu0XOL77q2ASfObiys431VNuthjK0sG5cg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655576; c=relaxed/simple;
	bh=AYZvqUwgQY8ZN+lqu3HUoOBc7rgIGkLte51T+MkjxTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElZ4qyVb6G0mtee0wyqueQaj/Wt/gllelWUuJjDFl9uThp16CRmoOQGw7/tMFjTcN42KY1GG0c2UNMyLEeQDN/ChbJALvC3Jrl2qHy+guVih5KJLwZ6bC0lS5ZM0YfJ9yB1lSHWLHdti1YYSdVJdI3QZOfNS3vKfqFNg+vmnlEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpa9fVRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpa9fVRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ACE1F00A3A;
	Tue, 21 Jul 2026 17:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655575;
	bh=GlbGvjMibPj32McD7/YiBxAzyx1fK+eJ0ZlcnZttDtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpa9fVRZoiSxyLGWA1YCtu9pTtihfQhJuOJYt1ZtqJndj3hQr6qdeRdP0TajYRTcq
	 N3Oug4GXQuvjOPgnU3pKUCjdteGcTSSHS/2TxcvpadQrJZhT7TIkfaIlcBtN7aiY8N
	 2botSi4qp7jS8e8W1stNPL4Rys6rEXskhUzm1qLQ=
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
Subject: [PATCH 6.18 0062/1611] drm/rockchip: Test for imported buffers with drm_gem_is_imported()
Date: Tue, 21 Jul 2026 17:02:58 +0200
Message-ID: <20260721152516.225613125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6330b883efc35d..e44396d46dc1f6 100644
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




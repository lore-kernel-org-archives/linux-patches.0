Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD74A235358;
	Sat, 12 Sep 2026 07:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198293; cv=none; b=mifmO1ifc1u3tP8ZuCdaK9hbs+JZzJjQJjge/jYLhn56NWAa6GZ+TrQ4yhItZx+LqZ3zk9DJU4f9FIavmspIGYQ0GpcsfRMLtG+OWoVI1b6GR7oQmEcHtsZ45il3pD5Tajw2uKbG/zWL0jWCZpCA8eE+DfDQqfnPJXgZxru+Gdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198293; c=relaxed/simple;
	bh=yaUzsSddNs8BM/9uUlT7FaqvS4gTkq6Yynzvbuz4x5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ro78v/HH1gFEL3M1wQys6jtPA0CcRa1FTpAOUwVb/Z8sm01ULQo8VDRQJ4itOMcpctNkKjDrT4GUqNsWkjQ0Uvd+heDloMAPFpNxsuPHxSsJpy8GDVksVCAovxPDXttcCKT7lbaN/Gnk0dsMPrI38atpvVKrHcNtu84k9iUCi0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hugHU5RC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hugHU5RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0981F000FF;
	Sat, 12 Sep 2026 07:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198291;
	bh=CFaO71ZgnG1wdevGcQfDW9/YdQh7+ohOz+x7f5epfEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hugHU5RCb1E4j82v7nS0U/gTi71xbXnXF6NjHMJVA+RYRJTLdhv2OA39Xo39mIbGC
	 kaa59S9H2XXHoEp5AlDmyFNaeL38qi0SZcUYGl+AXdKaBAuDfR5olp51teZXeYPGG2
	 gDOLjFbPAlR2r0T46eiA8wpaoqqhZcRQSmzwpbvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0349/1815] drm/msm/dp: add missing drm_edid_connector_update() before add_modes on cached EDID
Date: Sat, 12 Sep 2026 08:34:59 +0200
Message-ID: <20260912065657.105967530@linuxfoundation.org>
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

From: Jens Glathe <jens.glathe@oldschoolsolutions.biz>

[ Upstream commit b7088d58dccfba87fe8dd2ab7c493ee1d9d09277 ]

After the refactor to struct drm_edid, the fast path in
msm_dp_panel_get_modes() that already held a cached EDID called
drm_edid_connector_add_modes() directly without first calling
drm_edid_connector_update().

The new API requires the update step to associate the EDID with the
connector. Add the missing call. This restores correct behaviour for
the cached-EDID path.

Fixes: 5bea90ad9743 ("drm/msm/dp: switch to struct drm_edid")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Patchwork: https://patchwork.freedesktop.org/patch/731125/
Link: https://lore.kernel.org/r/20260608-drm_plug_flaky_edid-v3-1-1ca632938e7f@oldschoolsolutions.biz
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 6bb021820d7c5..5b4954e7cb748 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -332,8 +332,10 @@ int msm_dp_panel_get_modes(struct msm_dp_panel *msm_dp_panel,
 		return -EINVAL;
 	}
 
-	if (msm_dp_panel->drm_edid)
+	if (msm_dp_panel->drm_edid) {
+		drm_edid_connector_update(connector, msm_dp_panel->drm_edid);
 		return drm_edid_connector_add_modes(connector);
+	}
 
 	return 0;
 }
-- 
2.53.0




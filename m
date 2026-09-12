Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5513F1AC6;
	Sat, 12 Sep 2026 09:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207106; cv=none; b=l/XMUyYI6t7EMJthc57OxdzVdw/mu4NLf6b24UjgDIaV4o5vWLzln4F+iho9dTvF9rpdzw/a8lgliebenvAOFMjNXujNREhD03B1Z2gR18rWJixOKtuHA9g82ChxrlJwwD7QC0FhvweOoEx2E2kmTxm1h6jl10h1qLQkkUq6S98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207106; c=relaxed/simple;
	bh=P8ejfzEasgK1876eGHS4yLLXRYzJvUzmVHQpcoR7/z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX4oYINLxtrF9lm62uxtwPJIgFVg4PXS4+iQmCT7nR73WGVJQ47cF054Sebrl3+BSnCHjoceddDuuqvRMcuBHSnbcXLDn6j7n1sNxxZSf3VZXmlD29zkna+lU3pacuVnKShoNW/Q3hbQgk8YMQonpclCsP8zosmRfdlF+2mhWdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALxpMHnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALxpMHnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F28C1F000FF;
	Sat, 12 Sep 2026 09:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207105;
	bh=ZBBpjZXuw7libLpoujSlYs8HSbI6UArWJkY0SRkDX4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALxpMHnJAz3/3o7FNnHtakQFTaUFsGvcuPGV6XYMKbE1TL6g/6fawA5VFZummV1Na
	 olS6TvVlLYqS4id2huyS+m84rEr1ddsVae9RUMdnDSeKTAPtQ0XlirTs6T+r/C9wPi
	 cTbemCM2RF07Endrdzn5C5WGwLig7agQj28Eu/yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0344/1518] drm/msm/dp: add missing drm_edid_connector_update() before add_modes on cached EDID
Date: Sat, 12 Sep 2026 08:41:53 +0200
Message-ID: <20260912065631.255642575@linuxfoundation.org>
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
index 15b7f6c7146e1..9191f0fc3d81a 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -254,8 +254,10 @@ int msm_dp_panel_get_modes(struct msm_dp_panel *msm_dp_panel,
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




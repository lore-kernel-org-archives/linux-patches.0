Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E99A33CFD;
	Fri, 24 Nov 2023 18:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soOldHE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA44C433C7;
	Fri, 24 Nov 2023 18:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850484;
	bh=bekpCo82Bnnk9bxIuUKMkkyW5IFnuGEvAybiEyCfxU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soOldHE435/vMq2tK1rCUua92pYcKp2KpTpTxxWTdA0fjpwWx27+x2/6ccUam56MT
	 7rrLDNjuKzCXUqzFwv2lc2ylJmT0mtAij8vBkKMlOjJftIhTOdgv1jtr0JKfxOSEGF
	 vn5+xHMsae3a1hXag1OB0/M4I9MEDukd7in/5vFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 068/491] drm/radeon: fix a possible null pointer dereference
Date: Fri, 24 Nov 2023 17:45:04 +0000
Message-ID: <20231124172026.687868544@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 2c1fe3c480f9e1deefd50d4b18be4a046011ee1f ]

In radeon_tv_get_modes(), the return value of drm_cvt_mode()
is assigned to mode, which will lead to a NULL pointer
dereference on failure of drm_cvt_mode(). Add a check to
avoid null point dereference.

Signed-off-by: Ma Ke <make_ruc2021@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 07193cd0c4174..4859d965d67e3 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -1122,6 +1122,8 @@ static int radeon_tv_get_modes(struct drm_connector *connector)
 	else {
 		/* only 800x600 is supported right now on pre-avivo chips */
 		tv_mode = drm_cvt_mode(dev, 800, 600, 60, false, false, false);
+		if (!tv_mode)
+			return 0;
 		tv_mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
 		drm_mode_probed_add(connector, tv_mode);
 	}
-- 
2.42.0




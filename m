Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ABE84E04;
	Wed,  7 Aug 2024 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043604; cv=none; b=r4Gu++IdAcrwz9NZpghYXCl+UDmI3v7uKczuFQ2OV4APsA8kC+doVovujFsOBALu1liNezBc1duvXCcDmijPDBzJEt9x1XdFub7znlyr1UR04xQPzGbMeD3glyK/XtKDALAo7vk7mF7XUEqceqhQE5rIYYEUKLAq02KeiIaq754=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043604; c=relaxed/simple;
	bh=BuxNiLu7n1s8hhwNV9Ub7yCGq8+tgwqHgBmZIn8+30Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBeJmEYMfKrvm9RWFykYBe1faw7DMGDXH0HVZ3dv377V2KQt8RgS3Kj7G07sRE2kRIDguBAg5GZrxuXvcbC1blKZLlb801jJMKr5RkeJHfr4iv9MEea7GrmysRwOkQpTNEGWUlHYZ9wArjkxq4oiyeMgL40Vmj6h2dJhfOay2NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6qIy+bU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6qIy+bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBAAC32781;
	Wed,  7 Aug 2024 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043604;
	bh=BuxNiLu7n1s8hhwNV9Ub7yCGq8+tgwqHgBmZIn8+30Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6qIy+bUzZYAwyoWTKA9l1kwDvwKzUuv8IsaheyvlEUKcheP9XpmXKiC7947ppm1A
	 ygqU6ns1pBtQW6lDv88XarE1ZcHZvYIDSdvM0EVnjtVKOfPUUhJhHpefVIjLmnrEeg
	 2pxW4gQb1sVhiCP/HtpymckZx8Bm9lcyABgNB0wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Robert Tarasov <tutankhamen@chromium.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/86] drm/udl: Remove DRM_CONNECTOR_POLL_HPD
Date: Wed,  7 Aug 2024 17:00:11 +0200
Message-ID: <20240807150040.296928993@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 5aed213c7c6c4f5dcb1a3ef146f493f18fe703dc ]

DisplayLink devices do not generate hotplug events. Remove the poll
flag DRM_CONNECTOR_POLL_HPD, as it may not be specified together with
DRM_CONNECTOR_POLL_CONNECT or DRM_CONNECTOR_POLL_DISCONNECT.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: afdfc4c6f55f ("drm/udl: Fixed problem with UDL adpater reconnection")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Cc: Robert Tarasov <tutankhamen@chromium.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Sean Paul <sean@poorly.run>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.15+
Link: https://patchwork.freedesktop.org/patch/msgid/20240510154841.11370-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/udl/udl_modeset.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_modeset.c b/drivers/gpu/drm/udl/udl_modeset.c
index 93e7554e83fa3..8f4c4a857b6e8 100644
--- a/drivers/gpu/drm/udl/udl_modeset.c
+++ b/drivers/gpu/drm/udl/udl_modeset.c
@@ -514,8 +514,7 @@ struct drm_connector *udl_connector_init(struct drm_device *dev)
 
 	drm_connector_helper_add(connector, &udl_connector_helper_funcs);
 
-	connector->polled = DRM_CONNECTOR_POLL_HPD |
-			    DRM_CONNECTOR_POLL_CONNECT |
+	connector->polled = DRM_CONNECTOR_POLL_CONNECT |
 			    DRM_CONNECTOR_POLL_DISCONNECT;
 
 	return connector;
-- 
2.43.0




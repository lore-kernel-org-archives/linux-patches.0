Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFE52E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2F2C433CA;
	Wed, 20 Sep 2023 12:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211961;
	bh=AWcqMhpC4ROOsLXE7k0R3INU8oYXeaYKTVjioMIZ8Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7EEOPc4NJerte/UeXPculcCEftvAL91cDX7d1h84VO47lCQ0ZGscrEbpcYjlLj50
	 lbRdzTOpRplCsJFdIpJ4/1dUDH23vYa5hPNv5hNZ5BHnf2QIc3WEDnYpUhmSBcApiM
	 5uzbd3vDZCR2pHn7AgYj9drO1849WCtKAx2uDJis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robdclark@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/273] drm/msm: Replace drm_framebuffer_{un/reference} with put, get functions
Date: Wed, 20 Sep 2023 13:29:00 +0200
Message-ID: <20230920112849.535260959@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit f2152d492ca4ff6d53b37edf1a137480c909f6ce ]

This patch unifies the naming of DRM functions for reference counting
of struct drm_framebuffer. The resulting code is more aligned with the
rest of the Linux kernel interfaces.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Rob Clark <robdclark@gmail.com>
Stable-dep-of: fd0ad3b2365c ("drm/msm/mdp5: Don't leak some plane state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
index 501d7989b9a5f..0cbc43f61d9c7 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -185,7 +185,7 @@ static void mdp5_plane_reset(struct drm_plane *plane)
 	struct mdp5_plane_state *mdp5_state;
 
 	if (plane->state && plane->state->fb)
-		drm_framebuffer_unreference(plane->state->fb);
+		drm_framebuffer_put(plane->state->fb);
 
 	kfree(to_mdp5_plane_state(plane->state));
 	plane->state = NULL;
@@ -231,7 +231,7 @@ static void mdp5_plane_destroy_state(struct drm_plane *plane,
 	struct mdp5_plane_state *pstate = to_mdp5_plane_state(state);
 
 	if (state->fb)
-		drm_framebuffer_unreference(state->fb);
+		drm_framebuffer_put(state->fb);
 
 	kfree(pstate);
 }
-- 
2.40.1




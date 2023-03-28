Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02C58BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A3AC433D2;
	Tue, 28 Mar 2023 15:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015724;
	bh=sDkruBFyfQL22Bvsy8QT47HOFCYwklASkPBiGar2oVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZVa6yTxaWt9DUrvTqbQKC1HI65io1vh5kBd5Jep0AfthRA1TQBxJYgOMJAtOqU/x
	 QQNpWFoGdR0hfJ3fX0sk/LVDkdDaqWPCkOIizDpW7Ju4NP2CmXQX1s53Y50ljta0VW
	 pYylK3P0YzmupzYzT+ousoql3sY6bFJKCHzk4X4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/224] drm/cirrus: NULL-check pipe->plane.state->fb in cirrus_pipe_update()
Date: Tue, 28 Mar 2023 16:41:58 +0200
Message-Id: <20230328142622.443658164@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandr Sapozhnikov <alsp705@gmail.com>

[ Upstream commit 7245e629dcaaf308f1868aeffa218e9849c77893 ]

After having been compared to NULL value at cirrus.c:455, pointer
'pipe->plane.state->fb' is passed as 1st parameter in call to function
'cirrus_fb_blit_rect' at cirrus.c:461, where it is dereferenced at
cirrus.c:316.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

v2:
	* aligned commit message to line-length limits

Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230215171549.16305-1-alsp705@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/cirrus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/cirrus.c b/drivers/gpu/drm/tiny/cirrus.c
index 354d5e854a6f0..b27e469e90217 100644
--- a/drivers/gpu/drm/tiny/cirrus.c
+++ b/drivers/gpu/drm/tiny/cirrus.c
@@ -455,7 +455,7 @@ static void cirrus_pipe_update(struct drm_simple_display_pipe *pipe,
 	if (state->fb && cirrus->cpp != cirrus_cpp(state->fb))
 		cirrus_mode_set(cirrus, &crtc->mode, state->fb);
 
-	if (drm_atomic_helper_damage_merged(old_state, state, &rect))
+	if (state->fb && drm_atomic_helper_damage_merged(old_state, state, &rect))
 		cirrus_fb_blit_rect(state->fb, &shadow_plane_state->data[0], &rect);
 }
 
-- 
2.39.2




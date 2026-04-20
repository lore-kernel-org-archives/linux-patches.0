Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5B93E5EC2;
	Mon, 20 Apr 2026 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691495; cv=none; b=VEI4t9oV/tw9HbuDl+k7Gl5F94OAKBI+ajweiXa0t/p8L+yPN21soAbd/PCF4UlWE0WRSycBZB8CR9ocRqgOJx6iybxbEfS2l/PsdPPXA/oXUBjsKDtvtjmCT8GC5hRfrXIa9y739crAEbHCLvp/xXnagufXStjd/julwDj3Xhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691495; c=relaxed/simple;
	bh=pOp+eJfoibS42wCPoPksJ4QyssD3Lgbx3oTsSJ2B/+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d9N7/87tJOq5hIUSflQ6BCaVZqVRCfwLchZViF73FqaC+EQ6QGkCVq5h4eZ6r2LDdxvytPx9tDWAWuxeqSrgoERgyHqxSpzXLbkqaR0Ii+LXVaPKbwx3ZJFbrMTsUOyv/oLY7wiOWEc3M5L+ZJDfI0gQCf38TIlNlqQLvP5w+Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WADj/ak2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WADj/ak2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95646C2BCB4;
	Mon, 20 Apr 2026 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691494;
	bh=pOp+eJfoibS42wCPoPksJ4QyssD3Lgbx3oTsSJ2B/+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WADj/ak2I1KlbEYuguJ/0N1xpYw9xV4w7UueLoTHotvrrCzGyzVcAWp3anbxKqp5h
	 PVyXQ7M1LH/bEHw1G51Z5LGgTkcMDc9vYzH8GvVppvUMLiveHedellP1N1fFGrb7dc
	 hYexjcXkM/OPiIZR8tZ+sTqJ8z42zDOo5a35rOqtu/WXHgubJaoBSDdTj0It9taQ5J
	 fHvraU1lx1l7AG+Qylvw0JqP8apT5kpF6Ehw53kaZtRwvsYYBe9exLGOl92hdu6+Io
	 VnqGu6ug0pinLYSqjWw7HbgkVOJNF9OqAi5rS0l/+I+DDX6WeSanfFQ53qc1TiWvJ4
	 wYmpdEHoKKJyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Melissa Wen <mwen@igalia.com>,
	Sasha Levin <sashal@kernel.org>,
	mripard@kernel.org,
	dave.stevenson@raspberrypi.com,
	maarten.lankhorst@linux.intel.com,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	eric@anholt.net,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/vc4: Fix a memory leak in hang state error path
Date: Mon, 20 Apr 2026 09:17:37 -0400
Message-ID: <20260420132314.1023554-63-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 9525d169e5fd481538cf8c663cc5839e54f2e481 ]

When vc4_save_hang_state() encounters an early return condition, it
returns without freeing the previously allocated `kernel_state`,
leaking memory.

Add the missing kfree() calls by consolidating the early return paths
into a single place.

Fixes: 214613656b51 ("drm/vc4: Add an interface for capturing the GPU state after a hang.")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-3-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/gpu/drm/vc4/vc4_gem.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 6238630e46793..6887631f2d8be 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -170,10 +170,8 @@ vc4_save_hang_state(struct drm_device *dev)
 	spin_lock_irqsave(&vc4->job_lock, irqflags);
 	exec[0] = vc4_first_bin_job(vc4);
 	exec[1] = vc4_first_render_job(vc4);
-	if (!exec[0] && !exec[1]) {
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return;
-	}
+	if (!exec[0] && !exec[1])
+		goto err_free_state;
 
 	/* Get the bos from both binner and renderer into hang state. */
 	state->bo_count = 0;
@@ -190,10 +188,8 @@ vc4_save_hang_state(struct drm_device *dev)
 	kernel_state->bo = kcalloc(state->bo_count,
 				   sizeof(*kernel_state->bo), GFP_ATOMIC);
 
-	if (!kernel_state->bo) {
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return;
-	}
+	if (!kernel_state->bo)
+		goto err_free_state;
 
 	k = 0;
 	for (i = 0; i < 2; i++) {
@@ -285,6 +281,12 @@ vc4_save_hang_state(struct drm_device *dev)
 		vc4->hang_state = kernel_state;
 		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
 	}
+
+	return;
+
+err_free_state:
+	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
+	kfree(kernel_state);
 }
 
 static void
-- 
2.53.0


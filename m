Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F08171AE;
	Sat,  3 Feb 2024 04:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933398; cv=none; b=iq4JLltYc6xwJr/FVgLtoioGkZxGspYtXt7pDY3hDsZcrNs7XqBr2zfkRfvQPlQXvhPKPAzv+yCOgc4aQQVWOI3bqGYtKtIrcvNAE2dWSiaFJcAKjd00PjquK4RQi7pipS5dzeA4ASB5xIj9y2/1l+XAL/q9NOeueHZlfIouxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933398; c=relaxed/simple;
	bh=uz+1OvP+8ldIOeXEApy4AMmiDPato8DwO4t7X6XaYf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXPM+HDMUoiATDZny4sedip6ZyW6VYSlWpYLOmGEs+UIflm1m5CQ8fZguntLsv73Wv/3tA4NPJyeVwF21X5NsqQIJTakGlJjcSlVETIg8+FrubB5l5NsnWagI3G9noy5rRlxuOVGH7fGgG00N7H9+d2wGtj3QlrtW0bstNigA78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mlh4+1KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mlh4+1KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09AFC433C7;
	Sat,  3 Feb 2024 04:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933398;
	bh=uz+1OvP+8ldIOeXEApy4AMmiDPato8DwO4t7X6XaYf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mlh4+1KL1ckM09c9f2iA9HL8GqiTc9LVy1SHOxOngf47KQKdnVjJBxvvofHeEx12V
	 CCilBaDl9PArnJp5BmU9E+qJcPGGdSbA+wFXr7/njqgBVpEC5tS1zWvbIC+1PAxwf9
	 xlJ6yGx+82XzoIkOsR2e/76/wVm2pPQANo/WMGvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/219] drm/drm_file: fix use of uninitialized variable
Date: Fri,  2 Feb 2024 20:04:47 -0800
Message-ID: <20240203035333.431800802@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 1d3062fad9c7313fff9970a88e0538a24480ffb8 ]

smatch reports:

drivers/gpu/drm/drm_file.c:967 drm_show_memory_stats() error: uninitialized symbol 'supported_status'.

'supported_status' is only set in one code path. I'm not familiar with
the code to say if that path will always be ran in real life, but
whether that is the case or not, I think it is good to initialize
'supported_status' to 0 to silence the warning (and possibly fix a bug).

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231103-uninit-fixes-v2-1-c22b2444f5f5@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index a8b4d918e9a3..d6a0572984b5 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -406,7 +406,7 @@ int drm_open(struct inode *inode, struct file *filp)
 {
 	struct drm_device *dev;
 	struct drm_minor *minor;
-	int retcode;
+	int retcode = 0;
 	int need_setup = 0;
 
 	minor = drm_minor_acquire(iminor(inode));
-- 
2.43.0




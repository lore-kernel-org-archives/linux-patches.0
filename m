Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFBD6F074;
	Wed, 21 Feb 2024 13:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522632; cv=none; b=X/lKjT0tdLcU1uk2WEhTaXbFUuMoZa6n7relloYxjx84pBwwvRekkENS0SZJIfo4LufQT9i4YP9V4Xwh0cxZCUDWpWuPd4bCRYvpuQAnSXaI+vYJQrOIwRQW+OYx+V871o0+pakXbCeQptnNTWYmkK3944HgUCJuHmLf7iwU6Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522632; c=relaxed/simple;
	bh=Sw0MQeDUslEG4WLJYFltQTPMBa92PeqIdmUXdKOXozc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evwEF9Tt/lsg1zBp+vMjEcp5Vq6xTcgb7cfIBdmQs7InyLco/Q62R+ReF4YomwA4fuNZCcSE3NtWmX4bKSMj5Msh9kIOnYhWAqIuUgT7u/1YF11xgvXZv2HuMAGBWUtmbLHvqj9GU7QNn+z89wbxGZbhQ2QzhK7Rq6fJXEvm3OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nMoP7sa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nMoP7sa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5E3C43390;
	Wed, 21 Feb 2024 13:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522632;
	bh=Sw0MQeDUslEG4WLJYFltQTPMBa92PeqIdmUXdKOXozc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nMoP7saLhl3jmAp0aEQJLyxyJfA+VsZmqfP2ZU31Ma1AVe982KVOAyb/S6eC1dJc
	 QIPsW6MPH2I+xH/hE0nL4Ug/AOXbXTnvVuwc65wbFYKPO+29Lsfop7BQTTz4bJJVXl
	 8THhSzfKEJFVLYhOPN5yqyulvwyKKNMwb8W3ezjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/476] drm/drm_file: fix use of uninitialized variable
Date: Wed, 21 Feb 2024 14:04:26 +0100
Message-ID: <20240221130015.849093689@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ed25168619fc..5062f13808f2 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -411,7 +411,7 @@ int drm_open(struct inode *inode, struct file *filp)
 {
 	struct drm_device *dev;
 	struct drm_minor *minor;
-	int retcode;
+	int retcode = 0;
 	int need_setup = 0;
 
 	minor = drm_minor_acquire(iminor(inode));
-- 
2.43.0




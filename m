Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC3C46C4A4;
	Tue, 21 Jul 2026 15:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648827; cv=none; b=rEXvSQqlx5KjbJYPJlNnklVENKGroPacspEcxuwHCujIMm8xtGyvFavg5ZAtPcjVne3CmD11ygQKRP2DOuhLWFTqs46QdApHUT0fKOcNx6IDGDdTkWI3WCRU35LlrUb36Ru0yzH4gopYKDSYqHUCb3LNV4bRupxORCGzBj87siE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648827; c=relaxed/simple;
	bh=lj+1aL567Lglu6YS+sXvT68MTbRmnMmI9HwHOGlOD48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9dsbRNIgomIX8lCsF5zDO+HDoYMJgWbn3VKSnkBMwv9YhT0cNtDmUF67J5iiR3IgsXfRze4/oiwI2LlYlknIADaeZHAtE/4b0w3FHd10lhmXea8zi1iNbepSsdIgsQO1i3xTj3Fe/hqFEb0x44Je57KJTDWZE7mGSo0u0QUDao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMmjNg2K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMmjNg2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1431F00A3A;
	Tue, 21 Jul 2026 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648826;
	bh=hAQtIxRDwGrSxPRTscCOWs20xYSIhUsIftfCnCnmsO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMmjNg2K722OCbMza7XVuGD3Rv6QYZk1O6waiL1288/wB7Bj0nlJP5L4/+VE7Ut0Y
	 1796IQ/A36+MK9ZCKrZ0fht1lTsoYOtjG+kBph3AK7nVRQiV9yb7INvjJ1PoKpgAva
	 JevlaS+kJ0UqfyWfdJ2FWFUy6ZhAUsp3nSyNxU6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	linux-tegra@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0345/2077] drm/tegra: fbdev: Do not assign to struct drm_fb_helper.info
Date: Tue, 21 Jul 2026 17:00:18 +0200
Message-ID: <20260721152600.826896312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit d23bd83f3e47a928e783c0d6a004737519dc77dc ]

That field already contains the value being assigned. No need to do
this twice.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 63c971af4036 ("drm/fb-helper: Allocate and release fb_info in single place")
Cc: linux-tegra@vger.kernel.org
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260421073646.144712-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/fbdev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/fbdev.c b/drivers/gpu/drm/tegra/fbdev.c
index 8f40882aa76ec9..19e39fa54bfae2 100644
--- a/drivers/gpu/drm/tegra/fbdev.c
+++ b/drivers/gpu/drm/tegra/fbdev.c
@@ -110,7 +110,6 @@ int tegra_fbdev_driver_fbdev_probe(struct drm_fb_helper *helper,
 
 	helper->funcs = &tegra_fbdev_helper_funcs;
 	helper->fb = fb;
-	helper->info = info;
 
 	info->fbops = &tegra_fb_ops;
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE5841836D;
	Fri,  7 Aug 2026 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114649; cv=none; b=mN++3F4Sh5Jwjcnum5eaG74ZBwH+KzAcd1Gow0OO62keBTr2JMh1G6wD0m/0yrdVim+w8EhkLPvd0SxCUp5KDSL4l2NeG1GDHN2XPzQXd1qHwPZHi9vh5TCl9etw8Gz7HbpSOVokUKWYu5Di8FNKuLLrs/BJnk23s4aLKcne8OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114649; c=relaxed/simple;
	bh=1V6leY0YCPnhe9+uKnfxEnio4AtAMgP6WMsYrUs40jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fv6Pf3EmocNLhuoJSTQXGw6f3HHj6rwWZPtawao9FJTQy5DX5KOhpy16Z+d8dDdp+OGaN+QwozRH1/+EgbOzbW63dumb6naneJmtQjWi0gouzLO9ctJDwcGehHKFm2J1hPCub/St6Z93CybMv+lc/5uG1nItw8+Q0/cn9SPoRGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkfsJ5Ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkfsJ5Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629841F00A3E;
	Fri,  7 Aug 2026 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114647;
	bh=U6P2urXYp2jItRnYWq60ACTzmcAoDO2IrskdZoCTNzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tkfsJ5NigstbGTsoQN/LmBdDVtG5YRF4t5HGA+mTrgdNiyu6OvnpSSUa7/MkOgXIa
	 OB8SIfl1MRyqHk6jcs+AafIsMmAeKGf3SGuDt+wk6t7DM+6Flg9GIVmK7UebYT4a+e
	 8v2QRtWhr9890MvFwiPD+pnujBBc9ISFu6q0ZCgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	linux-tegra@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 337/337] drm/tegra: fbdev: Do not assign to struct drm_fb_helper.info
Date: Fri,  7 Aug 2026 16:39:00 +0200
Message-ID: <20260807143425.846718476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit d23bd83f3e47a928e783c0d6a004737519dc77dc upstream.

That field already contains the value being assigned. No need to do
this twice.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 63c971af4036 ("drm/fb-helper: Allocate and release fb_info in single place")
Cc: linux-tegra@vger.kernel.org
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260421073646.144712-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/fbdev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/tegra/fbdev.c
+++ b/drivers/gpu/drm/tegra/fbdev.c
@@ -105,7 +105,6 @@ static int tegra_fbdev_probe(struct drm_
 	}
 
 	helper->fb = fb;
-	helper->info = info;
 
 	info->fbops = &tegra_fb_ops;
 



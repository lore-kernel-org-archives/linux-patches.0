Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946073F888A;
	Fri,  7 Aug 2026 15:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115776; cv=none; b=mNFN75lyOIrBtoP6unMcSAIWOcyxm+mozRlw0WsTxefPO0tEIHCYN5WbyNAghqzGBtwLzUWO9wR3BARCe2YRy3PpSIyKFhszw8mEl8SElOdW4lA1EyTLAw2nbn5OZ+y/UXhPwsDiKGPQ2iqdMkaaVw8hqC3zzMH/IM/30mJKhYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115776; c=relaxed/simple;
	bh=H8yrn3zU88+YGZpMsb1tWv156XW4OskATJzzKfHsKY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jl7dYwAlinrkyqo9p+qb5n2Y53IJ3M0j5bLJcBIb3/yU3Mc4TeJkMeFPwdwMTGcm4j25YIL5ZlbcaUjEirQ2mwNbxQ5WtMr2gz7x/i4bOrrjQV3CQp2BJ4DB5A9Hg0TJ4gEIDnkV9hD8Gv9W5kX7YU6ikSlM1cZAXfAFdU7Dxc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXWnnIa2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXWnnIa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA0A1F000E9;
	Fri,  7 Aug 2026 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115775;
	bh=0I6fBDlFuWE44Yo92mGchDuIndWnToG3oAGouaYZ5G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXWnnIa2KYCe42/H3AnRQtkuwVnnopmG7kV2VsTVztGmOW5k9vrQChP6rpuWJDyja
	 lRuEbxSLSRs9S8XYB1f4NpCe5C/JTOi7llwwOThEIbxD6vRQfsdZGG9W5dxSuNUXJu
	 lSYv5HJyUK9HnEn065YsWphb6HsB1siRm6RBdjsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	linux-tegra@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.18 396/396] drm/tegra: fbdev: Do not assign to struct drm_fb_helper.info
Date: Fri,  7 Aug 2026 16:39:16 +0200
Message-ID: <20260807143432.815447802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -111,7 +111,6 @@ int tegra_fbdev_driver_fbdev_probe(struc
 
 	helper->funcs = &tegra_fbdev_helper_funcs;
 	helper->fb = fb;
-	helper->info = info;
 
 	info->fbops = &tegra_fb_ops;
 



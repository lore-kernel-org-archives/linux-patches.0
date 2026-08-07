Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA2631327A;
	Fri,  7 Aug 2026 15:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116543; cv=none; b=vCTjIA4YkMI64jRlOS/AgPHRT7xEWeu0E+ViWQ3kNDDhbfBi3ld/tkmiIjFJhnTKKu+RIxligyQKUDD7EVAYUTA7jYICyGN5pfcYYnneb4N33Ho9fcUyEkrCdeTq2s5TQah5GAAdmD/TMD2p+S1mHj4QVfpNMwrQrKZVcLjQRpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116543; c=relaxed/simple;
	bh=dqKvFhdg7Ictx7S0cnjx8Uyj3HWoNQdXBSvFfQ0Hdto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hepB6Xn56qWft6EodCKNFzyFMaJnLEyV/fG2D+qV7UNzadAiMJjHMh0SHVu/Z4imkdEWYBfXUTLo0cjZ8yUIWJg46wyvfctyHNlE3sXJg8Z/y0S+g/O2U4oLOpQ5vDCeK04eXwpS6kimBv6aazCuxcUoLHMWwZ6VPy791xueGxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7Yy0oe4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7Yy0oe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6E61F00A3A;
	Fri,  7 Aug 2026 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116542;
	bh=uMygEjSIpnbolX2OdJr4kqo17Q+Tsi0PdNblteCl7LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7Yy0oe44NRt9EvJ4HGLvVDxpx52vcMSlbxQET6qK9MywISeduDl6UwWa3ygAO+zF
	 ybcMjcjxBv9GhH/0WgCqHchcQX3ebIfMkXKAX+OTDDKQ9WLLA4y4nd2BNFkX6YclLT
	 Kb+/7mpzUhZ3/GXGgNhEFV5hacwMtmlvxNI+8Ihk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	linux-tegra@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.6 260/261] drm/tegra: fbdev: Do not assign to struct drm_fb_helper.info
Date: Fri,  7 Aug 2026 16:40:17 +0200
Message-ID: <20260807143421.034276706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 



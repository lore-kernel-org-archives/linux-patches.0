Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D27646B9F;
	Mon,  1 Apr 2024 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987149; cv=none; b=qfXGiSjqOf2qD/1dP0MBlYX7jE8p6SKuOsGcHMDb4YYCKKnKOQg8kMy8HqYUiLX0lEtBMlzDGtlNDRzUTh5vmGcMEKKbAyi6hnbrAUlVDu30/gSuWpkongM2SpRvG2MUtBJeAepop4Z891Q05rkfsB+mcwDJEIklyJovb8Hc+1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987149; c=relaxed/simple;
	bh=oeIoI+7EGLZXdjAAeeuDYk2qKikG6mjLfn5tli3N/mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLqTZFs1Ha/BbNWKR8Q/CmF9v+xZkL+9Ya/vx05ljxt/bBSZEyFZmNY0ziOdqwtpNJnpx6XZR9njQGxT0ZNAK49vuj4oLq/me/ujbkQhreO6w6Hvp2wBulBfdZcZJ0juiRv2No8dcd3HVWFql32Y9ZdBKAK3fmk99JRTn6XoUis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ns+kfD/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ns+kfD/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C27C433C7;
	Mon,  1 Apr 2024 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987148;
	bh=oeIoI+7EGLZXdjAAeeuDYk2qKikG6mjLfn5tli3N/mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ns+kfD/U0Fh6UvgKvHgLwJ6zTj0N8ZaSqcAb/NteSctk/+YY/QbXz44z41bhhnwWF
	 ecfxEbbYC32ZugeOmC8hdjA+y3aIlPIhUI4SCul6Fs+hw+fasklgejfvHIe6dkXJen
	 Nn7eDlXuXE82fGn7ZVGaeXCu05Uv3HAAwW3MY9BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 169/399] drm/vc4: hdmi: do not return negative values from .get_modes()
Date: Mon,  1 Apr 2024 17:42:15 +0200
Message-ID: <20240401152554.223745583@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit abf493988e380f25242c1023275c68bd3579c9ce ]

The .get_modes() hooks aren't supposed to return negative error
codes. Return 0 for no modes, whatever the reason.

Cc: Maxime Ripard <mripard@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/dcda6d4003e2c6192987916b35c7304732800e08.1709913674.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index f05e2c95a60d7..f827f26543641 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -508,7 +508,7 @@ static int vc4_hdmi_connector_get_modes(struct drm_connector *connector)
 	edid = drm_get_edid(connector, vc4_hdmi->ddc);
 	cec_s_phys_addr_from_edid(vc4_hdmi->cec_adap, edid);
 	if (!edid)
-		return -ENODEV;
+		return 0;
 
 	drm_connector_update_edid_property(connector, edid);
 	ret = drm_add_edid_modes(connector, edid);
-- 
2.43.0




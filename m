Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFDE288B9;
	Sat, 12 Sep 2026 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230896; cv=none; b=mCmeglBXTg1HkyWyEs+MGUTFZfJvy1QgEc9oSXv/ejAr7fAUsDSB0uTjSh33+hNFnZkZOe0i7So2JA38I2vDqFYqH54OlnhGNSAL4Mk82q9CqazwH5kGpa27NOKD4LhrUGRagfc5H0gfrhOtbGLdgVCM1EcSiAdxB1hk2jnbl58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230896; c=relaxed/simple;
	bh=qNrVVAO8MQClLWoLGvEzjJh0KKSdGJMn9/qaFq8gIKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uafqvEZpUKRA2bgZG7fMFGm6dEPQSNI6v6cyLFJkDio9Pu1HR262uSr9nheUwRyVZ0jOrmpOK40lbqLUpuCQRrEy4zkJwRizFbAix8szP3bsuDvwl/jH3txZZJEAENK3OQaXJwh31rAyprilXBemJhYOeoDg9+peY6u3k1KrV2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWlRYE3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWlRYE3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD791F000FF;
	Sat, 12 Sep 2026 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230895;
	bh=g655+0L3KB47OnHdv3S+pdfVQD2IYrrbMe1hRUZoIYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWlRYE3eO3iKdFzD4w141vRyxIk1iurYglMH9zSt9ZaeMKIwXPEUE4DlHcdNPzorg
	 DnjFFbRiMLQ8K/3EQyD28tplUGvgMGVIBzcBXY/GJ0XOrAeW7CpleRJ2yqp/W0GX4W
	 8YcC9pLeyLktQOBEPE3a9Pt9qkj2E5K9uxL8PHj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0889/1191] drm/sun4i: dw-hdmi: Drop TCON TOP port reference
Date: Sat, 12 Sep 2026 09:00:17 +0200
Message-ID: <20260912065608.204315702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit d2a242e5688a17b79c89cd966cd31820c5096d80 ]

When the HDMI controller is fed by TCON TOP, the port node used to
enumerate the possible CRTCs is never released.

Fixes: 57e23de02f48 ("drm/sun4i: DW HDMI: Expand algorithm for possible crtcs")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/43ffcc17f7c3f94c1d7bd1ee89134c766e84df35.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
index 477cb6985b4d2..25021aadcf6bd 100644
--- a/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
+++ b/drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c
@@ -83,6 +83,8 @@ static u32 sun8i_dw_hdmi_find_possible_crtcs(struct drm_device *drm,
 				of_node_put(remote_port);
 			}
 		}
+
+		of_node_put(port);
 	} else {
 		crtcs = drm_of_find_possible_crtcs(drm, node);
 	}
-- 
2.53.0




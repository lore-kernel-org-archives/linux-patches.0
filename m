Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE614369A;
	Sat, 12 Sep 2026 19:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239698; cv=none; b=Q9oD0XCxu1bXTJIDD4Ip/VDJQWUhPc/BSFq9aV9yccIrvq7xcJD3XBCKZz//GTMelqe8VHNZWK0pec/iFrgCqfuhoqTetN4z5k0Ulp1KH+SlsaG3RSOfa7560urlToy2l+u4psw7yV944y2O9BRd4rETK45o7KKeENGmIlRjwMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239698; c=relaxed/simple;
	bh=wQhEcNeAsxTKZcQj8O6e2YRB/j/0OTX+HEkaVIqNHho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0YxvvKWD9Oq5WXsGt3+y62e/NUnR3WfHmHhH14D6ra6VKR5qq7D6Y/h6bAMeaNvEK6wVjVG8hFjfUSwdr4rfOhHlHSXhBN7UcnIubm9WMfzq0r4ClnkgYczj/dq+nVWrdCdbe2JWaOqxXqMok+KCCtXq0LqVKZynwEFieP+W+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7FLQ1gB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7FLQ1gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784801F00898;
	Sat, 12 Sep 2026 19:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239697;
	bh=GRJVL6djcaRSt8FW7B/YKWdVjyDZZQR5+F+a61Yyhys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7FLQ1gBwoTzm022Lv+6UWjpgJLtCptt/dI+uIwjK3h4juiLr9Lh59mmU0erbVmdx
	 rqlcBzpNMPtzij2qj8kDLKvzjmgAidh8plmvHA2Bz+uJALbHLo9BWxzQJnMFncPKFX
	 PTVeWEv2h7rN2pbn1CYpOsEHojHLtP+LLjfwzwkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 715/935] drm/sun4i: dw-hdmi: Drop TCON TOP port reference
Date: Sat, 12 Sep 2026 09:02:25 +0200
Message-ID: <20260912065543.234286881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 016b877051dab..6cccd580a5b89 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D2147CA76;
	Sat, 12 Sep 2026 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217351; cv=none; b=Un/u6UQF0/6Lb9A06MjPDu5UvBRmWtHaJh6ev2zyMS98J8cNzNvWi2tXatRCoBeuPEhiHIdP8C51fkL3QVzZARsBu0fE3L2z6vRkIYlTQg8fVeO9T4U4lWmkgLe+EAT8JNcCKTpJ8izmAq1Z/zk7mZ+1uXH0JgXjqfEnbj8/3Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217351; c=relaxed/simple;
	bh=4+mfHYllf5E1dWilDTakWJ6n+rqCEsWyoojGtbTfwh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGTFFtbO3SeILcoCGEq5ZS+WWWMwws/p59NfxhzQQO3ckbKaKe7sxIu0bhK3YYekabM3oq/8OhEvwAmuUD9gl0SLT+yx7iCnpPwcheZGr1frY2xGNAc0o5ajB1TcdtDdLxyTLN+AH52uNPyJ9GuGrdnR+Vd//9lkIiP2kX9R9mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy0/d/0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy0/d/0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31061F00893;
	Sat, 12 Sep 2026 12:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217346;
	bh=ay6T9S9wdJJ1AH7rsInpbY8V3r9uDOr0lyhjfLsu4iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy0/d/0KKLbTaU3FaaCXu3GO69RAXm1KEbSWrL1ebkC5XU3czH3clLscuAYuOVRy2
	 0sbs2EpE23IsRXBpGekFsDxjTZuB5K33hS1xG2aWmqURLYoUHAc6xRneW8B0GwOgkk
	 0zLa8gadg5p1wWXKKLJJelSTl25IX4Lr4n8lgjVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0920/1376] drm/sun4i: dw-hdmi: Drop TCON TOP port reference
Date: Sat, 12 Sep 2026 08:55:46 +0200
Message-ID: <20260912065628.070286725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 4727dfaa8fb98..af9be9ba8b96a 100644
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




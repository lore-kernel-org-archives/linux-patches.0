Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A120271464;
	Sat, 12 Sep 2026 08:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202114; cv=none; b=VNPsYVMRD+cO66IdFDxro6b7mnCuncENCxvckASLMhNDGFrr0nSUmo1MaZ9hwPUmxWIO5FNSWcGtc0aejPIcNtwxBY6ckgHkmoMN1kRvgvTnI84aCSRPhyT4YVa64a3obx6XajoeARLB+Z1gyW/8js7yCk7/qdjdYUjwaLQkchw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202114; c=relaxed/simple;
	bh=ehlg4mqAiDQDfQqcUp9DxqcToJBIZ5K48mf51JLovaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXCFGWrRcK+A644cXPivsHouReSRhkI9tjWStdaKpE3GbnAjXVZFzWPG0ZeZvgTrXCsJwQcD9vRB1qnxVnQsa4rT1E24kGWID16Hc1xGUnPYRkKoPCnFRfTRHFVWpRUKMmw8svXlPJBis/H+ANTTEIMSd5WOTP2uJ4aDa+6xxaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MChqmvEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MChqmvEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB65B1F000FF;
	Sat, 12 Sep 2026 08:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202113;
	bh=ADfkS9YrfTBu3GNl/zDafgKglekc8f8JWViVhNZb6pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MChqmvEr7DHHd880HYt71wnBwvlhkG92ObZxU3LF4hG7cSn7VYlVE3Q8HGSJA+CAO
	 lNwI7bto75NK2PEErA3tPdzcx+FC2cksMvl8Y9pbTdsQvoDZ0IvYRAzYRK1LtPJDaB
	 De/pL1+wxp2laCLAIL/pWVf40n1AMRInvINcOcks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1134/1815] drm/sun4i: dw-hdmi: Drop TCON TOP port reference
Date: Sat, 12 Sep 2026 08:48:04 +0200
Message-ID: <20260912065715.641910035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 96532709c2a7e..51cdfa1ae3bf4 100644
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




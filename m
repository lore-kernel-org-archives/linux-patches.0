Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3126F266583;
	Tue,  8 Apr 2025 11:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111010; cv=none; b=O0EAFR1ZNiyQlBIweS4GL/s5RReJn0rapbrtjBTaGCCY6CjMEkTgGbqHnbWJU0rCqQuHldQp8P7drp9pgPvWAa2I5Uc207nEYEEH1yZ+ohhc/c/pPt/aGdq+Mxlr0EaYGOJUzNjbQVx6qkNqzBaRT5hkbs5pCSC+TJImYA8dLSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111010; c=relaxed/simple;
	bh=2zI1WuKWpkmxM8MVfydWx3dC1G1oKgWluDt1uXCEAi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAX/oR4V2llrIMTDqN0dynMZHT16BChnqMvIL61RpbtLf146/QeLKy97x6ngeOWbxVsISZFA+6h58oSPTJcGoKndFItBRfqoq3kK81vF9WEWBxqxOcuIFQEwhNMViyVEa7q5wqZ6UdAIf4Cm1yAXJn9xWs6MwONUXda7fZVycgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipmKZjMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipmKZjMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D1BC4CEE5;
	Tue,  8 Apr 2025 11:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111010;
	bh=2zI1WuKWpkmxM8MVfydWx3dC1G1oKgWluDt1uXCEAi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipmKZjMSP1yCZunGNBqe9ARQvRvTUu6B89CTp6uc6qfm2luCFMW4zH8xsVxobi0aS
	 HRzYrJgHpL6ji12jOG7E170xOnEl1A+j0kmDUT6/g6IkEiKnPoX+c2A4m0vJPOgy/l
	 S9DSsLBxkDuJYHE90oKWv3cadyZjHOG+jmYrdru0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Charles Han <hanchunchao@inspur.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 276/731] drm: xlnx: zynqmp_dpsub: Add NULL check in zynqmp_audio_init
Date: Tue,  8 Apr 2025 12:42:53 +0200
Message-ID: <20250408104920.698017199@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit d0660f9c588a1246a1a543c91a1e3cad910237da ]

devm_kasprintf() calls can return null pointers on failure.
But some return values were not checked in zynqmp_audio_init().

Add NULL check in zynqmp_audio_init(), avoid referencing null
pointers in the subsequent code.

Fixes: 3ec5c1579305 ("drm: xlnx: zynqmp_dpsub: Add DP audio support")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250211102049.6468-1-hanchunchao@inspur.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dp_audio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dp_audio.c b/drivers/gpu/drm/xlnx/zynqmp_dp_audio.c
index fa5f0ace60842..f07ff4eb3a6de 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dp_audio.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp_audio.c
@@ -323,12 +323,16 @@ int zynqmp_audio_init(struct zynqmp_dpsub *dpsub)
 
 	audio->dai_name = devm_kasprintf(dev, GFP_KERNEL,
 					 "%s-dai", dev_name(dev));
+	if (!audio->dai_name)
+		return -ENOMEM;
 
 	for (unsigned int i = 0; i < ZYNQMP_NUM_PCMS; ++i) {
 		audio->link_names[i] = devm_kasprintf(dev, GFP_KERNEL,
 						      "%s-dp-%u", dev_name(dev), i);
 		audio->pcm_names[i] = devm_kasprintf(dev, GFP_KERNEL,
 						     "%s-pcm-%u", dev_name(dev), i);
+		if (!audio->link_names[i] || !audio->pcm_names[i])
+			return -ENOMEM;
 	}
 
 	audio->base = devm_platform_ioremap_resource_byname(pdev, "aud");
-- 
2.39.5




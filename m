Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6601DFFB;
	Thu, 15 Aug 2024 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732618; cv=none; b=b4bez20hkteZB2Rb5NJxUgomxAfhwEGhF97RtQ1eSOQlZaj5+F98+Q6n9akMZNYBi7UjY9bf0zAtZbleXwPS3nD/y4OHHlZGDmk/+8/y8S8Aq2v3jPST50LhGUeW1xEl390cWSls0RBl6R9CK4caKQewjkkqzafiOwub0MblHqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732618; c=relaxed/simple;
	bh=NdmxRZ/Eu87FpZLaQuHLARz523kTFj4vS6NrF1Cmu6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXHJ/33ClRciw3TRd2Vy0OCKy+rFqP3/FT9FEq71n4oh9FEjRaVpCsmpjNhGLjfwfwLh7QjK/Mt5czHtKNt9wpYUYP52UqF9s2R4M+dys0qewcEfMHv4KNvTLHMHXAcLhlopSFp2v3YDMcTfHP4QPSC7hPkqsUeF77O83Yrmqmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrQcuDe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrQcuDe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB78C32786;
	Thu, 15 Aug 2024 14:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732618;
	bh=NdmxRZ/Eu87FpZLaQuHLARz523kTFj4vS6NrF1Cmu6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrQcuDe765WsBVXja256hPuWsJQw0wjYAU7TEASvUewcxEP5kkZ+I42G/vdH58vcq
	 LEcf+CJua5hMii3CId7JYsCsJStANWSbvNcpbe2u+ejiuGinxGDQCmy9/vC6mawoPV
	 krXnFAIXl3NsfqTUFS3UtMgM7BRYnzzOtmrCoScI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/352] drm/vmwgfx: Fix overlay when using Screen Targets
Date: Thu, 15 Aug 2024 15:25:00 +0200
Message-ID: <20240815131928.481191884@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit cb372a505a994cb39aa75acfb8b3bcf94787cf94 ]

This code was never updated to support Screen Targets.
Fixes a bug where Xv playback displays a green screen instead of actual
video contents when 3D acceleration is disabled in the guest.

Fixes: c8261a961ece ("vmwgfx: Major KMS refactoring / cleanup in preparation of screen targets")
Reported-by: Doug Brown <doug@schmorgal.com>
Closes: https://lore.kernel.org/all/bd9cb3c7-90e8-435d-bc28-0e38fee58977@schmorgal.com
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Tested-by: Doug Brown <doug@schmorgal.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240719163627.20888-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
index cd7ed1650d60c..7aa1d9218ea6b 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -98,7 +98,7 @@ static int vmw_overlay_send_put(struct vmw_private *dev_priv,
 {
 	struct vmw_escape_video_flush *flush;
 	size_t fifo_size;
-	bool have_so = (dev_priv->active_display_unit == vmw_du_screen_object);
+	bool have_so = (dev_priv->active_display_unit != vmw_du_legacy);
 	int i, num_items;
 	SVGAGuestPtr ptr;
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A56F1A4F22;
	Thu, 15 Aug 2024 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728827; cv=none; b=A3/kfG3L+/QlrNXTlt8CddbqP2AyLSVRnHVEwEay0Ibj+4cpCiRGwOH25vTEPWXhR4wFLCsBDHHL2x6d2QQVQMISjUk1JhxtlSmUXF9aVQ1kkySxlAvoW8JjZfTD2WiNkN0JPA7FdliIuMUkXDLNbAX3oZgVITUuhoOKhLhVINU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728827; c=relaxed/simple;
	bh=VF8+D0cay2KDJ718iRLPjNZuN/vgHO4zZxv7ZMBkeQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5xq83Nexk6sL2bX8t4sGhrigzmxRoSerOmbL8nh2BQ6sJFQqlaqeSMVejMNbyHjY9+9JT25k+ebEZ8u6jMIYtLOjZuOASb31O3bAM8VLRkZ+hA5Lda47aWt4oyXwuAiEuRQtxZtSm9nQVEGHpe1YwiWSqMxWlbE1PzyqQS0O7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKJIYjB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKJIYjB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D1DC32786;
	Thu, 15 Aug 2024 13:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728827;
	bh=VF8+D0cay2KDJ718iRLPjNZuN/vgHO4zZxv7ZMBkeQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKJIYjB/E2ZamYdBh9cx5H9BLw0ej7Pc9AfhQoBdhfsPl9/0le5+OF3mU0vOxPEhk
	 Ad5YfMN3uOqBg5Xy9t31Dy64J+RPWo0r9rDIxDdzDluGDLtlh1r7Fg5sqwC4Hpqd++
	 0zKr0LiVRK2J5wmTTyfVAnInB/gRLCt3LjQ28grw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/196] drm/vmwgfx: Fix overlay when using Screen Targets
Date: Thu, 15 Aug 2024 15:24:00 +0200
Message-ID: <20240815131856.781589357@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9f1b9d289bec5..5318c949e891a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -100,7 +100,7 @@ static int vmw_overlay_send_put(struct vmw_private *dev_priv,
 {
 	struct vmw_escape_video_flush *flush;
 	size_t fifo_size;
-	bool have_so = (dev_priv->active_display_unit == vmw_du_screen_object);
+	bool have_so = (dev_priv->active_display_unit != vmw_du_legacy);
 	int i, num_items;
 	SVGAGuestPtr ptr;
 
-- 
2.43.0




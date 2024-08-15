Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5619C1AC896;
	Thu, 15 Aug 2024 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731578; cv=none; b=GZaWjXHSTIuV8mtbKKzuCLXQJ3vJbuHzMGjCw88tzYTW6uqOCRlsDD03B+xraIHJuntCbsegW5Up8bEjCI91T0vvhKW0nrt/q+FqSyIf20ggNY7meSglm5CNkivM6KnUAt0k/BHLxelNfybHmwQK1HkOnRIU/L6lQFlXVrV2ETs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731578; c=relaxed/simple;
	bh=rLhK/IYwpkowLg05Sf5Ft79nKcVxqsygNVzSeqa5teo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJ994Z3XMYmxjgKOyz83F6UP3VpApe5XjS/VBqmbE55T+HfI1XN4x8v29hYaByaBXhQX/RLrY5Dmf5nDv2tdeNTN8UOAm1fvNb22YoUDDboidHDT6c2IgmRQxo94AE6dinJ8ZxEvesENBqOwsVX9N33yLLP8dq2rM6FAVipu1cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ifp8Sq36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ifp8Sq36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDB3C32786;
	Thu, 15 Aug 2024 14:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731578;
	bh=rLhK/IYwpkowLg05Sf5Ft79nKcVxqsygNVzSeqa5teo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ifp8Sq364QXxKFEFRjsK4pSr6SjLS8veRL40KBuNRp2rz7lZM1iOTYP6+4mQ2FxOy
	 odS5OOrDgD7dSebDDvGZIotDJNXEFQYLr6LrwCE31IgSJIqROs9uIHQdCMM4thJDfb
	 tonGFbt5nMvRW3+j6Frcbn3A+px7czwXBxjBtnsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/259] drm/vmwgfx: Fix overlay when using Screen Targets
Date: Thu, 15 Aug 2024 15:25:07 +0200
Message-ID: <20240815131909.496655944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fdb52f6d29fb1..395614f2b7bd4 100644
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




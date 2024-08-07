Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D463374CC;
	Wed,  7 Aug 2024 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043634; cv=none; b=IK+kc7LMWNjaIbeDeCr50yxLqacAub0eCcltJ0vf0T7WVRIaxcQoE/SlVO+FqqBeIoeJ5kO7dzywMKsEbtvL8VrmC9N97octQ5esosqgY3znR6dmVROBQ9qGbpKoOIwdzBVcnT514jIEBFI+3+rgLM3AkFBdtkfRuD9iVZFAlz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043634; c=relaxed/simple;
	bh=JHBS1DKQYKwAtikqptGETy5KtRb/9LTgZgoNaSKyLvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzkswK8CO/kJ4OHg5wQsUAARhVF8saWXDca+NIc4Bm/l4j8TaA7xeqKy/kzM+qiVFwqKOg2rnZBixO7ga/gE1nIov56jzINXTNpHtrupX3RbLLm92IkY2L85Hg692XgwTdzC/unTeesqTn0L/Jd5W7UfBKr/2278X7WaNjZ3+DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjsxGmz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjsxGmz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFEDC32781;
	Wed,  7 Aug 2024 15:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043634;
	bh=JHBS1DKQYKwAtikqptGETy5KtRb/9LTgZgoNaSKyLvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VjsxGmz+URCr9lgn2EOWD8q613UfqKdHO3md9qFZOs+Qpsp14fL514QluK2itUP2/
	 1bAaSYCOlIW+1ihLk5WCevcKer86kWuEEl9vcjFiApPInUVZRsxoAtALNeboCIJxE/
	 8aU/h2JKi9dGTc/cNEhaS1es7g8yh9eZDIso+3kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 42/86] drm/vmwgfx: Fix overlay when using Screen Targets
Date: Wed,  7 Aug 2024 17:00:21 +0200
Message-ID: <20240807150040.625329208@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index abc354ead4e8b..5dcddcb59a6f7 100644
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




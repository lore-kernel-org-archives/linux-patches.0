Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290389446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED13C433C7;
	Sun, 13 Aug 2023 21:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962549;
	bh=pebXxjsOATfVtjPeE9bUeOr0E7ezQu/lFJfM9zS5f9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ne6tNUwXSUCzlLM9YAGr96yKfvkGgNYwm2EPXQhfgSUacslIgOUK58LaxpW+QYM8x
	 rDUE35F5YAYwtTzaXoIbqIBUoG7tSaXaqQNx7Xhe1cidAawL4ELy2HTGizVUlnOnmj
	 AasmmdGMYTQZZX+xAzrgtDhNFYhA+G0l1C/gF4Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Skibbe <news@kravcenko.com>,
	Lyude Paul <lyude@redhat.com>,
	Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 6.1 070/149] drm/nouveau/disp: Revert a NULL check inside nouveau_connector_get_modes
Date: Sun, 13 Aug 2023 23:18:35 +0200
Message-ID: <20230813211720.892442469@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karol Herbst <kherbst@redhat.com>

commit d5712cd22b9cf109fded1b7f178f4c1888c8b84b upstream.

The original commit adding that check tried to protect the kenrel against
a potential invalid NULL pointer access.

However we call nouveau_connector_detect_depth once without a native_mode
set on purpose for non LVDS connectors and this broke DP support in a few
cases.

Cc: Olaf Skibbe <news@kravcenko.com>
Cc: Lyude Paul <lyude@redhat.com>
Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/238
Closes: https://gitlab.freedesktop.org/drm/nouveau/-/issues/245
Fixes: 20a2ce87fbaf8 ("drm/nouveau/dp: check for NULL nv_connector->native_mode")
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230805101813.2603989-1-kherbst@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -967,7 +967,7 @@ nouveau_connector_get_modes(struct drm_c
 	/* Determine display colour depth for everything except LVDS now,
 	 * DP requires this before mode_valid() is called.
 	 */
-	if (connector->connector_type != DRM_MODE_CONNECTOR_LVDS && nv_connector->native_mode)
+	if (connector->connector_type != DRM_MODE_CONNECTOR_LVDS)
 		nouveau_connector_detect_depth(connector);
 
 	/* Find the native mode if this is a digital panel, if we didn't



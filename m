Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606EE1A76BE;
	Tue, 30 Jul 2024 17:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360540; cv=none; b=e5tdBuvAm/bL8o3pEEE5eiGjz+ncfR1eYeDykNmJsDzMqP6Jaw/lpuzemUQtLKGz1jZwMcP/tXpRaEIjkRm8q+74zvCtw7Yj+CYVoe0hfYMGsHjAVFxq2XwCakd83kpn8DX9Fl+Q2Go05obRVIqn410RNZKfsoI/1VAYA/4Rnhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360540; c=relaxed/simple;
	bh=yKZ8Ik3wwb7sBetybQx5InbmNRjckitTbArcc530e7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owaBQX3MWuuu0hmCLxkB4qInfPpoy2UNwhTENf177hlTHsbLGWy5/J0NvPbrF7GX/LO7aOezZnRyYe3+8loujz+NHJ0hTnbo2FSlH+2HvBy97IuAnZ9OdlhPG50i3M9uEWZv7T1vO63+OiPOHlwu99NtOaJ+BKPrSytbfUboofM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJPVxAov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJPVxAov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FF0C32782;
	Tue, 30 Jul 2024 17:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360540;
	bh=yKZ8Ik3wwb7sBetybQx5InbmNRjckitTbArcc530e7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJPVxAovGqAr3ei55a+pH2MGFj+LyP/pXgRMRHpwlnpVgFLS6AIbK6lqm4AKdZbUl
	 tr5NFkmWYHUZFz337dsvMDh0DOtvczKXyNK6jLnk/iv7C4iesWtmW3Yk3Qi+UL5psX
	 iu5QGxivizPftn6Bl8+etzO9hg39KlWJQiS55ndk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Robert Tarasov <tutankhamen@chromium.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dave Airlie <airlied@redhat.com>,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.10 700/809] drm/udl: Remove DRM_CONNECTOR_POLL_HPD
Date: Tue, 30 Jul 2024 17:49:36 +0200
Message-ID: <20240730151752.570932060@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 5aed213c7c6c4f5dcb1a3ef146f493f18fe703dc upstream.

DisplayLink devices do not generate hotplug events. Remove the poll
flag DRM_CONNECTOR_POLL_HPD, as it may not be specified together with
DRM_CONNECTOR_POLL_CONNECT or DRM_CONNECTOR_POLL_DISCONNECT.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: afdfc4c6f55f ("drm/udl: Fixed problem with UDL adpater reconnection")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Cc: Robert Tarasov <tutankhamen@chromium.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Sean Paul <sean@poorly.run>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.15+
Link: https://patchwork.freedesktop.org/patch/msgid/20240510154841.11370-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/udl/udl_modeset.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/udl/udl_modeset.c
+++ b/drivers/gpu/drm/udl/udl_modeset.c
@@ -527,8 +527,7 @@ struct drm_connector *udl_connector_init
 
 	drm_connector_helper_add(connector, &udl_connector_helper_funcs);
 
-	connector->polled = DRM_CONNECTOR_POLL_HPD |
-			    DRM_CONNECTOR_POLL_CONNECT |
+	connector->polled = DRM_CONNECTOR_POLL_CONNECT |
 			    DRM_CONNECTOR_POLL_DISCONNECT;
 
 	return connector;



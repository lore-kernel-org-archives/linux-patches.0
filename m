Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C76718454A;
	Tue, 30 Jul 2024 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359394; cv=none; b=CiChV4vOIdanvz/PVouQ/7nr8Jel8DqDPurtj2lWqft1INR16h2CjtCRNLVcAMd8IQtjI3M/85GQHwrUWoFwYtGwWRXQS0tKAp7uh7OlQX5kBerbzvjTMcYm3FUNCsLZ3vH0hQ7QX+95FOGUKtx6SpCp5KlbC1Bj9Q9dMJBz8J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359394; c=relaxed/simple;
	bh=6ZatLLTONHAXV5//fUoCNtw0Wf3ndGgbZNbk/1eMaU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxYmUWQrw5u+x59IMFy37j2zcL6IXB/7Fv4eYY0etI89R1FQgQxRusRepmx4eFfR5Q+NFDRe8rwWCxW63kb55A4mId8bUxjo4MgiKE/+v9Ww0HmAcgi2dPcBDUx83bTO/28e1EvqdCSOTTbHMVz9cjYTx5mv6+GKQg0CM6suykY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNnaoF1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNnaoF1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E524EC4AF0C;
	Tue, 30 Jul 2024 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359394;
	bh=6ZatLLTONHAXV5//fUoCNtw0Wf3ndGgbZNbk/1eMaU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNnaoF1POCMDIFTjY5hXLqD5Zc1sOC+2N87dD+zx4t+3trGAgNhEF3u8pAPfyHq3o
	 1waXIn8myYSV4SWIs42S/wzFyflWqtTpF5AUL5gDvX64B/EbeCWbl4fohmYs8oUJx8
	 f9dd4fl2w7OKvQwzUwkTdic9OtD0q1cNibiMuKjo=
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
Subject: [PATCH 6.6 476/568] drm/udl: Remove DRM_CONNECTOR_POLL_HPD
Date: Tue, 30 Jul 2024 17:49:43 +0200
Message-ID: <20240730151658.630434488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -512,8 +512,7 @@ struct drm_connector *udl_connector_init
 
 	drm_connector_helper_add(connector, &udl_connector_helper_funcs);
 
-	connector->polled = DRM_CONNECTOR_POLL_HPD |
-			    DRM_CONNECTOR_POLL_CONNECT |
+	connector->polled = DRM_CONNECTOR_POLL_CONNECT |
 			    DRM_CONNECTOR_POLL_DISCONNECT;
 
 	return connector;



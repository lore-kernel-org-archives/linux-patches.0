Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F5115B116;
	Mon, 29 Jan 2024 17:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548220; cv=none; b=UCQ41deShBnfA/TA1RAeM7C9LAjvRk5l+kfxKrJfB+PhQ5SAmxqo8JbX1CTP0xdK32F75qOraqLpVNwJFnBBMEsxm6AyKAaHspcMrrnLWqVt02pbWq2lwat249hz/btiMGcPa2833Ojh3PfNt2MyT4Kdi+rTqOxAw5aFpCuGdIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548220; c=relaxed/simple;
	bh=knSS9unA7hc6KA9qC5LWhdCH3De86xvGTTMz/2ncIkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvC7iyvZOXrG8lSSHPLS95edBzvo/JbE8tXEy17Co+RkAvjurr+8re45wSGOZANG2SnjhdHRKkEa4aN5oKdsisyWfVfy/D3NBTTgEogzDpqtPlWIkU0EJaZZQOEY/rb+Iz/3vEW7w93M0yB3G20LcidzzlzE3ppfHpOMsKM8v0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Es44K9Xq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Es44K9Xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9816AC433F1;
	Mon, 29 Jan 2024 17:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548220;
	bh=knSS9unA7hc6KA9qC5LWhdCH3De86xvGTTMz/2ncIkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es44K9XqfWHx735eNI5R/YVZtjnOF7wEw6hX0RDXNWv3Ov4jUcJOjdvshKfZDkH5b
	 +ym4CLpEzMIK4Li7UYisfZ3mwj9DB94W7U3hfAjpw+4+utf/+GId+t/c/RClH3SHzL
	 3aCrG/rncD+a39DHu7/enqjdal0Bfjrw/RaTZvoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Cai Huoqing <cai.huoqing@linux.dev>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@redhat.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Jonathan Corbet <corbet@lwn.net>,
	dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 251/346] drm: Fix TODO list mentioning non-KMS drivers
Date: Mon, 29 Jan 2024 09:04:42 -0800
Message-ID: <20240129170023.799446801@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 9cf5ca1f485cae406968947a92bf304603999fa1 upstream.

Non-KMS drivers have been removed from DRM. Update the TODO list
accordingly.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: a276afc19eec ("drm: Remove some obsolete drm pciids(tdfx, mga, i810, savage, r128, sis, via)")
Cc: Cai Huoqing <cai.huoqing@linux.dev>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.3+
Cc: linux-doc@vger.kernel.org
Reviewed-by: David Airlie <airlied@gmail.com>
Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231122122449.11588-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/gpu/todo.rst |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/Documentation/gpu/todo.rst
+++ b/Documentation/gpu/todo.rst
@@ -337,8 +337,8 @@ connector register/unregister fixes
 
 Level: Intermediate
 
-Remove load/unload callbacks from all non-DRIVER_LEGACY drivers
----------------------------------------------------------------
+Remove load/unload callbacks
+----------------------------
 
 The load/unload callbacks in struct &drm_driver are very much midlayers, plus
 for historical reasons they get the ordering wrong (and we can't fix that)
@@ -347,8 +347,7 @@ between setting up the &drm_driver struc
 - Rework drivers to no longer use the load/unload callbacks, directly coding the
   load/unload sequence into the driver's probe function.
 
-- Once all non-DRIVER_LEGACY drivers are converted, disallow the load/unload
-  callbacks for all modern drivers.
+- Once all drivers are converted, remove the load/unload callbacks.
 
 Contact: Daniel Vetter
 



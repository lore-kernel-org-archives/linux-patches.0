Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07434755FB;
	Mon, 29 Jan 2024 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548597; cv=none; b=rwiiknOhMvI5wVWtKktQl26vkug8Xv6uuKAHMlW5We7eB1SRfZNTF56BuUlYuPu/f02/Tay6+qJ75O93gmv6FoJ9eBo8C2OJRIhYkK9MXvOoc12vgqrwrfCVdCuL0ydplrMM+vk8dHJboPe29ry22rYaEE5YtBIAC11popuNJv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548597; c=relaxed/simple;
	bh=V6fDtlfzT2RPJl1PXwTscg2la3kSRKpaHZq01rncxDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDoOdwcrTgiYT/3sNepj6fQY1zDv5SS88r9wsumMbroXdMPvqgQqqqzdQsFLWX6LUcTgEO32BgFKdOBtK2Vla5vtcS4WVxKU+4r0vz5DR0zTk6H3NEBIkOb7mKupk+FiEMnyFesOb4+0cS1KZo2GIAqxSyLyHUNfi4nxZi5+ynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MapfaUCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MapfaUCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB01DC433C7;
	Mon, 29 Jan 2024 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548596;
	bh=V6fDtlfzT2RPJl1PXwTscg2la3kSRKpaHZq01rncxDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MapfaUCH/zboDEFpxXnXi6fleC2CEnm7XkUZthoHwgrojhOHnKQtmt84BT1DAmosU
	 WXcZMPm5ugpudPkFMotM5N6ZbSLq8QAiQljThlGtyCsQwiT11/oeUR6daU+rXKdYG9
	 Yp0c6RYCB12/ctrl0JTh5KrKrskUjYFgVTaYdGns=
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
Subject: [PATCH 6.6 257/331] drm: Fix TODO list mentioning non-KMS drivers
Date: Mon, 29 Jan 2024 09:05:21 -0800
Message-ID: <20240129170022.408685979@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
 Documentation/gpu/todo.rst | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
index 503d57c75215..41a264bf84ce 100644
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
@@ -347,8 +347,7 @@ between setting up the &drm_driver structure and calling drm_dev_register().
 - Rework drivers to no longer use the load/unload callbacks, directly coding the
   load/unload sequence into the driver's probe function.
 
-- Once all non-DRIVER_LEGACY drivers are converted, disallow the load/unload
-  callbacks for all modern drivers.
+- Once all drivers are converted, remove the load/unload callbacks.
 
 Contact: Daniel Vetter
 
-- 
2.43.0




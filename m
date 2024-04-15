Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE92874C14;
	Mon, 15 Apr 2024 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191386; cv=none; b=gHhhJRJqzf33X91i14sB6/gbjLGvP1YDKpQqW3Iq3ksP5wcxEDZRnQGpD4XRzOcNYy96LFIpOyQvEnCmUU7YkgXWHUF3KdMkXOk0iCYLzR2VjetWlNKWnQuSvcA3TnRTjQpBUeSpUokCeiXVsOnEjb9h4ALF8QQQDt8zVX2KKNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191386; c=relaxed/simple;
	bh=okV89UuBb5/Jw3oaI2fqXBwbEhpTz/d4SvS0ZdjxK6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVwyV8RShYNKO/tsYtU1xp9lzCp9DdHt3humUAmmODtgewZjY43i4d1DsZsvitZH3yOwhJcmNLI81x8X9YmvufQf/N+uekGa1rPyoKfExSIvSiTnVE6zW5izPgc/9a7cvyooAZGcxeuflLZV4baMwsbslUEaMjcfuk5MwacLaeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZRmYqKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZRmYqKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45491C113CC;
	Mon, 15 Apr 2024 14:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191386;
	bh=okV89UuBb5/Jw3oaI2fqXBwbEhpTz/d4SvS0ZdjxK6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZRmYqKiqUqdqGtQ09cuo6sR+EAqA8OMzqKeTBQSG91W2rhcs3a2hyW5uA2t6RuiN
	 vsH77sQM+h8vGBCm9Pp/nlpbD2gKE/Vu6X5KxGqcim4id61NEHs75hDdcn1+u5XUd2
	 VqxaUcLY8/WFodIqnKJXZRUKa/QlotFvMmwCqoGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Vandita Kulkarni <vandita.kulkarni@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 124/172] drm/i915/vrr: Disable VRR when using bigjoiner
Date: Mon, 15 Apr 2024 16:20:23 +0200
Message-ID: <20240415142004.156335079@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit dcd8992e47f13afb5c11a61e8d9c141c35e23751 upstream.

All joined pipes share the same transcoder/timing generator.
Currently we just do the commits per-pipe, which doesn't really
work if we need to change switch between non-VRR and VRR timings
generators on the fly, or even when sending the push to the
transcoder. For now just disable VRR when bigjoiner is needed.

Cc: stable@vger.kernel.org
Tested-by: Vidya Srinivas <vidya.srinivas@intel.com>
Reviewed-by: Vandita Kulkarni <vandita.kulkarni@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404213441.17637-6-ville.syrjala@linux.intel.com
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit f9d5e51db65652dbd8a2102fd7619440e3599fd2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vrr.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -117,6 +117,13 @@ intel_vrr_compute_config(struct intel_cr
 	const struct drm_display_info *info = &connector->base.display_info;
 	int vmin, vmax;
 
+	/*
+	 * FIXME all joined pipes share the same transcoder.
+	 * Need to account for that during VRR toggle/push/etc.
+	 */
+	if (crtc_state->bigjoiner_pipes)
+		return;
+
 	if (adjusted_mode->flags & DRM_MODE_FLAG_INTERLACE)
 		return;
 



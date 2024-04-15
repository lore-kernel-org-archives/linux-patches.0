Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004F88004D;
	Mon, 15 Apr 2024 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713192043; cv=none; b=mNVRAcjP9CkMZJTnIu4i00gA3UsmGqXKyVGuUVQjRbDUjS0Ss7WbY3Da5UHMTMT7g9gHHNYiEdyKXUTyxOOv4bkynh1zNvN9PpL0wsqkJe2zZhXERTtZe/LMigDc0Kh5pUuXCmAlVHtZMXxXxtg6yicj7cQLI7f9EyOGDUnhQUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713192043; c=relaxed/simple;
	bh=mdO3yihjxKbGhmF/J5kcIU76JrvujoGBzJqRX8M5ick=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GpbVpkIAaImBsypiQN5or2h3Jm34q+CAs0rJfotqN80bvVA48BVezdcUAwIYKhGEB6umTFYrUCcJe+GJ8QYZ+nUbAkncqjWahsI/ElQJlwigThCdRq39c9aliLgLP7thRcbYDBppKsM/effm7WjzciftUkFRFxD2MpsAH3gnRSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWNTWizp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWNTWizp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C4CC113CC;
	Mon, 15 Apr 2024 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713192042;
	bh=mdO3yihjxKbGhmF/J5kcIU76JrvujoGBzJqRX8M5ick=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWNTWizpdncCl1nvgTuXxM/D3LdAf6Kq80AvTlSbkmwL7spsXQ0f5RgZIDolVIM9B
	 i6DoTnAM70+UPgpP/ryHbiIlfwVcc2eeGEXAAQEszwS36AOf/rA4k9nS3Jc+74kUSN
	 /1+86N0Rz9uEIb4MkvFMvVNIWcWS1bGF5W6FZQlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Vandita Kulkarni <vandita.kulkarni@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 46/69] drm/i915/vrr: Disable VRR when using bigjoiner
Date: Mon, 15 Apr 2024 16:21:17 +0200
Message-ID: <20240415141947.555054601@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -110,6 +110,13 @@ intel_vrr_compute_config(struct intel_cr
 	if (!intel_vrr_is_capable(connector))
 		return;
 
+	/*
+	 * FIXME all joined pipes share the same transcoder.
+	 * Need to account for that during VRR toggle/push/etc.
+	 */
+	if (crtc_state->bigjoiner_pipes)
+		return;
+
 	if (adjusted_mode->flags & DRM_MODE_FLAG_INTERLACE)
 		return;
 



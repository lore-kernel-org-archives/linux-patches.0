Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16DC2F003B;
	Thu,  3 Jul 2025 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554393; cv=none; b=P3PjYkyCc0bdJu9lbvxhnHIm9FmsMTAJtNxlPEG7COa5QT1Udv0y6M3BsQFJVOuvrLFErM77DKl9ns9yEqslcj7bpgxEix9vdadL6dg1NCDVBWG/P1fekKZsSDIP6GSK5BGtM3CGS8xG5PNAeikYw8l6VhTWg6FA1U9L6+a2EZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554393; c=relaxed/simple;
	bh=3epZ6B9Os9N3vOOfFL7pIlx61OfmhwKYU1XZbxut8Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mmq1yf8BGXExgwlw2L4zLfJSwzX1//Eiu+MxmjqrQVHsJaIjkdNnWCDn7F4/Pod4uOgK4LiwA3ItiRer7PNtkfWMKXvEkLhc/yVWVA5lhkFnIgyeAiSYZLSBXJEVrInh3CpqkqnsMhTCpNVLjrhL1bU8GZCXI4XiD9Mf7L9GVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIdLMFy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIdLMFy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E31CC4CEE3;
	Thu,  3 Jul 2025 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554392;
	bh=3epZ6B9Os9N3vOOfFL7pIlx61OfmhwKYU1XZbxut8Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIdLMFy2cBOdPoY6x19kKqOzCR2jduaWcStdjsdE8QuyKAeMDewxi6T8ZpGP2Upd4
	 QK5wk5cm/QOtNXIuijnzMKP6P444kiou2bPY1z7GUBcBbLAvlParAmdTkWQM3gJQin
	 AhfBNW7MmExwKj5k4vAJF9T5UsC3EBmFuPdm7UoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.12 173/218] drm/i915/dsi: Fix off by one in BXT_MIPI_TRANS_VTOTAL
Date: Thu,  3 Jul 2025 16:42:01 +0200
Message-ID: <20250703144003.088755733@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit c464ce6af332e7c802c36cd337cacf81db05400c upstream.

BXT_MIPI_TRANS_VTOTAL must be programmed with vtotal-1
instead of vtotal. Make it so.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250314150136.22564-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 7b3685c9b38c3097f465efec8b24dbed63258cf6)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/vlv_dsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1059,7 +1059,7 @@ static void bxt_dsi_get_pipe_config(stru
 				              BXT_MIPI_TRANS_VACTIVE(port));
 	adjusted_mode->crtc_vtotal =
 				intel_de_read(display,
-				              BXT_MIPI_TRANS_VTOTAL(port));
+				              BXT_MIPI_TRANS_VTOTAL(port)) + 1;
 
 	hactive = adjusted_mode->crtc_hdisplay;
 	hfp = intel_de_read(display, MIPI_HFP_COUNT(display, port));
@@ -1264,7 +1264,7 @@ static void set_dsi_timings(struct intel
 			intel_de_write(display, BXT_MIPI_TRANS_VACTIVE(port),
 				       adjusted_mode->crtc_vdisplay);
 			intel_de_write(display, BXT_MIPI_TRANS_VTOTAL(port),
-				       adjusted_mode->crtc_vtotal);
+				       adjusted_mode->crtc_vtotal - 1);
 		}
 
 		intel_de_write(display, MIPI_HACTIVE_AREA_COUNT(display, port),



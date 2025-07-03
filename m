Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76ABB1E9B3D;
	Thu,  3 Jul 2025 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555289; cv=none; b=PeIUFHQwFEOLcT97W0NpSQjM/vuZMU8VFJb1bbMvWHXKTH2SkVfdwnlHOU5zwr4gb1ept1h65b5AVgToAjVbDLVYTsgO2hGhoPEZIH7p7kIAPee7Ee0s004icU8LTBABMsfSOnvAGCxZdy8nMp+vjSPhr4GEug3dlSGUkBqfzb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555289; c=relaxed/simple;
	bh=TOasPDQpglf5OwRsaq9DDAC+hEo7gVz0nn+l2fDUH1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RDTNORsuK6ZN7sZSVOuSLAk6jO++DNvGh24xlq7TSOJA6EvaGDYvIhCRzoEtAHzMEkcRsbX4vP0J7ybzaPKKS2gQ9FMQkbZgN41wMUT5owzwHCDJPAl7cvA8hszsH7YKj22wTUybUUwkgmhmJeRWS1mykoQPRWPVf3ijVay+SKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tl/R7SaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tl/R7SaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D804BC4CEED;
	Thu,  3 Jul 2025 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555289;
	bh=TOasPDQpglf5OwRsaq9DDAC+hEo7gVz0nn+l2fDUH1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tl/R7SaK0koitc11b6QO0jSkQNQYOKmp6G9WC0bjGK4jOq18U+tf16jzgYmexfvnr
	 aJNyZnzzEcs7tDFIWS1yOM+p87fHyGM/SDN3pCiUahOIZvQPz2EwfbCuCcJQr8VkO4
	 M72axmWaYACGNOVD8OC/kItcIQuP7ueE4GbU1KmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.15 233/263] drm/i915/dsi: Fix off by one in BXT_MIPI_TRANS_VTOTAL
Date: Thu,  3 Jul 2025 16:42:33 +0200
Message-ID: <20250703144013.738631596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1060,7 +1060,7 @@ static void bxt_dsi_get_pipe_config(stru
 				              BXT_MIPI_TRANS_VACTIVE(port));
 	adjusted_mode->crtc_vtotal =
 				intel_de_read(display,
-				              BXT_MIPI_TRANS_VTOTAL(port));
+				              BXT_MIPI_TRANS_VTOTAL(port)) + 1;
 
 	hactive = adjusted_mode->crtc_hdisplay;
 	hfp = intel_de_read(display, MIPI_HFP_COUNT(display, port));
@@ -1265,7 +1265,7 @@ static void set_dsi_timings(struct intel
 			intel_de_write(display, BXT_MIPI_TRANS_VACTIVE(port),
 				       adjusted_mode->crtc_vdisplay);
 			intel_de_write(display, BXT_MIPI_TRANS_VTOTAL(port),
-				       adjusted_mode->crtc_vtotal);
+				       adjusted_mode->crtc_vtotal - 1);
 		}
 
 		intel_de_write(display, MIPI_HACTIVE_AREA_COUNT(display, port),



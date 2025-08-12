Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F0A3F9D2;
	Tue, 12 Aug 2025 18:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023052; cv=none; b=AqxptYR3pQ/lgb/US5jHx5zk/3wjPU5vVHMQUFbOZoyu2dWHhiOZ7lo4sA825AdaWt9yCeuoQ8a8AnQ959BwG2ExTxoh3MMix+k7DxgxYAm0TBX4CIackpPeL+6LKNh6pxDicrDvGPYnXBcmZyx6+BGFiiwESh3JxNxHeDGVqxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023052; c=relaxed/simple;
	bh=0ZD/DGY1kDanOaAFB5w310dRrl4hfD/NGZRa2Qn9uis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp5nQLFStmXJ6lz5qgPKnh6ABrDB7UiXcvXnW9wdDYtNnY4iEFC2Ki0LSmeYh5CUAPzsTbdUdSwh3lawAKhXjtsIToydpFx4vJuXfV5kUF9HgWxwrVG7Ygbng7/2hXAevraxTECZ1wdrAhTNAQPat747y9Vxgy5h4+qq/wQUW2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpX88eFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpX88eFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B658AC4CEF0;
	Tue, 12 Aug 2025 18:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023052;
	bh=0ZD/DGY1kDanOaAFB5w310dRrl4hfD/NGZRa2Qn9uis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpX88eFuhsClEmHaXPefD5MzhgJ8cW4vGYTa+cwY3+vxR7+P0bo0/Y4PCmXvdGEEu
	 lEqmixeYmxMCCjL7ShLNa2rxc+x0mElYJJrqlHW2f5JO0zO6svx3vGlPyHF8QYknZp
	 NT0K3GYGymzb2lS69XKQFI4XeKW6dZK+ofKOaKJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 336/369] drm/i915/hdmi: propagate errors from intel_hdmi_init_connector()
Date: Tue, 12 Aug 2025 19:30:33 +0200
Message-ID: <20250812173029.343742807@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 7fb56536fa37e23bc291d31c10e575d500f4fda7 upstream.

Propagate errors from intel_hdmi_init_connector() to be able to handle
them at callers. This is similar to intel_dp_init_connector().

Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Closes: https://lore.kernel.org/r/20241031105145.2140590-1-senozhatsky@chromium.org
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/cdaf9e32cc4880c46e120933438c37b4d87be12e.1735568047.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdmi.c |   10 ++++++----
 drivers/gpu/drm/i915/display/intel_hdmi.h |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.c
@@ -3015,7 +3015,7 @@ void intel_infoframe_init(struct intel_d
 	}
 }
 
-void intel_hdmi_init_connector(struct intel_digital_port *dig_port,
+bool intel_hdmi_init_connector(struct intel_digital_port *dig_port,
 			       struct intel_connector *intel_connector)
 {
 	struct intel_display *display = to_intel_display(dig_port);
@@ -3033,17 +3033,17 @@ void intel_hdmi_init_connector(struct in
 		    intel_encoder->base.base.id, intel_encoder->base.name);
 
 	if (DISPLAY_VER(display) < 12 && drm_WARN_ON(dev, port == PORT_A))
-		return;
+		return false;
 
 	if (drm_WARN(dev, dig_port->max_lanes < 4,
 		     "Not enough lanes (%d) for HDMI on [ENCODER:%d:%s]\n",
 		     dig_port->max_lanes, intel_encoder->base.base.id,
 		     intel_encoder->base.name))
-		return;
+		return false;
 
 	ddc_pin = intel_hdmi_ddc_pin(intel_encoder);
 	if (!ddc_pin)
-		return;
+		return false;
 
 	drm_connector_init_with_ddc(dev, connector,
 				    &intel_hdmi_connector_funcs,
@@ -3088,6 +3088,8 @@ void intel_hdmi_init_connector(struct in
 					   &conn_info);
 	if (!intel_hdmi->cec_notifier)
 		drm_dbg_kms(display->drm, "CEC notifier get failed\n");
+
+	return true;
 }
 
 /*
--- a/drivers/gpu/drm/i915/display/intel_hdmi.h
+++ b/drivers/gpu/drm/i915/display/intel_hdmi.h
@@ -22,7 +22,7 @@ struct intel_encoder;
 struct intel_hdmi;
 union hdmi_infoframe;
 
-void intel_hdmi_init_connector(struct intel_digital_port *dig_port,
+bool intel_hdmi_init_connector(struct intel_digital_port *dig_port,
 			       struct intel_connector *intel_connector);
 bool intel_hdmi_compute_has_hdmi_sink(struct intel_encoder *encoder,
 				      const struct intel_crtc_state *crtc_state,



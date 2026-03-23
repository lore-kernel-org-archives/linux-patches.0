Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7DB3AE1AA;
	Mon, 23 Mar 2026 14:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274699; cv=none; b=Fcp9A/EfPlxZMASMzGTLbNvtWXo50YVS5tnb1/PTXTXUcMePZypl/9lQryZjgvQzrHNb1psCIRUomtm9HnT9ZPNiqZ0HBqwEeimwrp/NZ+ebP3FbJqDNMygsHIb5Jnw1fojQPVNqJSapiGTOewkhhD9SpofVDGCxQTK1bOHvWFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274699; c=relaxed/simple;
	bh=JTz7mFkxzcEzIgaMyE9KAjpClGPCE1NDsIEvY2MvCJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MaOGRf0mZelaOV0ph2aY3O8uUCFij9+GhRBEZwDEQXqSniSsyDrJTi6Ul+dmknUnNyQ7Xsb+P+oOEsmVW+cDjEYk4gVtzLeuokQf1uC4HIDHIg6vRUikqSG9XUAx5MY0gPkdqMowVMzvHAGPImI5MzjAfg+LBPqekaTdbRfjFw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1st0fgAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1st0fgAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457B3C4CEF7;
	Mon, 23 Mar 2026 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274698;
	bh=JTz7mFkxzcEzIgaMyE9KAjpClGPCE1NDsIEvY2MvCJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1st0fgAJCeOD2sb13i6dJ+8oGHTeKyaP9LGx3fXIn565auVhmp+zhQXMFZ+0rxgiS
	 ScsxG75951EnEzpV73zu3YSSDMefWmYIXMt4DQRIMSehm8Rr38nkuDIQU3cOXW81Va
	 9QyWUGhzN7m0SKnvNKpI9x70+FwAtnlrWPOGi57E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/212] drm/i915/vrr: Move HAS_VRR() check into intel_vrr_set_transcoder_timings()
Date: Mon, 23 Mar 2026 14:44:18 +0100
Message-ID: <20260323134504.935859405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 78ea8eb5b6235b3ef68fa0fb8ffe0b3b490baf38 ]

Reduce the clutter in hsw_configure_cpu_transcoder() a bit by moving
the HAS_VRR() check into intel_vrr_set_transcoder_timings().

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251020185038.4272-18-ville.syrjala@linux.intel.com
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Stable-dep-of: 237aab549676 ("drm/i915/vrr: Configure VRR timings after enabling TRANS_DDI_FUNC_CTL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    3 +--
 drivers/gpu/drm/i915/display/intel_vrr.c     |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1642,8 +1642,7 @@ static void hsw_configure_cpu_transcoder
 	}
 
 	intel_set_transcoder_timings(crtc_state);
-	if (HAS_VRR(display))
-		intel_vrr_set_transcoder_timings(crtc_state);
+	intel_vrr_set_transcoder_timings(crtc_state);
 
 	if (cpu_transcoder != TRANSCODER_EDP)
 		intel_de_write(display, TRANS_MULT(display, cpu_transcoder),
--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -461,6 +461,9 @@ void intel_vrr_set_transcoder_timings(co
 	struct intel_display *display = to_intel_display(crtc_state);
 	enum transcoder cpu_transcoder = crtc_state->cpu_transcoder;
 
+	if (!HAS_VRR(display))
+		return;
+
 	/*
 	 * This bit seems to have two meanings depending on the platform:
 	 * TGL: generate VRR "safe window" for DSB vblank waits



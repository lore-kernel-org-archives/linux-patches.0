Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692C71EEA3E;
	Wed, 23 Apr 2025 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420806; cv=none; b=i0dYpCDgqWsLODfZRHvDaa71z+maPr1I6/c7uJK9+EhuHafV1x9HA8RIonxC6O9kDXO2RywoIc0s96TAOBO+XyHAASoNANN0ozCJX+JFBQk10GyyGCajOYLjjOIRmk4UFS3zuFwsHfY/u2iTxN9+QJ3o2KcH4QcT1AoJRGQJBms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420806; c=relaxed/simple;
	bh=HyYBx3ZTa1JGr1WpE+eU+g4EdUFwtvaHG5Uud3S3Qx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GxAqVhdKuRXFu52LQj0aYyuayX6ykgAGzK0Y5503kDRfMlHfpnCSgxXCH8dD1x0ctus3Xp788L6pb8+mN5ORJvpS/FqG0yNiZiU5dugRKlWd7HSjD9GdXCYdnGrh1pKXORP8+dL7J8lmmDncuHgTHOWArKBzTdc6iY6v/JgoNMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DayABlNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DayABlNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8378C4CEE2;
	Wed, 23 Apr 2025 15:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420806;
	bh=HyYBx3ZTa1JGr1WpE+eU+g4EdUFwtvaHG5Uud3S3Qx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DayABlNEQ4KML+5jU7UuHmMuI95hvNMJhxg2JmZ6y+mKHRGrKxG8OF9HFrRuuA+QL
	 CmbFXdnlvp4NvJycU/y8bFh2UjLDH/lyK0SpE/qduEDcSa1FB49bhXIyfH2a9BZa4T
	 NK0O1G13s7hlgWNmFQs5bj3mNR0ESJO7NEj8CRoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 164/223] drm/i915/vrr: Add vrr.vsync_{start, end} in vrr_params_changed
Date: Wed, 23 Apr 2025 16:43:56 +0200
Message-ID: <20250423142623.849254978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit a421f5033c82990d795f8fcd30d5b835f8975508 upstream.

Add the missing vrr parameters in vrr_params_changed() helper.
This ensures that changes in vrr.vsync_{start,end} trigger a call to
appropriate helpers to update the VRR registers.

Fixes: e8cd188e91bb ("drm/i915/display: Compute vrr_vsync params")
Cc: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Cc: Arun R Murthy <arun.r.murthy@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.10+
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/r/20250404080540.2059511-1-ankit.k.nautiyal@intel.com
(cherry picked from commit ced5e64f011cb5cd541988442997ceaa7385827e)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1006,7 +1006,9 @@ static bool vrr_params_changed(const str
 		old_crtc_state->vrr.vmin != new_crtc_state->vrr.vmin ||
 		old_crtc_state->vrr.vmax != new_crtc_state->vrr.vmax ||
 		old_crtc_state->vrr.guardband != new_crtc_state->vrr.guardband ||
-		old_crtc_state->vrr.pipeline_full != new_crtc_state->vrr.pipeline_full;
+		old_crtc_state->vrr.pipeline_full != new_crtc_state->vrr.pipeline_full ||
+		old_crtc_state->vrr.vsync_start != new_crtc_state->vrr.vsync_start ||
+		old_crtc_state->vrr.vsync_end != new_crtc_state->vrr.vsync_end;
 }
 
 static bool cmrr_params_changed(const struct intel_crtc_state *old_crtc_state,



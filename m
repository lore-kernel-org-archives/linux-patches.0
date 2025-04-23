Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB52428CF52;
	Wed, 23 Apr 2025 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421431; cv=none; b=Hqcjxg/SBfMAvJqeNIncWR8RvHJ3sjGmbTYVCp8kPw7CpyKmnDrsokUpDhxdPlx3HWTQL4uPpCRfJJwRKVLyzRFsB4JwpIGuAX8pHUsoJiCbMcHnnHtz52AeCT1DQ5LyCrY7DWPBzrbArTo22Yq/i82iaWGhRrFD376I8bNc74M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421431; c=relaxed/simple;
	bh=iSP0vdqPofBRmBIoNOS1hN7vIbKjdUS9iR4dBMzqERg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+VrDaK0lr0k0WKbgT8+6mWzvfIqP3TR8ChEI/yCMX9Ow2Z/v2U6e6T8/VrvHKJpJZ/88Zanewg4fnzZphZbCKfVZho4rBAIl7ZDSSLyW1H1o7phfvjFJFam1LBMHDNkG4GmgnfD8zNPChQBgU7Rvp9OX1eRxC+nWpUa4rKFrI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akgYJeud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akgYJeud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D306C4CEE2;
	Wed, 23 Apr 2025 15:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421431;
	bh=iSP0vdqPofBRmBIoNOS1hN7vIbKjdUS9iR4dBMzqERg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akgYJeudqHN1+zlgB7jntfdFlTdibEyGcm7oQ1cycjc6bv9iCx5/0nd2nCnQCRyS0
	 Oy/TGk1wQB/iXULPf7mrk2wJT923X+QsruLbV7lP9MA1GvezNKdwCPEgCPoCwPzy+M
	 go9ay+hb+GIiG/du0SRjR8oy+SVgTex9QilJkLgY=
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
Subject: [PATCH 6.14 189/241] drm/i915/vrr: Add vrr.vsync_{start, end} in vrr_params_changed
Date: Wed, 23 Apr 2025 16:44:13 +0200
Message-ID: <20250423142628.242347639@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1109,7 +1109,9 @@ static bool vrr_params_changed(const str
 		old_crtc_state->vrr.vmin != new_crtc_state->vrr.vmin ||
 		old_crtc_state->vrr.vmax != new_crtc_state->vrr.vmax ||
 		old_crtc_state->vrr.guardband != new_crtc_state->vrr.guardband ||
-		old_crtc_state->vrr.pipeline_full != new_crtc_state->vrr.pipeline_full;
+		old_crtc_state->vrr.pipeline_full != new_crtc_state->vrr.pipeline_full ||
+		old_crtc_state->vrr.vsync_start != new_crtc_state->vrr.vsync_start ||
+		old_crtc_state->vrr.vsync_end != new_crtc_state->vrr.vsync_end;
 }
 
 static bool cmrr_params_changed(const struct intel_crtc_state *old_crtc_state,



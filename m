Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180A2446AC;
	Mon,  1 Apr 2024 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989006; cv=none; b=WOrBvt3KzxmRvzeC84a1uXbsUfd11cs6VD2rpQYg5bd/CsZob8gENaDNAC+2VA7XZzFPKFvcPe/o8Z+yabdiP7QQW8vZP1nY5EF/qHEUXat2IpS/Y8v22DSfJ4AQWZdeBoFX/ov7TdPserCVvS1Qv6qXLD2+jzS1NUnVjyNZsC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989006; c=relaxed/simple;
	bh=B7TLWi2khtmsYvndfiI6hwKFNcTDLkChNRnP2xR+MKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GdiyU9PQPIKNVk/3myKYUSXLpJ3jAmBDkdwbnd0WD+zhKqS8knGPeuVvoM3j9EprqKg2izvSFjN84Pc2l4lw+FcucUQf0CmGT4FhwGuCuviI+sd6nBBdUzcF1eBfJIGi+pYd9ZW/gCgXBDbxFTzD4t1NMiyPDqFgo2kqEwTBiWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaPitLHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaPitLHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDFFC433C7;
	Mon,  1 Apr 2024 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989006;
	bh=B7TLWi2khtmsYvndfiI6hwKFNcTDLkChNRnP2xR+MKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaPitLHthXIBEx1VJ8lNW6wZOkt4XrPhdN3hNnYRvQUDEeaj6D2/tD38k0Yl3raAA
	 pmy0RJzmbSJXNtRfp5nAJC9PKyXd8cglieEag5xdl4hCLdiOYr6Qh7GAGlJkxM/TaZ
	 p6IPUvgasCAxdh5Z5X/dXNsWYIOwu3bhdnmSnz8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>
Subject: [PATCH 6.7 325/432] drm/i915: Stop printing pipe name as hex
Date: Mon,  1 Apr 2024 17:45:12 +0200
Message-ID: <20240401152602.909109092@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 58046e6cf811464b8a6f269dc6a40a8cb91a8a68 upstream.

Print the pipe name in ascii rather than hex.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231122093137.1509-3-ville.syrjala@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -4534,7 +4534,7 @@ void intel_shared_dpll_state_verify(stru
 				"pll active mismatch (didn't expect pipe %c in active mask (0x%x))\n",
 				pipe_name(crtc->pipe), pll->active_mask);
 		I915_STATE_WARN(i915, pll->state.pipe_mask & pipe_mask,
-				"pll enabled crtcs mismatch (found %x in enabled mask (0x%x))\n",
+				"pll enabled crtcs mismatch (found pipe %c in enabled mask (0x%x))\n",
 				pipe_name(crtc->pipe), pll->state.pipe_mask);
 	}
 }



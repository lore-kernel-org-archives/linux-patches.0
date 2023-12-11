Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC33755C12;
	Mon, 11 Dec 2023 18:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoYK6b2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBD0C433CC;
	Mon, 11 Dec 2023 18:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319706;
	bh=VbGgsFu0kUEeKO0TYgdv/Qji4/P+cs3xXmCFkj6x+sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoYK6b2BkSY0DBFDy0tTiQ43ua3d12q/RDSWFvoS2u8NQ3rwmN0lBiB/EQb2Nv+9k
	 gg777friqZ8bQ0dHj+azrE3qYP2RdSo8xZ1g1enI4G4XKdjHOlPfHRt7vsApOVM0de
	 9wctZppPWUTZfC6n57rU+n7rwl1plzX5P1Vt5VFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 174/244] drm/i915/mst: Reject modes that require the bigjoiner
Date: Mon, 11 Dec 2023 19:21:07 +0100
Message-ID: <20231211182053.729498669@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit dd7eb65c493615fda7d459501c3d4a46e00ea5ba upstream.

We have no bigjoiner support in the MST code, so .mode_valid()
pretending otherwise is just going to result black screens for
users. Reject any mode that needs the joiner.

Cc: stable@vger.kernel.org
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Fixes: d51f25eb479a ("drm/i915: Add DSC support to MST path")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231127145028.4899-3-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 9c058492b16f90bb772cb0dad567e8acc68e155d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -955,6 +955,10 @@ intel_dp_mst_mode_valid_ctx(struct drm_c
 	if (intel_dp_need_bigjoiner(intel_dp, mode->hdisplay, target_clock)) {
 		bigjoiner = true;
 		max_dotclk *= 2;
+
+		/* TODO: add support for bigjoiner */
+		*status = MODE_CLOCK_HIGH;
+		return 0;
 	}
 
 	if (DISPLAY_VER(dev_priv) >= 10 &&



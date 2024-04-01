Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D431CA8F;
	Mon,  1 Apr 2024 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987405; cv=none; b=XRVviE95IxXJWjw/XxY38C/6roN4VYAfultvdf+Mn/OARcy5WJTMbOlBxDnPsLgSXI8Bf/xghup9o2hPvytQ9sOPLK86g9XB5b7Yr2/HiEpNyaMk0pqcZ8BNDfigmHkDCSQ4CqEt/TZ1lxLt61S8JxBEVBWB6IrJf+Anrky4JmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987405; c=relaxed/simple;
	bh=uWeTXXrkWnUbW/m3ugbm6/k3BtT908I373fBrx2TM1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fe8gGsxN59uG7L+X1sOmB4ZC5+yPPuImv2AjRiioIABijXYStS79vl5viprp9z+bpMkQSHmrzwauRvxncF1c4is2Gos1jmQ6uN6LvgRgdeoufBzChRiH41xzRgQV6q+ZFk5T+hhJSx+Bq5aGx47A0rxwid3oBX9kF5A4sLpzc8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtlKR/qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtlKR/qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA12C433F1;
	Mon,  1 Apr 2024 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987405;
	bh=uWeTXXrkWnUbW/m3ugbm6/k3BtT908I373fBrx2TM1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtlKR/qnM4UKCUjOhgJRMEYt2xtgNSFDKSLcH5yE59UejSZTrqIyW1mfvA+86zBGO
	 OPj50DabIWJdenvrVuLTUWC60urMcJ3lEJ7S86OOc0tLgWqTJf70lESRc59ZilSd1G
	 ymuV4xdfakRGmhED9VEMG4l6LxIB1QLTl8CB6ZS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Mika Kahola <mika.kahola@intel.com>
Subject: [PATCH 6.8 278/399] drm/i915: Replace a memset() with zero initialization
Date: Mon,  1 Apr 2024 17:44:04 +0200
Message-ID: <20240401152557.478989607@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

commit 92b47c3b8b242a1f1b73d5c1181d5b678ac1382b upstream.

Declaring a struct and immediately zeroing it with memset()
seems a bit silly to me. Just zero initialize the struct
when declaring it.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231124082735.25470-2-ville.syrjala@linux.intel.com
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -4465,12 +4465,10 @@ verify_single_dpll_state(struct drm_i915
 			 struct intel_crtc *crtc,
 			 const struct intel_crtc_state *new_crtc_state)
 {
-	struct intel_dpll_hw_state dpll_hw_state;
+	struct intel_dpll_hw_state dpll_hw_state = {};
 	u8 pipe_mask;
 	bool active;
 
-	memset(&dpll_hw_state, 0, sizeof(dpll_hw_state));
-
 	drm_dbg_kms(&i915->drm, "%s\n", pll->info->name);
 
 	active = intel_dpll_get_hw_state(i915, pll, &dpll_hw_state);



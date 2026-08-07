Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274C84756A6;
	Fri,  7 Aug 2026 14:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114663; cv=none; b=TUzztveg0iiVMzELHpzWpZ1ircJhN0UAcJQIoxfBHKJxFU9d46VwJ6aZwhdQ/XST3AGLXo77xHiq5mS5/By9eS+UK3HosFu+2hvAEd4NFkj2h9uQV+8RXJI8b29HKFbvivm0jq3TBhrZwg1KA4XNUR3CXC6HjgcJBWhby/4AXX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114663; c=relaxed/simple;
	bh=IZhYLQ56JJDW4PIDvj9SJxRji9q/TXHd2TIhYJ9P1XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJBP8TqQtqej+r26Py5Ea8q6v7uQzcWnGwgsKMmZBBJo4xLTM1GLEMLe0J0czHXaH0FWXNG5T9MMQEr5uvyj4oBO5M9607uJw1OwAdIf3bGwoIjr5r0R6/8q1u3rf37JFZtkk577D16pPTWIdvMCl7UPV8WEXptoUmSv4IaRghk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0T78JLLG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T78JLLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DC01F00A3D;
	Fri,  7 Aug 2026 14:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114662;
	bh=bUCUZu1pG6w1U4tfVx40V439V3fsfPjRxPkJ/NVpqk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0T78JLLGz1FzIXG+6PMy3IH7NpYmQ+hbr8qI6mpAag5P2s6qeC3c27X+WcrwSrkGt
	 Ce6ytpgMIiDSMVjX7sCIpUiZl/nEH3uvu8FqnIPZrf3cmRMW8M4GqmhHO6+VsbRpPb
	 WSq/X9dj/9Oii7jSMaciim86GvaUTeNkJH9mzcDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/337] drm/i915/vrr: Check HAS_VRR() first in intel_vrr_is_capable()
Date: Fri,  7 Aug 2026 16:38:41 +0200
Message-ID: <20260807143425.425780289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 4b274b0b61ab2a529e5c22e9aa033f3028e639fc ]

There's no point in doing all the other checks in
intel_vrr_is_capable() if the platform doesn't support VRR at all
Check HAS_VRR() before wasting time on the other checks.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251020185038.4272-23-ville.syrjala@linux.intel.com
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Stable-dep-of: f8a9262c7a6f ("drm/i915/vrr: require valid min/max vfreq for VRR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vrr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -21,6 +21,9 @@ bool intel_vrr_is_capable(struct intel_c
 	const struct drm_display_info *info = &connector->base.display_info;
 	struct intel_dp *intel_dp;
 
+	if (!HAS_VRR(display))
+		return false;
+
 	/*
 	 * DP Sink is capable of VRR video timings if
 	 * Ignore MSA bit is set in DPCD.
@@ -43,8 +46,7 @@ bool intel_vrr_is_capable(struct intel_c
 		return false;
 	}
 
-	return HAS_VRR(display) &&
-		info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
+	return info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;
 }
 
 bool intel_vrr_is_in_range(struct intel_connector *connector, int vrefresh)



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B326286D69;
	Tue, 27 May 2025 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368688; cv=none; b=W+FQBt2lgQs9D+TBV4PzUZl1sYTHqEWFcCcGW4Nq+aNBxzhKANlMFuNPXRSXVF/f3kadn26t4cVzzitm8fnc1kwtQVZh3XVmlmBnGeX3WKcIwF8gtG6N5IFewIC7cYEfDdE8sPY7Dmgb0ZKQnOfdwsKXfkvgUy0nYRrJWPQVWd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368688; c=relaxed/simple;
	bh=5iJiHPelRUgHXyUdBpsO7OhjmL1Yvs4G9aEu0iUHwTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4B6W6ukaTz8sR10fQ1papcMibyzmG1niWRUJIjNOToO/NrDMmWpzBuLhZqsVkZt2TqFdjbBam7SrEyF9Z1bDBRwkKLzqr4QLUEY3j/J45TPg+pDalqmgp8EJrdqrQSwPLl1QluZuUn1YOmg/Tpx5B6lE/Hq/MCiR/xWKJfEs/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVUkG/Kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVUkG/Kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E31C4CEE9;
	Tue, 27 May 2025 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368687;
	bh=5iJiHPelRUgHXyUdBpsO7OhjmL1Yvs4G9aEu0iUHwTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVUkG/KgBwivnL62lVKRs/EEiOr2Z3CLunIIGE7ua+I63wtY+mL2zRVzTMd3A2U1v
	 y3Db993YoofhBSTgInfJ9EN6LS2Z/ayfMau8HFPmBF7wXXv8dHhsdx6mVpu7W/2rhs
	 NfRgDvPMy0YuIGOmKpBEyEt6P+9l2f68VNEcHOKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.14 777/783] drm/i915/dp: Fix determining SST/MST mode during MTP TU state computation
Date: Tue, 27 May 2025 18:29:34 +0200
Message-ID: <20250527162544.771881142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 732b87a409667a370b87955c518e5d004de740b5 upstream.

Determining the SST/MST mode during state computation must be done based
on the output type stored in the CRTC state, which in turn is set once
based on the modeset connector's SST vs. MST type and will not change as
long as the connector is using the CRTC. OTOH the MST mode indicated by
the given connector's intel_dp::is_mst flag can change independently of
the above output type, based on what sink is at any moment plugged to
the connector.

Fix the state computation accordingly.

Cc: Jani Nikula <jani.nikula@intel.com>
Fixes: f6971d7427c2 ("drm/i915/mst: adapt intel_dp_mtp_tu_compute_config() for 128b/132b SST")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4607
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250507151953.251846-1-imre.deak@intel.com
(cherry picked from commit 0f45696ddb2b901fbf15cb8d2e89767be481d59f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
References: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14218
[Rebased on v6.14.8 and added References link. (Imre)]
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -221,6 +221,7 @@ int intel_dp_mtp_tu_compute_config(struc
 		to_intel_connector(conn_state->connector);
 	const struct drm_display_mode *adjusted_mode =
 		&crtc_state->hw.adjusted_mode;
+	bool is_mst = intel_crtc_has_type(crtc_state, INTEL_OUTPUT_DP_MST);
 	fixed20_12 pbn_div;
 	int bpp, slots = -EINVAL;
 	int dsc_slice_count = 0;
@@ -271,7 +272,7 @@ int intel_dp_mtp_tu_compute_config(struc
 					 link_bpp_x16,
 					 &crtc_state->dp_m_n);
 
-		if (intel_dp->is_mst) {
+		if (is_mst) {
 			int remote_bw_overhead;
 			int remote_tu;
 			fixed20_12 pbn;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDBA1DFD90;
	Wed,  6 Nov 2024 12:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896519; cv=none; b=pBJzrFZhG6Ppx9VHahviHEw5UZ3FkXRyz0KmMczOdN2YDr6gtUntHpMm0tdKzmuk/R1d/hPLUL7ZcGqm3j13L49sVyUK5IKaU5NLmeaM/hdTEZ51EhqaeHHcvgrXE/yiDp0o+djwinu3pRT5fMxCmtbnbVYyvtAfYlwYAVE5dxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896519; c=relaxed/simple;
	bh=BZxL/1w8NeAAXupQuSA55lgzgK0burY+28b44lpkrck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xohv0xyTQBiBW7bs3fGOdwdmGqGSmewy7TnHjq4J8ue2gg6DXVkSDQaHjowq5igRxemxK8tKEM/Zqk2QNefQ+uEsROYjcPsflRKl+AYqOGwX46LTv9Cvo+A05MXRWG1QFPGspqrJLbfVCuYr65mdJ0y5l6Kl57DzIW2Egn5ssHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLupVrnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLupVrnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0777EC4CECD;
	Wed,  6 Nov 2024 12:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896519;
	bh=BZxL/1w8NeAAXupQuSA55lgzgK0burY+28b44lpkrck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLupVrnTRPEliPnR+NWOc1uQ7EtBuHrno/G7yndwTK2Pe9MCgCQ7MPz2xTFc7tDx1
	 PPhNjVDifJb8rKzgI1O9LNgVrW4xZQPO6QecGkhvvCfPKEPACzUqwvVAWEI76KoWez
	 ocIFPFFy5aa4mtc/gRdAKW30oPTszEOl4eYpZuCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 228/245] drm/i915/display/dp: Compute AS SDP when vrr is also enabled
Date: Wed,  6 Nov 2024 13:04:41 +0100
Message-ID: <20241106120324.873113765@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>

commit eb53e5b933b9ff315087305b3dc931af3067d19c upstream.

AS SDP should be computed when VRR timing generator is also enabled.
Correct the compute condition to compute params of Adaptive sync SDP
when VRR timing genrator is enabled along with sink support indication.

--v2:
Modify if condition (Jani).

Fixes: b2013783c445 ("drm/i915/display: Cache adpative sync caps to use it later")
Cc: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Cc: Arun R Murthy <arun.r.murthy@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org
Signed-off-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
(added prefix drm in subject)
Link: https://patchwork.freedesktop.org/patch/msgid/20240730040941.396862-1-mitulkumar.ajitkumar.golani@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -2627,7 +2627,7 @@ static void intel_dp_compute_as_sdp(stru
 	const struct drm_display_mode *adjusted_mode =
 		&crtc_state->hw.adjusted_mode;
 
-	if (!crtc_state->vrr.enable || intel_dp->as_sdp_supported)
+	if (!crtc_state->vrr.enable || !intel_dp->as_sdp_supported)
 		return;
 
 	crtc_state->infoframes.enable |= intel_hdmi_infoframe_enable(DP_SDP_ADAPTIVE_SYNC);



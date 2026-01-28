Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A3336D51E;
	Wed, 28 Jan 2026 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614127; cv=none; b=MT6ADUFIlXm8SBbceIBdkrGyftMOgbb6/EVq7I8+sYyid9mZWuOgtlPTvp5BlubuCsuTVn24FD1zEQs8CDqJOUvhgOHSKqtlXxcE7R9Rhgm/Kq+c6pLb9uNuK+EsGpEpv2RcEMtJwMq1aexolzj8BNthyU1tm554zSoL6fwlgrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614127; c=relaxed/simple;
	bh=loMrjhKUaQcAeLQ5ZMFYZYrkYrUGHceg3Ndgg4nHrvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uh10lXLxneNg+Ynhyuj+X1STvSXfKhu3374USC1+u6hcfKSBl4sOEXTGkxGFEJI/CotRImNlEcNAv+eS5/O21w67u1YTDMTz+QA4eniH4i/iR/PQidWyidFOYrETw2pmhX9qEB3l38nYQDoN0aeUSIwqDGwYET/yZTvjhUY4uKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpopWN/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpopWN/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B435BC4CEF1;
	Wed, 28 Jan 2026 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614127;
	bh=loMrjhKUaQcAeLQ5ZMFYZYrkYrUGHceg3Ndgg4nHrvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpopWN/+kO6trzSgaxqyTHRnvcdnxLgoqqyoioyFHmUos0Ntkfb/80X/pEQKG8lct
	 ZjvWJQ+GebWw2Ow7Ln31LiM2VWGBAYT8mfPN1hw3pm1fCmTPOvoouZ8E9ud1vhIcmo
	 YBWtot0iST1onBVOtBXCdy4ULbF4aMLU1Yw5q0vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.6 044/254] drm/amd/display: Check dce_hwseq before dereferencing it
Date: Wed, 28 Jan 2026 16:20:20 +0100
Message-ID: <20260128145346.287246577@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

commit b669507b637eb6b1aaecf347f193efccc65d756e upstream.

[WHAT]

hws was checked for null earlier in dce110_blank_stream, indicating hws
can be null, and should be checked whenever it is used.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 79db43611ff61280b6de58ce1305e0b2ecf675ad)
Cc: stable@vger.kernel.org
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1228,7 +1228,7 @@ void dce110_blank_stream(struct pipe_ctx
 	struct dce_hwseq *hws = link->dc->hwseq;
 
 	if (link->local_sink && link->local_sink->sink_signal == SIGNAL_TYPE_EDP) {
-		if (!link->skip_implict_edp_power_control)
+		if (!link->skip_implict_edp_power_control && hws)
 			hws->funcs.edp_backlight_control(link, false);
 		link->dc->hwss.set_abm_immediate_disable(pipe_ctx);
 	}



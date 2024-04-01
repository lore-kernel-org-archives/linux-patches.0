Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221D31E86C;
	Mon,  1 Apr 2024 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989062; cv=none; b=M2BWcuhjpd4tD30+AsSd6SohoiPVDg0GyUPyAWYi9dDnsMBbk6x8wHnEPr8qScK7F19pCHSehSnPpbpjmuOe6F+FfeTq7dn2PSDd1bp7Vt4aW+uSCDOVmCCqhAd+9LBH1gCe9HS3hSaVyMBgnkgUJu1wN40uz0wpdVV1FI2/pGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989062; c=relaxed/simple;
	bh=rLkm1DmRrdqhHiZU5pwm5kWJ5Dj8mXcF66COXjPw7Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExzVC1a2g8IRhFLCaE/ZMFhTUSPKBrAQR5LE2vFehAaFujYxfEEbqFXOATZJLTNnJLZoc+iFM68jc58kYTsm/owVWt46s89jrOTrjg2KCu0NQm0BkFkjMT1AjP2W7CHdTcFQ8W798UaJiL2R9IrRjpoXlYwwgpoO+UmDDon2JUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIRN8RkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIRN8RkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670FBC433F1;
	Mon,  1 Apr 2024 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989062;
	bh=rLkm1DmRrdqhHiZU5pwm5kWJ5Dj8mXcF66COXjPw7Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIRN8RkHCReNC/RIBumg1ZQJ5f13gSP1V2DJ8Q3MsE0NS8gGjEW7r/s4sx0HjMF+L
	 tzvvgXt9gqSCNL+rUJZlN78ff24AgHJRwkixGlMSPNJO8UH1D9BDAg//45f9grOH+u
	 wMzf/csxgGa439anjhLt7OTZm9dn6SgnkemPFoxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Xi Liu <xi.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 369/432] drm/amd/display: Set DCN351 BB and IP the same as DCN35
Date: Mon,  1 Apr 2024 17:45:56 +0200
Message-ID: <20240401152604.284506312@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Liu <xi.liu@amd.com>

commit 0ccc2b30f4feadc0b1a282dbcc06e396382e5d74 upstream.

[WHY & HOW]
DCN351 and DCN35 should use the same bounding box and IP settings.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jun Lei <jun.lei@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Xi Liu <xi.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -228,17 +228,13 @@ void dml2_init_socbb_params(struct dml2_
 		break;
 
 	case dml_project_dcn35:
+	case dml_project_dcn351:
 		out->num_chans = 4;
 		out->round_trip_ping_latency_dcfclk_cycles = 106;
 		out->smn_latency_us = 2;
 		out->dispclk_dppclk_vco_speed_mhz = 3600;
 		break;
 
-	case dml_project_dcn351:
-		out->num_chans = 16;
-		out->round_trip_ping_latency_dcfclk_cycles = 1100;
-		out->smn_latency_us = 2;
-		break;
 	}
 	/* ---Overrides if available--- */
 	if (dml2->config.bbox_overrides.dram_num_chan)



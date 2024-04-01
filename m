Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980534776F;
	Mon,  1 Apr 2024 16:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987676; cv=none; b=Ei3/4PqKWrSXM+vCIp0BQTV7YT8/t8/VrNTbWfmv7FfVm7B9ISgTI9wuBlkSn4tjRW+Pfzn2K0qKazkDksPTQKRPDgP1snpJwx/6tnbShflllNRrjNi24avjn6QsNOex+O31UWy/Gj7g9SSoLADoc+xNb6Tpck2NosQ8ISYEw+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987676; c=relaxed/simple;
	bh=DCBj5XhR9MBYu86wxVHAzUq7mCLhHDHfPJD9A6zxdOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMwsna2GRjcOLdNcyO1ODPiOUBkJN5ZKSn4BN/4MwzAvdK1ckJmHWTmf0LVMNQ7r1e5izWk6Ej1K5TjXkEpOTmDKySqUlUXFGXQdPeGAg/iJ7999uoGZvM+6/5JaVH4igtuj2DyixI9DHxzeL2Znc52BYhYLkwh2W5RyeI9lvms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfjhUK8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfjhUK8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5F0C433F1;
	Mon,  1 Apr 2024 16:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987676;
	bh=DCBj5XhR9MBYu86wxVHAzUq7mCLhHDHfPJD9A6zxdOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfjhUK8cEAqZTYXYlBelBLWF8JGzkYKSQf9r0rfpd/W9vg6/Y4olotzIS1atEXRtM
	 wh+t5AthoL8dnKjdjVHR+i3/22SGS0Oo1GQfWbTbJ8vjIx4NBC0pR/ud4Jub10p/sS
	 bNVzCTj/1AkL4aSIkKd33MjzKWLpwvH90vSdFmCo=
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
Subject: [PATCH 6.8 329/399] drm/amd/display: Set DCN351 BB and IP the same as DCN35
Date: Mon,  1 Apr 2024 17:44:55 +0200
Message-ID: <20240401152558.999029290@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

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



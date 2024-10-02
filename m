Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B891CFECF;
	Wed,  2 Oct 2024 13:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876765; cv=none; b=fSEiIK6rLOADA7z8grXqfurZzU9X++4CWE7T7GHAHNnwzl6y9SqQXdF5iB8qDsbGM0nKg5bo5hhb+dJeVKYtsRaoWeP2AZD/Uo60gGvJmh1HtagQOx8NGNT8wdGv3G5DDTWZUI0mkX8fcuRWPSe88MDg0xVRQaeEAlAWmCleUVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876765; c=relaxed/simple;
	bh=ZdS0g+SJQJbnggDwbcvic0MSNAYMuxmDrBoDYFZYKbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HR/lY2rEqc1XC3hzlD7mwiqLMe/ZY+UamIf+eemktfJb3ARe748S8G1XuzdUCSLjPBgIO1Ps5Y3OKo1gIlY5jMlIp1Amqd8ffweo70PXkDk4TXRfX+VPsUmBjQiNk+g8AvzP7qyop5qtOwNcKAH5I9n98+oe8NDYyn2F6ac3zbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h97eqkuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h97eqkuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DA5C4CEC2;
	Wed,  2 Oct 2024 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876765;
	bh=ZdS0g+SJQJbnggDwbcvic0MSNAYMuxmDrBoDYFZYKbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h97eqkuBT0dZKyfQT4yztjbNga8K7Uv6XF2MgOrerMmjHegf7WP1a/WjeZYRI+9lD
	 LloVq8dAfXO46JszSxIPm7yW8DXQXn/XHPglpI+J19JSjoczR4sqI4yKaID2i3srRV
	 ndSRPMitdOfvzrNnyXmcKXrPDg5n+HXizm+63fms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 554/695] drm/amd/display: Block timing sync for different output formats in pmo
Date: Wed,  2 Oct 2024 14:59:12 +0200
Message-ID: <20241002125844.618458032@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Dillon Varone <dillon.varone@amd.com>

commit 0765b2afc1118a6ab5fee624e206c782d70db28a upstream.

[WHY & HOW]
If the output format is different for HDMI TMDS signals, they are not
synchronizable.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_pmo/dml2_pmo_dcn4_fams2.c
@@ -810,9 +810,11 @@ static void build_synchronized_timing_gr
 		/* find synchronizable timing groups */
 		for (j = i + 1; j < display_config->display_config.num_streams; j++) {
 			if (memcmp(master_timing,
-				&display_config->display_config.stream_descriptors[j].timing,
-				sizeof(struct dml2_timing_cfg)) == 0 &&
-				display_config->display_config.stream_descriptors[i].output.output_encoder == display_config->display_config.stream_descriptors[j].output.output_encoder) {
+					&display_config->display_config.stream_descriptors[j].timing,
+					sizeof(struct dml2_timing_cfg)) == 0 &&
+					display_config->display_config.stream_descriptors[i].output.output_encoder == display_config->display_config.stream_descriptors[j].output.output_encoder &&
+					(display_config->display_config.stream_descriptors[i].output.output_encoder != dml2_hdmi || //hdmi requires formats match
+					display_config->display_config.stream_descriptors[i].output.output_format == display_config->display_config.stream_descriptors[j].output.output_format)) {
 				set_bit_in_bitfield(&pmo->scratch.pmo_dcn4.synchronized_timing_group_masks[timing_group_idx], j);
 				set_bit_in_bitfield(&stream_mapped_mask, j);
 			}



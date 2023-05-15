Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA8EFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38F2C433D2;
	Mon, 15 May 2023 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169865;
	bh=QZhYRkOFQiVLrhGHtoI9Hs0G+I1WS7Z++H6m1o4v2zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+nj5ymwtZB5kuksfO243/fuDZ+RhFF72DL9hWCse/I0wabtUOxxBTT9m0DWnFH7i
	 R/QkQKGqGQxh2bWhdPCguTnzjvmV3BM1IC1ckSw/UeT+8UARVjZDCtOqUkZECMyktP
	 +3BqlXzOAbqr51OVoAUroeDuPmGPI49zntew3gJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alan Liu <HaoPing.Liu@amd.com>,
	Leo Chen <sancchen@amd.com>
Subject: [PATCH 6.3 196/246] drm/amd/display: Change default Z8 watermark values
Date: Mon, 15 May 2023 18:26:48 +0200
Message-Id: <20230515161728.494225171@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Chen <sancchen@amd.com>

commit 8f586cc16c1fc3c2202c9d54563db8c7ed365f82 upstream.

[Why & How]
Previous Z8 watermark values were causing flickering and OTC underflow.
Updating Z8 watermark values based on the measurement.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Alan Liu <HaoPing.Liu@amd.com>
Signed-off-by: Leo Chen <sancchen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
@@ -149,8 +149,8 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 	.num_states = 5,
 	.sr_exit_time_us = 16.5,
 	.sr_enter_plus_exit_time_us = 18.5,
-	.sr_exit_z8_time_us = 210.0,
-	.sr_enter_plus_exit_z8_time_us = 310.0,
+	.sr_exit_z8_time_us = 268.0,
+	.sr_enter_plus_exit_z8_time_us = 393.0,
 	.writeback_latency_us = 12.0,
 	.dram_channel_width_bytes = 4,
 	.round_trip_ping_latency_dcfclk_cycles = 106,



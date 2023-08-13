Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582FB9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34B8C433C8;
	Sun, 13 Aug 2023 21:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962183;
	bh=1r+USbZpRoTQdVCPL6SBVDZviZdJRuvBfdZVNV48bPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D50JM3OocpIhahtlq5jb/UAm1J28tRZnFmpEObfTDcZjMqB6UhU2CvUlifJJfsBkT
	 DDYFNz4woRPM+M1YK8OHZC3jbkcnNDofJR4M6khNU/TCItoBF9Mlm/w8hDWGbPBU/z
	 uZEUEB2R88xENNjsd/mgdgIvk2WDWePqAxuMoyyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Mastan.Katragadda@amd.com,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 143/206] drm/amd/display: Dont show stack trace for missing eDP
Date: Sun, 13 Aug 2023 23:18:33 +0200
Message-ID: <20230813211729.127429766@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 7ad1dfc144cbf62702fd07838da8fd8a77921083 upstream.

Some systems are only connected by HDMI or DP, so warning related to
missing eDP is unnecessary.  Downgrade to debug instead.

Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Fixes: 6d9b6dceaa51 ("drm/amd/display: only warn once in dce110_edp_wait_for_hpd_ready()")
Reported-by: Mastan.Katragadda@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -780,7 +780,8 @@ void dce110_edp_wait_for_hpd_ready(
 	dal_gpio_destroy_irq(&hpd);
 
 	/* ensure that the panel is detected */
-	ASSERT(edp_hpd_high);
+	if (!edp_hpd_high)
+		DC_LOG_DC("%s: wait timed out!\n", __func__);
 }
 
 void dce110_edp_power_control(



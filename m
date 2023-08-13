Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEA29446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB52C433C8;
	Sun, 13 Aug 2023 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962445;
	bh=91a//ZPt+Ufn40txO1MRK3Xk6hh7et4Z3OCnk954LOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4Yd4imoUL2JX1ldE8dL0dOA4a5/WxrFPLUCorRRUefQeIJl1KcXXao9CoDXpF60i
	 aYoZNHyeDCT2nnOTLt3Dmrbu0jKze5QnD+6G/2N4v+ODuKfP/VZbH/8TfUCnj8x1rB
	 Nvyhuqjz7ua6l1k9w9DXPZf2eJnOGPeobTlUr7To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Peichen Huang <peichen.huang@amd.com>,
	Mustapha Ghaddar <Mustapha.Ghaddar@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 032/149] drm/amd/display: limit DPIA link rate to HBR3
Date: Sun, 13 Aug 2023 23:17:57 +0200
Message-ID: <20230813211719.767586367@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peichen Huang <peichen.huang@amd.com>

commit 0e69ef6ea82e8eece7d2b2b45a0da9670eaaefff upstream.

[Why]
DPIA doesn't support UHBR, driver should not enable UHBR
for dp tunneling

[How]
limit DPIA link rate to HBR3

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Peichen Huang <peichen.huang@amd.com>
Reviewed-by: Mustapha Ghaddar <Mustapha.Ghaddar@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1141,6 +1141,11 @@ static bool detect_link_and_local_sink(s
 					(link->dpcd_caps.dongle_type !=
 							DISPLAY_DONGLE_DP_HDMI_CONVERTER))
 				converter_disable_audio = true;
+
+			/* limited link rate to HBR3 for DPIA until we implement USB4 V2 */
+			if (link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA &&
+					link->reported_link_cap.link_rate > LINK_RATE_HIGH3)
+				link->reported_link_cap.link_rate = LINK_RATE_HIGH3;
 			break;
 		}
 



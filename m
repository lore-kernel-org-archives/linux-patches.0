Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A894F20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283B6C433C9;
	Fri, 21 Jul 2023 19:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967400;
	bh=eYBUF/c0ZsMmfT8qMCofRWqlpCDcT6ebYA51zt0uao0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLZ43nmIAOiWq4ly0yco8+V5pZtSDIRjr/1dYdjnyi6vX7krYaC3jErgN/WqjagZS
	 vZvaER9QFGD5t6zhte6SFtUrj3UNhONL+ZUYbgAy2N4KFlhvbpUlAbYdI7D/yPuja1
	 qUiJmIIxSbohcYoiYnhRmY8kghzkrAsoeYHs2sTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.ns.wang@amd.com>,
	Marc Rossi <Marc.Rossi@amd.com>,
	Hamza Mahfooz <Hamza.Mahfooz@amd.com>,
	"Tsung-hua (Ryan) Lin" <Tsung-hua.Lin@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 150/223] drm/amd: Disable PSR-SU on Parade 0803 TCON
Date: Fri, 21 Jul 2023 18:06:43 +0200
Message-ID: <20230721160527.266774152@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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

commit 072030b1783056b5de8b0fac5303a5e9dbc6cfde upstream.

A number of users have reported that there are random hangs occurring
caused by PSR-SU specifically on panels that contain the parade 0803
TCON.  Users have been able to work around the issue by disabling PSR
entirely.

To avoid these hangs, disable PSR-SU when this TCON is found.

Cc: stable@vger.kernel.org
Cc: Sean Wang <sean.ns.wang@amd.com>
Cc: Marc Rossi <Marc.Rossi@amd.com>
Cc: Hamza Mahfooz <Hamza.Mahfooz@amd.com>
Suggested-by: Tsung-hua (Ryan) Lin <Tsung-hua.Lin@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2443
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/power/power_helpers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
@@ -816,6 +816,8 @@ bool is_psr_su_specific_panel(struct dc_
 				((dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x08) ||
 				(dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x07)))
 				isPSRSUSupported = false;
+			else if (dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x03)
+				isPSRSUSupported = false;
 			else if (dpcd_caps->psr_info.force_psrsu_cap == 0x1)
 				isPSRSUSupported = true;
 		}



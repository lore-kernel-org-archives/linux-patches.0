Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49948F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB5EC433C8;
	Sun, 16 Jul 2023 19:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537200;
	bh=H3RTGC3DD0ahaWugNBydCwVfi2D0OgnzzpElM7xWMsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AczxdOvq8QGP1q42inWhAzKReV4btBPQlvMaguLAU2ZsunjwrUgpmrDibZmS1P4J8
	 Zjb5S8xyWnC0uF5sMl6DwxnTYZOZ0k/gjBh2Fnj+1T09yS0cGQO4DwU5T4Il0w2KXw
	 Geg+tR6gufpsE08Ex8dfLZxBrUMaJtW8G2puKxRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hersen Wu <hersenxs.wu@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 012/800] Revert "drm/amd/display: edp do not add non-edid timings"
Date: Sun, 16 Jul 2023 21:37:45 +0200
Message-ID: <20230716194949.391486148@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hersen Wu <hersenxs.wu@amd.com>

commit d6149086b45e150c170beaa4546495fd1880724c upstream.

This change causes regression when eDP and external display in mirror
mode. When external display supports low resolution than eDP, use eDP
timing to driver external display may cause corruption on external
display.

This reverts commit e749dd10e5f292061ad63d2b030194bf7d7d452c.

Cc: stable@vger.kernel.org
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2655
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7196,13 +7196,7 @@ static int amdgpu_dm_connector_get_modes
 				drm_add_modes_noedid(connector, 1920, 1080);
 	} else {
 		amdgpu_dm_connector_ddc_get_modes(connector, edid);
-		/* most eDP supports only timings from its edid,
-		 * usually only detailed timings are available
-		 * from eDP edid. timings which are not from edid
-		 * may damage eDP
-		 */
-		if (connector->connector_type != DRM_MODE_CONNECTOR_eDP)
-			amdgpu_dm_connector_add_common_modes(encoder, connector);
+		amdgpu_dm_connector_add_common_modes(encoder, connector);
 		amdgpu_dm_connector_add_freesync_modes(connector, edid);
 	}
 	amdgpu_dm_fbc_init(connector);



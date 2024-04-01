Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12E8C129;
	Mon,  1 Apr 2024 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988551; cv=none; b=kRT3dupNys1e/lG5v7TLzFFzun0p8W3sCA8JWocfjWgIFtQt4gA4xFXw7KZ6Cms7HJw2yJTvHhyC1SFFCEecZVKF4GbjN3qmCq9Oadz5LbtLmGZ1kd0gh5DHpBix7O/CPN6rtN28C8djb0kh0iIg+SdKYQQdUl2N5xnppPpAqc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988551; c=relaxed/simple;
	bh=7ZTjC1aM6TRLqGLagC/ZT8TU1gKPIp5XifsV2xNZ82Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxshCQ8htjueUZcEKOUKTdhPviCP26IBl95YvocVfjQ5Cfnx/5yj/WSMmOrfzmgRB0Db1F+FlqWwM38XujeK+LTA7H/JX2l7oNMdVAe5KPnT3xttRc1uHR2KUEyzdPE/eGMJDNpmAW6h7IaHfI/ZziGfWFj+MwrupxrnPWFIxOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7NlF08t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7NlF08t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CA6C433F1;
	Mon,  1 Apr 2024 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988550;
	bh=7ZTjC1aM6TRLqGLagC/ZT8TU1gKPIp5XifsV2xNZ82Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7NlF08tBYRnWBZvrbPpOiMbmF4SsHlxAGyfp+E7xu2KNBcFEElZMlRIaFM9DQ4DE
	 t5L3V+UA1JTThaAiJV5/s9llX19xLDeg8w9LSV5UHmqOHM8ed1cLzptFQ7aZjpb8MZ
	 hHWDKT/hCI4o5W6EHfQmoAN95kSl9avxI4mEBkDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 218/432] drm/amd/display: Return the correct HDCP error code
Date: Mon,  1 Apr 2024 17:43:25 +0200
Message-ID: <20240401152559.641584634@linuxfoundation.org>
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

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit e64b3f55e458ce7e2087a0051f47edabf74545e7 ]

[WHY & HOW]
If the display is null when creating an HDCP session, return a proper
error code.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
index ee67a35c2a8ed..ff930a71e496a 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -513,6 +513,9 @@ enum mod_hdcp_status mod_hdcp_hdcp2_create_session(struct mod_hdcp *hdcp)
 	hdcp_cmd = (struct ta_hdcp_shared_memory *)psp->hdcp_context.context.mem_context.shared_buf;
 	memset(hdcp_cmd, 0, sizeof(struct ta_hdcp_shared_memory));
 
+	if (!display)
+		return MOD_HDCP_STATUS_DISPLAY_NOT_FOUND;
+
 	hdcp_cmd->in_msg.hdcp2_create_session_v2.display_handle = display->index;
 
 	if (hdcp->connection.link.adjust.hdcp2.force_type == MOD_HDCP_FORCE_TYPE_0)
-- 
2.43.0




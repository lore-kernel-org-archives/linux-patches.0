Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920F6383BA;
	Mon,  1 Apr 2024 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987210; cv=none; b=jsDzg+DWUIbH7Gz/hyn5boY1L9mBWr0WeW+i9LutjoiP+00XtMV441q9aapp/9dKzGk6QYDSBJ7OKCyqB3gtK3WyWTWFPi1ihTMhMb+Xz2FRsbIHpckDdS+V3JwImOB0U9pmXJhItuKWSXMj3FZVxPfZ1WqM5s/EoXB7wQ/tziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987210; c=relaxed/simple;
	bh=PMAylQchcaDmnxGTaKMrt9nwvFdIzKPw87PE+//DQW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF4tGIJWKqHzL6NXQG4KU47b+0yaN5snVPXBFE1eNmbWnyHaYPeKdNdUYycfv4OYZjqABuvdRODl5AiU9lHyPZBJTCwwyk3EMBCg1rpy+Mq5AOXeiV+StG/G6RoCKyxI8OsFiYFzUlTeDryhGYLkmrrpZeEZD8CZvrU2663oUE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p19mv9dX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p19mv9dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195FDC433C7;
	Mon,  1 Apr 2024 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987210;
	bh=PMAylQchcaDmnxGTaKMrt9nwvFdIzKPw87PE+//DQW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p19mv9dXjIImKoTQX9+cI45QrEAYHPyHDyCrEd20Ybs7e1/jtqbQi4SmX0KA1drLE
	 ZI35n8SFriFkAljsbZ+2HFSp3Z+4Qo+BBYoZg0w2rtIDivQ+ZWJiEZeSXLNMFBw8j4
	 BxDI0EE4iULl3A4+/Sjh6GqVGALA/Z8jYklDTJ1s=
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
Subject: [PATCH 6.8 217/399] drm/amd/display: Return the correct HDCP error code
Date: Mon,  1 Apr 2024 17:43:03 +0200
Message-ID: <20240401152555.659691688@linuxfoundation.org>
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
index 8c137d7c032e1..7c9805705fd38 100644
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




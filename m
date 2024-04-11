Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2319146A8D;
	Thu, 11 Apr 2024 10:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831853; cv=none; b=tK9GCZ/fYEi7jhcf29QN1R1rJugfoKS98Z+9SLf3psQD0kbAJHnWpvrZWP1wzljyNgB6x8njVfPdKLDnfrd7xKcOArNMzpFVj3xfbVzlUguQrK7evFeWjFnccb+D6KPBhC2cpq4qYqu2Qgq0GZ+JmGolpQ1eybLtCp1U5CQ21ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831853; c=relaxed/simple;
	bh=brVjRuaB7C0bZzQgyMQQlDUnu+villMKIGZrN79G4B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wjj53TA9cLAzz4rFa5rsIelfuomiAptppWxFpEY4LkDXYpMjeUTiR5UXKF1kPZ5Msv1WNAvkA9fuDu5EtgIQYMiMZSgybvtX/qvCCuRL5gzPM15pUY3ydOAXS2jdgFsjhgBrswL+5n+0X13Hp9ncyQiOfguKNfmmp7u6Xe2X0HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKQSwKq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKQSwKq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319BDC433F1;
	Thu, 11 Apr 2024 10:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831853;
	bh=brVjRuaB7C0bZzQgyMQQlDUnu+villMKIGZrN79G4B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKQSwKq23vsizhWwYcApwRTmyoRQRUqUw3+CI6VQM+7kSc7ozZ/sCGJH+QUiJTJgb
	 V8MH2bFJCBZqfwtj8kX43tfp1g6n0T0wvstTTNnfdzStYwbfpptVHiJwUuyXRfeVZc
	 5+b+f2/9ftLnLKhMvJxHT/Go0y2Tu4GNG6zbKeWk=
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
Subject: [PATCH 5.10 110/294] drm/amd/display: Return the correct HDCP error code
Date: Thu, 11 Apr 2024 11:54:33 +0200
Message-ID: <20240411095438.981465641@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 972f2600f967f..05d96fa681354 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -405,6 +405,9 @@ enum mod_hdcp_status mod_hdcp_hdcp2_create_session(struct mod_hdcp *hdcp)
 	hdcp_cmd = (struct ta_hdcp_shared_memory *)psp->hdcp_context.hdcp_shared_buf;
 	memset(hdcp_cmd, 0, sizeof(struct ta_hdcp_shared_memory));
 
+	if (!display)
+		return MOD_HDCP_STATUS_DISPLAY_NOT_FOUND;
+
 	hdcp_cmd->in_msg.hdcp2_create_session_v2.display_handle = display->index;
 
 	if (hdcp->connection.link.adjust.hdcp2.force_type == MOD_HDCP_FORCE_TYPE_0)
-- 
2.43.0




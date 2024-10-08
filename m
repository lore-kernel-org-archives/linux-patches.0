Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60941DE3AE;
	Tue,  8 Oct 2024 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391328; cv=none; b=cVjAMGU9uYIH8dW+hjzzjarDr6dWWmzRxKUyye4oMdhYP2PFTy2h7vCQ77eQAB7WgBIq5M03Q1k6cKicpMOrzgCvxnJbRk0S8Zf6VA5QvU1l7rptQ7rZlL6LHj9n2OjiSMWcQbt/BH9DdS6QEjI9ZYRthuAngpYShUJSaKo/VSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391328; c=relaxed/simple;
	bh=2mu1epDhXEiszDYWzvOiQPvmtZptUGrVEGs2QGTRWjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6hiN0qS3dHkvLqvfwbgvUY7iS0rsylU1pTGcapTwl3owTJoVBpJYDOrLoNnYL4e9JFvm+DrJkfAbkMpM4dJv9PwbgJpTl6aOtfv1jbJzPYyIPoD1RkoKJReSOt0wr30OCz3b++rr0qXvlB8h6jmZHblv0iwnjxD0bFclnCMCkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPbk5T8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPbk5T8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C417C4CEC7;
	Tue,  8 Oct 2024 12:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391328;
	bh=2mu1epDhXEiszDYWzvOiQPvmtZptUGrVEGs2QGTRWjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPbk5T8viegp7Li5Ec49Tw74aJUeokEE59pXSkQ+GUE29/TJ811FvTbNmSVf15WUC
	 5gRak1OPlujSnMgPRU5yeV7yY9vEHvZFa3z6T53fmZUKgE6bXlEngiWXF7OZ5tUBNx
	 kSehefOuIhp0Hd0iSwLqsfJOAsTYN2kJQw7mWj8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 080/558] drm/amd/display: Disable replay if VRR capability is false
Date: Tue,  8 Oct 2024 14:01:50 +0200
Message-ID: <20241008115705.524525190@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit b68417613d4134b9e39fff95e72ca726268b47db ]

[Why]
The VRR need to be supported for panel replay feature.
If VRR capability is false, panel replay capability also
need to be disabled.

[How]
After update the vrr capability, the panel replay capability
also need to be check if need.

Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 74bb1e0e91348..a705e7fa18c06 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12240,6 +12240,12 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 	if (dm_con_state)
 		dm_con_state->freesync_capable = freesync_capable;
 
+	if (connector->state && amdgpu_dm_connector->dc_link && !freesync_capable &&
+	    amdgpu_dm_connector->dc_link->replay_settings.config.replay_supported) {
+		amdgpu_dm_connector->dc_link->replay_settings.config.replay_supported = false;
+		amdgpu_dm_connector->dc_link->replay_settings.replay_feature_enabled = false;
+	}
+
 	if (connector->vrr_capable_property)
 		drm_connector_set_vrr_capable_property(connector,
 						       freesync_capable);
-- 
2.43.0




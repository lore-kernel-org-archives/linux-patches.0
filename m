Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7991C339709;
	Tue, 11 Nov 2025 01:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823984; cv=none; b=TikNoFu6NKR4v/NR7jWjqMO5LrSOdyc6ZrYlqlQYU+U9/tQwZX6RVFuzb5OSHd2XNFsoKYy4ASsQtus66SqF6YRa33z9eWVYAuF5bZnT/cagWL7ZDVUUjxUaaG1iwUM5qtWnj00fjfHQndFQbkpDl8bj9arP27x74cxT9kN0fsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823984; c=relaxed/simple;
	bh=e/pJrfFVSUK4acv48qgET4pXwB6V6fZBgdQ+88nqSaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+EcUer/+jjLhgnm+7/UdsPAqSNYsuYe6H0REQblkewqgM3Nwj9uhh8MIeWCHX8HUNcZq8x/mVENd4/RQINnqHXQldcALwwFOxd0CNxagOLeNxh95VWpAfmr01lVsiDCxXAPQHxk8rvdQVDJzOS8ABKxoOZ2H5BzCOwWzhQc3vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4pVYPIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4pVYPIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184C4C4CEFB;
	Tue, 11 Nov 2025 01:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823984;
	bh=e/pJrfFVSUK4acv48qgET4pXwB6V6fZBgdQ+88nqSaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4pVYPIFGDQToqyoF5+OQXnrKievN58kXUHiCidZnX/dhhfLnCwLnfy47wHsiB63+
	 WM1vfwxxfaXl2oIxSYKeKP/H/uX6Io/AAzeMKwneGzDrY/MS3dKYJknad4xHq9yprN
	 nb2ClGSOnmHQqRcv7//VHiWyhO6yx9buxS47AIbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 365/565] drm/amd/display: Disable VRR on DCE 6
Date: Tue, 11 Nov 2025 09:43:41 +0900
Message-ID: <20251111004535.080703213@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 043c87d7d56e135393f8aab927148096e2d17589 ]

DCE 6 was not advertised as being able to support VRR,
so let's mark it as unsupported for now.

The VRR implementation in amdgpu_dm depends on the VUPDATE
interrupt which is not registered for DCE 6.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 4 +++-
 drivers/gpu/drm/amd/display/dc/dc_helper.c        | 5 +++++
 drivers/gpu/drm/amd/display/dc/dm_services.h      | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 37307caf92999..ea6bc9517ed86 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10455,6 +10455,8 @@ static void get_freesync_config_for_crtc(
 		} else {
 			config.state = VRR_STATE_INACTIVE;
 		}
+	} else {
+		config.state = VRR_STATE_UNSUPPORTED;
 	}
 out:
 	new_crtc_state->freesync_config = config;
@@ -12357,7 +12359,7 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 
 	dm_con_state = to_dm_connector_state(connector->state);
 
-	if (!adev->dm.freesync_module)
+	if (!adev->dm.freesync_module || !dc_supports_vrr(sink->ctx->dce_version))
 		goto update;
 
 	/* Some eDP panels only have the refresh rate range info in DisplayID */
diff --git a/drivers/gpu/drm/amd/display/dc/dc_helper.c b/drivers/gpu/drm/amd/display/dc/dc_helper.c
index b402be59b2c83..0f333c27787d6 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_helper.c
@@ -747,3 +747,8 @@ char *dce_version_to_string(const int version)
 		return "Unknown";
 	}
 }
+
+bool dc_supports_vrr(const enum dce_version v)
+{
+	return v >= DCE_VERSION_8_0;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dm_services.h b/drivers/gpu/drm/amd/display/dc/dm_services.h
index 9405c47ee2a9a..a7c2740e51b88 100644
--- a/drivers/gpu/drm/amd/display/dc/dm_services.h
+++ b/drivers/gpu/drm/amd/display/dc/dm_services.h
@@ -304,4 +304,6 @@ void dm_dtn_log_end(struct dc_context *ctx,
 
 char *dce_version_to_string(const int version);
 
+bool dc_supports_vrr(const enum dce_version v);
+
 #endif /* __DM_SERVICES_H__ */
-- 
2.51.0




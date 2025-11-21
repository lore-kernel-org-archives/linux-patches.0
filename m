Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D691A00F0;
	Fri, 21 Nov 2025 13:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732771; cv=none; b=tcV41S8yFlzjKdGR7uOQkxrh0Ng52dMYlFnLL1jpVbqFPOXSt8mFJQA121o50l2OM8lAasQ3MJHFajymOznj8gio8Qq2f13TnK9PBzgjmYWVwXGWao2+6jGf3bBQAF4Pa+J4Mrpg229GS3rRqTyXN/jnZ6UERL5O8kdIwrbWtbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732771; c=relaxed/simple;
	bh=8NcDsVwfotTJGAxFdf6tTwPy/KhFbv06HCfCTeSOKds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WRRo6WP5RIWDB9aFMrwZ2OtDsS9O/QMf3o57eyE2koYwQk9DiZWNxeCJQUEFJA/UBW2uGGK3NcDPXHluBr7jNFl3sEPtUvZP8VXBHR4RvxuBkXIZJezQ0sXanuP6vGcQFLETV2WyHhEFrYYDtHYu9HhHf2D8v9eKJ32kyueBSsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ly42quwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ly42quwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A41EC4CEF1;
	Fri, 21 Nov 2025 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732770;
	bh=8NcDsVwfotTJGAxFdf6tTwPy/KhFbv06HCfCTeSOKds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ly42quwBKwGuJWPhJy/nQiA2/Aj+2LzBCkuxYbZCi61YOxaKFLKIa8NwsLkC33MvW
	 O1pmKb4qeyzXiRpd1JUSQstLFWOS+fpOYmFUR1qyrqHKw/ph8kbNDTU4n/Md6jd1jh
	 6DJGPMZXBJsKLx52Mcx4Dw7t4vGRkJp1RGT1JF8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/529] drm/amd/display: Disable VRR on DCE 6
Date: Fri, 21 Nov 2025 14:08:55 +0100
Message-ID: <20251121130239.415476045@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8421e5f0737bf..4ffab762de543 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9243,6 +9243,8 @@ static void get_freesync_config_for_crtc(
 		} else {
 			config.state = VRR_STATE_INACTIVE;
 		}
+	} else {
+		config.state = VRR_STATE_UNSUPPORTED;
 	}
 out:
 	new_crtc_state->freesync_config = config;
@@ -10838,7 +10840,7 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 
 	dm_con_state = to_dm_connector_state(connector->state);
 
-	if (!adev->dm.freesync_module)
+	if (!adev->dm.freesync_module || !dc_supports_vrr(sink->ctx->dce_version))
 		goto update;
 
 	/* Some eDP panels only have the refresh rate range info in DisplayID */
diff --git a/drivers/gpu/drm/amd/display/dc/dc_helper.c b/drivers/gpu/drm/amd/display/dc/dc_helper.c
index 3907eeff560ce..0713a503f7f6d 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_helper.c
@@ -744,3 +744,8 @@ char *dce_version_to_string(const int version)
 		return "Unknown";
 	}
 }
+
+bool dc_supports_vrr(const enum dce_version v)
+{
+	return v >= DCE_VERSION_8_0;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dm_services.h b/drivers/gpu/drm/amd/display/dc/dm_services.h
index d0eed3b4771e6..f2ab2c42781a4 100644
--- a/drivers/gpu/drm/amd/display/dc/dm_services.h
+++ b/drivers/gpu/drm/amd/display/dc/dm_services.h
@@ -294,4 +294,6 @@ void dm_dtn_log_end(struct dc_context *ctx,
 
 char *dce_version_to_string(const int version);
 
+bool dc_supports_vrr(const enum dce_version v);
+
 #endif /* __DM_SERVICES_H__ */
-- 
2.51.0




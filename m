Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE34B20F5AF;
	Tue, 12 Nov 2024 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408337; cv=none; b=VxgnROHfvcr7EVAr8slkTePWgFkqLcDc7QOm6EM/VYKHU9OCTuWQUjDaRZYce9iWaptChzN/Zp7sHDPWNuqKWGi/VsSmb4xKLr/ei+IrjZ69GLw/xmgC8SLajdpmke/C+5O6hojnPPFbKd+L/Cfjp0sRxdS6KsL79iH23uihsCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408337; c=relaxed/simple;
	bh=SMscc8jEikxk+xRScaAO2j43irbgdjfaInDjf5MVlVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geNtBj6loK7nVhg+BcHqgh+AtyWKtv2aPMG1//yKw8U0Y7u3hzsnnalrKzPDNcBiRSWPz3/N+1IDKVxZhTj+dmgiNseVq6RcTWAojhPniqvX8cHKCiKeNm95vPf57WRhy8q8BMiZl2BS/TeGLMGXhtuYGAmXonloDNUQ9/2ZNzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHOZPqr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHOZPqr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C41EC4CECD;
	Tue, 12 Nov 2024 10:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408337;
	bh=SMscc8jEikxk+xRScaAO2j43irbgdjfaInDjf5MVlVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHOZPqr9z/dla1oV6ug5lVFfVSelvizxDEwEhOuBwPQ6Cqb36P2fkiPISVweBR7T7
	 S7E4jMCoMsGU4TRnU18XXnI1qycyjKUUjauJ+u26mYfJV5K+IL6BZy+fvbz9zcz91h
	 HP4SEo0bLQBSWgb8pr6kNoLtFrnZmcqxxeTbcU/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mark Herbert <mark.herbert42@gmail.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 100/184] drm/amd/display: Fix brightness level not retained over reboot
Date: Tue, 12 Nov 2024 11:20:58 +0100
Message-ID: <20241112101904.701424665@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

commit 4f26c95ffc21a91281429ed60180619bae19ae92 upstream.

[Why]
During boot up and resume the DC layer will reset the panel
brightness to fix a flicker issue.

It will cause the dm->actual_brightness is not the current panel
brightness level. (the dm->brightness is the correct panel level)

[How]
Set the backlight level after do the set mode.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Fixes: d9e865826c20 ("drm/amd/display: Simplify brightness initialization")
Reported-by: Mark Herbert <mark.herbert42@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3655
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7875afafba84817b791be6d2282b836695146060)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9384,6 +9384,7 @@ static void amdgpu_dm_commit_streams(str
 	bool mode_set_reset_required = false;
 	u32 i;
 	struct dc_commit_streams_params params = {dc_state->streams, dc_state->stream_count};
+	bool set_backlight_level = false;
 
 	/* Disable writeback */
 	for_each_old_connector_in_state(state, connector, old_con_state, i) {
@@ -9503,6 +9504,7 @@ static void amdgpu_dm_commit_streams(str
 			acrtc->hw_mode = new_crtc_state->mode;
 			crtc->hwmode = new_crtc_state->mode;
 			mode_set_reset_required = true;
+			set_backlight_level = true;
 		} else if (modereset_required(new_crtc_state)) {
 			drm_dbg_atomic(dev,
 				       "Atomic commit: RESET. crtc id %d:[%p]\n",
@@ -9554,6 +9556,19 @@ static void amdgpu_dm_commit_streams(str
 				acrtc->otg_inst = status->primary_otg_inst;
 		}
 	}
+
+	/* During boot up and resume the DC layer will reset the panel brightness
+	 * to fix a flicker issue.
+	 * It will cause the dm->actual_brightness is not the current panel brightness
+	 * level. (the dm->brightness is the correct panel level)
+	 * So we set the backlight level with dm->brightness value after set mode
+	 */
+	if (set_backlight_level) {
+		for (i = 0; i < dm->num_of_edps; i++) {
+			if (dm->backlight_dev[i])
+				amdgpu_dm_backlight_set_level(dm, i, dm->brightness[i]);
+		}
+	}
 }
 
 static void dm_set_writeback(struct amdgpu_display_manager *dm,



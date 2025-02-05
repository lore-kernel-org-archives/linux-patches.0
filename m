Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A0F35946;
	Wed,  5 Feb 2025 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768616; cv=none; b=bSc7hYjCS31/eZAFZftbtQOk0noSKmeZzSzA70lZGgwmBTsQ4e/7vFnRVN+NWKVUval9axFi6y3hueW0Sbb363icmzH/RJpnC3BiDSeNSKU5t0sQDOy0W/ze/M7jFn8fmVdLf3XYBfLyGwA9EVs5un1UUJHaGQS9bQAEcn7A68I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768616; c=relaxed/simple;
	bh=iK9iFceQPpo69oqAssBjdsYdE3WuZolGKBRv31ECQhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw0+g1VAbR1bKa+vC5n0HEG+05//nK2F47FaN3FYJ4Ch+0+hh/QxfTot4/nA4C6HuM5yobrgAaa4Mlgo8Y0hyIhjTDxQLrBj6Kpyno9vkqMCo1WulIzdWhQO2WxMcqvXyCi2XcLssNwm2gWvUQG7WDe5+DaZRPphP5khkxs1J40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acPiiZxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acPiiZxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B3FC4CED1;
	Wed,  5 Feb 2025 15:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768616;
	bh=iK9iFceQPpo69oqAssBjdsYdE3WuZolGKBRv31ECQhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acPiiZxnphaYr/ZVmgLOsd8zQLLCwfkiN4pjLnUc3zgYttfb/TUPN8r6fzB1OjIgS
	 dTj8zFDxpARULviatLoijKi5lLah/uOrujY7mQZGKryKdbd1a1uXXZgS2Art41XCtg
	 IYT4JZjjV9kjlVvRowRQq+T8AHkM11ja3quY8tzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 608/623] drm/amd/display: restore invalid MSA timing check for freesync
Date: Wed,  5 Feb 2025 14:45:50 +0100
Message-ID: <20250205134519.479193170@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

commit 7f2b5237e313e39008a85b33ca94ab503a8fdff9 upstream.

This restores the original behavior that gets min/max freq from EDID and
only set DP/eDP connector as freesync capable if "sink device is capable
of rendering incoming video stream without MSA timing parameters", i.e.,
`allow_invalid_MSA_timing_params` is true. The condition was mistakenly
removed by 0159f88a99c9 ("drm/amd/display: remove redundant freesync
parser for DP").

CC: Mario Limonciello <mario.limonciello@amd.com>
CC: Alex Hung <alex.hung@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3915
Fixes: 0159f88a99c9 ("drm/amd/display: remove redundant freesync parser for DP")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -12227,10 +12227,14 @@ void amdgpu_dm_update_freesync_caps(stru
 
 	if (edid && (sink->sink_signal == SIGNAL_TYPE_DISPLAY_PORT ||
 		     sink->sink_signal == SIGNAL_TYPE_EDP)) {
-		amdgpu_dm_connector->min_vfreq = connector->display_info.monitor_range.min_vfreq;
-		amdgpu_dm_connector->max_vfreq = connector->display_info.monitor_range.max_vfreq;
-		if (amdgpu_dm_connector->max_vfreq - amdgpu_dm_connector->min_vfreq > 10)
-			freesync_capable = true;
+		if (amdgpu_dm_connector->dc_link &&
+		    amdgpu_dm_connector->dc_link->dpcd_caps.allow_invalid_MSA_timing_param) {
+			amdgpu_dm_connector->min_vfreq = connector->display_info.monitor_range.min_vfreq;
+			amdgpu_dm_connector->max_vfreq = connector->display_info.monitor_range.max_vfreq;
+			if (amdgpu_dm_connector->max_vfreq - amdgpu_dm_connector->min_vfreq > 10)
+				freesync_capable = true;
+		}
+
 		parse_amd_vsdb(amdgpu_dm_connector, edid, &vsdb_info);
 
 		if (vsdb_info.replay_mode) {



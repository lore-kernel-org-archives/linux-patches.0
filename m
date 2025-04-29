Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7C62528F1;
	Tue, 29 Apr 2025 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947814; cv=none; b=mzcEyoB4SKh0czvBG581vZclExLbp0PluXKgs7/e9yBAdESNu8frekq8pd88yzyrp0nIBk2SnmEHLOzj20U4mhezlUsp2WRifF0RezAMIyRbzizRgiC/IgHEGwOTaiW6y6RvW0lSPiVoayBje/Eld7DrJ8Sekf4dcnKDnqhu3J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947814; c=relaxed/simple;
	bh=x2RyMzI1D986YTZZqoUTcwssvqSgPRaTlrnG/EUErj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Arf2uMIJeKBZPI/LCLGAGkfrydUJxX4gEdZ5WZ9uWUmTZMWYgxe3/A9mEYbgPGNVmZTLO2ddDmraUME09rzavoHtOZO6b9ddXc+A0JybOQIosoMFfYppaYoCJMXaTpKlVbK1adVi+U+v/qbefp4jTNnYg0CDIcg9PaHbdmTzyg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbWWpIk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbWWpIk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E4AC4CEE9;
	Tue, 29 Apr 2025 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947813;
	bh=x2RyMzI1D986YTZZqoUTcwssvqSgPRaTlrnG/EUErj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbWWpIk3aJH4BeT8xIL0TwZ/CKqyW0Ug4Ni07+d2wU1D+zef3KzXbCt8COe1jTjE/
	 FuZAiOcqirng003L03bSeGveCZZNL7XY25m2vMglx/VH9UpCzmuqeLKViy1B8rFeEX
	 Ib2KXyeUfCQ5uTqiW7+BCm6OEcYQhALhVLEwJCXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <Roman.Li@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 103/280] drm/amd/display: Fix gpu reset in multidisplay config
Date: Tue, 29 Apr 2025 18:40:44 +0200
Message-ID: <20250429161119.325402207@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <Roman.Li@amd.com>

commit 7eb287beeb60be1e4437be2b4e4e9f0da89aab97 upstream.

[Why]
The indexing of stream_status in dm_gpureset_commit_state() is incorrect.
That leads to asserts in multi-display configuration after gpu reset.

[How]
Adjust the indexing logic to align stream_status with surface_updates.

Fixes: cdaae8371aa9 ("drm/amd/display: Handle GPU reset for DC block")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3808
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d91bc901398741d317d9b55c59ca949d4bc7394b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3216,16 +3216,16 @@ static void dm_gpureset_commit_state(str
 	for (k = 0; k < dc_state->stream_count; k++) {
 		bundle->stream_update.stream = dc_state->streams[k];
 
-		for (m = 0; m < dc_state->stream_status->plane_count; m++) {
+		for (m = 0; m < dc_state->stream_status[k].plane_count; m++) {
 			bundle->surface_updates[m].surface =
-				dc_state->stream_status->plane_states[m];
+				dc_state->stream_status[k].plane_states[m];
 			bundle->surface_updates[m].surface->force_full_update =
 				true;
 		}
 
 		update_planes_and_stream_adapter(dm->dc,
 					 UPDATE_TYPE_FULL,
-					 dc_state->stream_status->plane_count,
+					 dc_state->stream_status[k].plane_count,
 					 dc_state->streams[k],
 					 &bundle->stream_update,
 					 bundle->surface_updates);



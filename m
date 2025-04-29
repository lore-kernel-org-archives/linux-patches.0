Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84462AE72;
	Tue, 29 Apr 2025 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950377; cv=none; b=GgsYP9k8suTWNm8ThTNB6YEKwEDRkBSjQoFh0Mnp/JQjYerTuN30i5avu5cxZFKw9W3v3KW98obhFeqQflId0mFoMxRW24KXwD76Ps+SpWIBBaRbZntmb93aYkriqvk7S3wJvcL/SoBIo1myfVpo4MkrSIHUFGGsc4jc9ouiGwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950377; c=relaxed/simple;
	bh=/w0oL5tcdQUz5UDxDJ/sAaWWgecYXl4F4VgAawLNbic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkXvrBXWuWhL9LPopeZ4kn9x9W9U5LfiUSj8oGkPc+smuBQN0cRif6l3go/LZOcMzooA+amtpSRl1F7z8H2cHSAnffdfujjBzD76IrQ0X4jv2rVwsbm14wdtnrNjiqs8DpDKm+6M5pA03TO7C59GVI2DjDrHNtT8u9Dy8EhYbvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6kGRD5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6kGRD5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC80C4CEE3;
	Tue, 29 Apr 2025 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950377;
	bh=/w0oL5tcdQUz5UDxDJ/sAaWWgecYXl4F4VgAawLNbic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6kGRD5cweW6nRSrCsA35U/sxVZtj4mDwOSNIWT0N4JAVnNRBSKm5a/xUZvgJ9T5M
	 J9o7FnveWFZvZU34qBn94EW4Q6RgVEdzfvwVW2l5G6v7a+hod00UcAGgeWHizvek6e
	 f2RrP2FkdsJxjkPe5Ffzc1EtbJDsRxqwyLTPs+qI=
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
Subject: [PATCH 6.6 077/204] drm/amd/display: Fix gpu reset in multidisplay config
Date: Tue, 29 Apr 2025 18:42:45 +0200
Message-ID: <20250429161102.573814403@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2789,16 +2789,16 @@ static void dm_gpureset_commit_state(str
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



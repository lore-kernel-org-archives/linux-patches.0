Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED39D21885A;
	Mon,  2 Jun 2025 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874239; cv=none; b=nBrA7XRf6f5T+mcfUqixg9yFb2kp5UPCeRB95cTDla1ZwzbK9h+rfTN26yqmlKRHm6HDugdDq1140K8DAKfKGA2l7haLh4eCTh7tuTN680cJjZj9TQZXGABYUhy9Gh4mU3tSvfs+wFApsE6B+uKzKBqHNs8kA5PQnl8m5QRnfRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874239; c=relaxed/simple;
	bh=VSGw4N0Ts4uDetnSFA3kTDzhqU/fux07fywHlVBWvV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LphTVeRyzqUejwHF9ZbsWQS/il2d/Yi+1YBDRUCLvMPsPboXGZUFD3eh7ow4BxZrjXK3Pk3ON9QikZy4L6Noq+d9K7GZ2S3f4ZHvaszEHDk1lP/73c/nx7nW9nnmgQ6AcN7AHKTRdAdKzs4mnY+PFfezWo2HHjK9Z6RToX6Qw4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1GKJUZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1GKJUZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C58C4CEEB;
	Mon,  2 Jun 2025 14:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874238;
	bh=VSGw4N0Ts4uDetnSFA3kTDzhqU/fux07fywHlVBWvV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1GKJUZZdMycNDtvm4k3qOxwOsxihQnY5YqKfe23jOLEg/iXC+hHZj+HWLRLE9C9s
	 0dviSEvTQnr8cHacfj0ueJynkH5OXOa7j3y6XSx8yNScpLbMBDXafkWFP0al5Swl+X
	 bmAa5i72Yvv2Yb/JYbR84HJfdw0IDCaKrHpBwNd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.6 374/444] Revert "drm/amd: Keep display off while going into S4"
Date: Mon,  2 Jun 2025 15:47:18 +0200
Message-ID: <20250602134356.096885647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 7e7cb7a13c81073d38a10fa7b450d23712281ec4 upstream.

commit 68bfdc8dc0a1a ("drm/amd: Keep display off while going into S4")
attempted to keep displays off during the S4 sequence by not resuming
display IP.  This however leads to hangs because DRM clients such as the
console can try to access registers and cause a hang.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4155
Fixes: 68bfdc8dc0a1a ("drm/amd: Keep display off while going into S4")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250522141328.115095-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e485502c37b097b0bd773baa7e2741bf7bd2909a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2896,11 +2896,6 @@ static int dm_resume(void *handle)
 
 		return 0;
 	}
-
-	/* leave display off for S4 sequence */
-	if (adev->in_s4)
-		return 0;
-
 	/* Recreate dc_state - DC invalidates it when setting power state to S3. */
 	dc_release_state(dm_state->context);
 	dm_state->context = dc_create_state(dm->dc);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EDD27FD56;
	Tue, 27 May 2025 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366108; cv=none; b=vGFs3Oyg58c2JIzFjjw1zdYzXmqzGAOjUWT4ca8Y7a5YSQEI92fD5cgSaqFNkljoIGUcqc6KE/TMGXqnqRvpxq+EKgZGZdGvIbMXTv2baeBsxXw5vX+AuDT9izq+0RugcfxLPfpmVrcK1f3rvEyudtxHm9eEDHCB3tbWMkmIbEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366108; c=relaxed/simple;
	bh=L5rBkIUED+QetMllYozeegCxtFDBxF/PLgDfkRm9WAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/6/v9iJlheW8cckdMSZKCK3lqLY8ize2Pa5vdGxCdPy1ixYKqG4XiaItsI9YdhLqrajsxDXt3UyBr9Z2AO8MVy8ZZoyStALjL+TSUljw36e9ecp0wEQEI8ZRWs0BhkjX53/seRVsZ5HXv72RnCfYwmrhxa9Xz7XYhMtrAhaAWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nC6ftEn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nC6ftEn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DE6C4CEE9;
	Tue, 27 May 2025 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366108;
	bh=L5rBkIUED+QetMllYozeegCxtFDBxF/PLgDfkRm9WAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nC6ftEn4fCRpUd1+Z2qUDzZxHqy52suTMd4kL/x6l8Y2v+9C6WQN2Jdh8hWgFeHyz
	 xAk6ojqwy5LsoWezxUKr0yu5pLremKsNiy9PEqDhPjSFJ7dFqCHdd/v+IAQCW2pcma
	 4xnGrQ/kb8vudZTC2xtigbXUtMaG73QZe5fxTKLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.12 594/626] Revert "drm/amd: Keep display off while going into S4"
Date: Tue, 27 May 2025 18:28:07 +0200
Message-ID: <20250527162509.129400092@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
@@ -3315,11 +3315,6 @@ static int dm_resume(void *handle)
 
 		return 0;
 	}
-
-	/* leave display off for S4 sequence */
-	if (adev->in_s4)
-		return 0;
-
 	/* Recreate dc_state - DC invalidates it when setting power state to S3. */
 	dc_state_release(dm_state->context);
 	dm_state->context = dc_state_create(dm->dc, NULL);



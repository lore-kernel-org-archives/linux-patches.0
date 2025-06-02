Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F41224224;
	Mon,  2 Jun 2025 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877389; cv=none; b=Watc8zGAgFOcNOUKhibpwaOsApnZanT3H843Ab5Byp3Gf+8sYpG7aknw8+HVGjc0I9qjIqbjsE7iUofPndIALMIynf/kOSyZfWROMtz27RcqMd+yr7M1QkgachlflM07mx/ZZOUMfrlh+asD/7H+uVWLQTAPPaUK+ME4/l03KRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877389; c=relaxed/simple;
	bh=moIp7wOLUdd9rtNpz/i8lVlkwo9LIlxNwCPjPJd+9CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp1CHWApGRVVhdrvfxrFPmmkZ4vX6noKNfwTsSBMcgslaDziNqU+K/pHEWVzySfSsC3RgxIkXlc/Df/dPj1ZaCgEuAIVJPUvALL6zJW3F+MYczHj5iAAxBHDeFYqMb08j9uGsXzU9ZTHm6ds/wOQ586/BwoPHw+mtFreQvQNTjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPsnmGik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPsnmGik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BCDC4CEF2;
	Mon,  2 Jun 2025 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877388;
	bh=moIp7wOLUdd9rtNpz/i8lVlkwo9LIlxNwCPjPJd+9CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPsnmGik1lXounqTpjJCxkoZu8PnjV9XsRa8etulsv8stJi6aoYYbvo02WTjNpIbw
	 jN8Ux4aGK6jMfPz0SXfatvNvdV+Mlz/ce/XIaK5hg/I9qgOpSyJ19j2qqyFpgaI0Fh
	 JhEyiq6sPH2yF8skvBn4XMzCrdZgG/qQePNelKFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 262/325] Revert "drm/amd: Keep display off while going into S4"
Date: Mon,  2 Jun 2025 15:48:58 +0200
Message-ID: <20250602134330.420733077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2897,11 +2897,6 @@ static int dm_resume(void *handle)
 
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



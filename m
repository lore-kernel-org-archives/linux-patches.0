Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54622D7A6;
	Mon,  2 Jun 2025 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876452; cv=none; b=BTKr76529FBvkz8fYpkYB8TB38QMW7m/fc5Ihh7qiaZ0Bcrycl891+SmADRK5jYKNVpvS2Ke/eUADWS0CvILUnHSdkkzmaHXZ6hPkqTc14amnLi+SECkta+eh4s3qn2wvcqqxYdwu8MkDTcBL8h0ZMf7Fv1BLCXA7DVgtKZL8PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876452; c=relaxed/simple;
	bh=NgY+Z61aNq7zZnj+BfstfYALfteYCftCY3l7rcGIjNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYM/6qYMfj+78fXWnKUugSsLh/Ox7VK2mnyGgeTVFLzbzz5wUy+4f11NXORh7Ihx+4LRGjptUyTeIDtR1UR0noz/Ima0XVaHeAUVi8Jv+GM2mY/9MVV0aGHXUXH22QUlWf47ClCkn3ojQk5r4U69Gtlor9/z8OLIO4qklVlm7DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXw/vm3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXw/vm3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71227C4CEEB;
	Mon,  2 Jun 2025 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876451;
	bh=NgY+Z61aNq7zZnj+BfstfYALfteYCftCY3l7rcGIjNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXw/vm3FVpOcEySJFntlnU7lk9RNQcgkXqtpAEvuOjn4dy3U4CJVgLrHgaUIEzLLR
	 R3Z886ww2SXf8MQzZYLAlUWK8ibB5tHTtit0DoH59+Vh3FdwA8mvgeMy6R5FGGMhes
	 08szHhlT1sATgr9/4OlnhMLAvMs9HbXJQVz9f1Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 178/207] Revert "drm/amd: Keep display off while going into S4"
Date: Mon,  2 Jun 2025 15:49:10 +0200
Message-ID: <20250602134305.722730262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2710,11 +2710,6 @@ static int dm_resume(void *handle)
 
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023C42F24;
	Mon, 23 Jun 2025 13:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685593; cv=none; b=S/f2JES8Rnhw4/LYJ59gwbez1jgYRugNWLlHD+QmHY/h3OaTWp+/JAWYOEjbBCflFp1eWtMJ0lbic3OU6WDSxQBz4o4JZTZoImPVyCGUp1zijcHsOY+ocNdaUuaoqKx3/A/ZvUIQ1fnrC5w57M8ZIY1nTztknZ7nNqafcwf46KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685593; c=relaxed/simple;
	bh=1U4rVCPky5l1zbURoxAea1/jR+54aE2k3PgWrW0N/4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKO2bkJRezJEVl9CGf31zkiAPy+tdh+oPdymIbfOgX5r+M2d8YxfRx+LPguuS94VpRVV3FI4il5nh0IrgcusPIEFt+/gHC7HgKhDHjqj1pE5QgKXMygj80ZGrfxtSl0VDwFyNYFSIWcEGXVPbnC4ocTlbQOANpu+R7hjGNrTNXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvJW3m+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvJW3m+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B72DC4CEF0;
	Mon, 23 Jun 2025 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685592;
	bh=1U4rVCPky5l1zbURoxAea1/jR+54aE2k3PgWrW0N/4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvJW3m+3JitYA00MLTEbgKJpfzdYdyL+2HjbeW6RfqJOq+0wb39p5qbnbSSrsGfUL
	 AhC8i9ACmNfh2d8Bj349u91AmrdtL+FFntOk+uSQWs/g5ylcsDkBsh4VULGoDFemeB
	 SzunqxUsuixkQSO5wApagLZ5a3YXaVVXnvQOXm0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 236/592] drm/amdgpu/gfx6: fix CSIB handling
Date: Mon, 23 Jun 2025 15:03:14 +0200
Message-ID: <20250623130705.901727001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 8307ebc15c1ea98a8a0b7837af1faa6c01514577 ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
index 13fbee46417af..cee2cf47112c9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c
@@ -2874,8 +2874,6 @@ static void gfx_v6_0_get_csb_buffer(struct amdgpu_device *adev,
 				buffer[count++] = cpu_to_le32(ext->reg_index - 0xa000);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5




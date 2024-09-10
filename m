Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF07919308E;
	Tue, 10 Sep 2024 10:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962896; cv=none; b=VYgLf/mvYsOu1/y97R6SvF56CazAGmknb8HW9Bo56Ecx5b/MUy833kPVk7Of/lYQGR6XydsxGwaoD0DUID3IoKtfV3C3X6JXjstQudkyVqJBexQHpeFjqPBm29e5XrvP7YsE1HLy2FNCLOsCizQ7CqFLOcL5h9XdDPXilxiDBB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962896; c=relaxed/simple;
	bh=hHEYz3eJFDuXIWGm/n/EaFNJUhdQH2VTC2XCM0kcs5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1hMFprU9qg6F0UD3eMgQLKir4RQ9RgJPp4cd5ANnw7CPMwmqoUoAdMkQTOY3FGvJI0ovlM97zc+HO1KoZg3SqTLN5F9Q6TJfylkMc6GKlbFbetPKq0zZ5Tiq6tQ2XFlC2FRu7tKcOyqpqzheNj5mDz2u46nvxklqwM5fNoZt0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLqHMtLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLqHMtLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728E5C4CEC3;
	Tue, 10 Sep 2024 10:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962895;
	bh=hHEYz3eJFDuXIWGm/n/EaFNJUhdQH2VTC2XCM0kcs5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLqHMtLp9zth3Cd1x28t49peaKTNlqgFCk2JjBPJDYqCGcl13I3OLXvLUYvr0VgC2
	 CDkA6c3griKNf/sPRlr//+8HHS+kaVrz6IcUPvTGm7JC2wWSIA7CYhIz8RYAnTPkNU
	 1nnfMotci1wxKj7J4OcOJXr4B9c1ygmYRY9weQy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/192] drm/amd/display: Check denominator pbn_div before used
Date: Tue, 10 Sep 2024 11:31:30 +0200
Message-ID: <20240910092600.719870874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 116a678f3a9abc24f5c9d2525b7393d18d9eb58e ]

[WHAT & HOW]
A denominator cannot be 0, and is checked before used.

This fixes 1 DIVIDE_BY_ZERO issue reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0be1a1149a3f..393e32259a77 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6767,7 +6767,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 			}
 		}
 
-		if (j == dc_state->stream_count)
+		if (j == dc_state->stream_count || pbn_div == 0)
 			continue;
 
 		slot_num = DIV_ROUND_UP(pbn, pbn_div);
-- 
2.43.0




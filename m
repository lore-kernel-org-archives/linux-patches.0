Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383293314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301204; cv=none; b=PIsyaW0mZD4ZKq/jvjpiGNdrUpEiM1hWK6j/S94KcsNSilNDS1Bi53xH+89TXfF+lig08hGWXdt939V3vehhraJUoESD2QFlfBDYqaXRj2x8X0bryH3PRYyCaPnqtzjhS1akfW0si+TLqBhG2SOs/7kMHny6xUT5bT0HN2WThsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301204; c=relaxed/simple;
	bh=rEpXLyVDrzzOFUtl7osHPgiCeRax5DjfGlL7uqRCjNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFQVdyKJAx5lyXIQYvbD3pNLKwXNqchh2Z7p8EXro4dxWq3Sr9Trwor42LSQoVOQ/3WwFIYj5C1WeAqb5asBcgTz13+zU+9M9UQzVezIfvq5YusFkiklFkePhJEus4mNesxskw1yfXE146pnvQrp0goYYCaZB+cmFbEVhB+fToc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcazLgCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcazLgCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFF8C116D0;
	Sat, 28 Feb 2026 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301204;
	bh=rEpXLyVDrzzOFUtl7osHPgiCeRax5DjfGlL7uqRCjNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcazLgCZY1tOe550JKhEpf6/lc80mcsd9Io6VcwxTO7hQ3VzJCLxfVo5DKvMoQ44y
	 nq38IbpC3wRj3qLXu2PfurqjzRK+0haegbeT4zrQXEmfD3E9qE3j1KLCmV7Jz7sWDZ
	 c1JulXyEbJHiCd8hUAAtlrIyA4uI91iqXdAXqn+eIpmkq66/g+7v50q8pSyMHOl1HE
	 492KAuuPXT896gs+9GxkZo4DQGiliPGGNQO9sBM115dCht0NprLL8GnjJ253r0WbQd
	 1hRCIZH2oxaiZcIR7UfApcqg+BKJYCIB86voeYOJ5ofFZmYTqCCel/84Bw1BxSAcU5
	 XZxrk2df7F6nQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Wayne Lin <Wayne.Lin@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 377/752] drm/amd/display: Avoid updating surface with the same surface under MPO
Date: Sat, 28 Feb 2026 12:41:28 -0500
Message-ID: <20260228174750.1542406-377-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Wayne Lin <Wayne.Lin@amd.com>

[ Upstream commit 1a38ded4bc8ac09fd029ec656b1e2c98cc0d238c ]

[Why & How]
Although it's dummy updates of surface update for committing stream
updates, we should not have dummy_updates[j].surface all indicating
to the same surface under multiple surfaces case. Otherwise,
copy_surface_update_to_plane() in update_planes_and_stream_state()
will update to the same surface only.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index c8415a2840567..7db2d1a3784bd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10724,7 +10724,7 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 			continue;
 		}
 		for (j = 0; j < status->plane_count; j++)
-			dummy_updates[j].surface = status->plane_states[0];
+			dummy_updates[j].surface = status->plane_states[j];
 
 		sort(dummy_updates, status->plane_count,
 		     sizeof(*dummy_updates), dm_plane_layer_index_cmp, NULL);
-- 
2.51.0


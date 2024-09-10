Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFFF17BEAD;
	Tue, 10 Sep 2024 10:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964258; cv=none; b=jIjYkIJ+HnIXMM0DRooEznNUVUdLuJnAH//5+2oncdoy5Bymqed0gWS8dsyHK6AbP/7U1nWF9jW6ECJ4BJNXN2ikgibZYDDiGEJZBMC8xW9jbh4n7bz36sdBs1qhX/R3YlSMe0GtCMfdDpBTXCkLV251wN5UrBL9QAhZrabY9qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964258; c=relaxed/simple;
	bh=K6dGNg+dGOe4KxJIGneD24U+KrzDF4fKIOl4BhvmYxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtQ0nvZGrp8ki3on3qd4WmQEzUfC6dPDTry9GYEcwRFKWN/QD15DZ+lpoexCs2hg6Sp7csVOfvc4pFcCPhabr88Ota71ghp2MjRF6pj+htHAopm3ldext/hcrryS86IUAGYXKLqLTzcRuYn4+qgtWJl2ketbxvKCV6xRhCwe6Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXoClQJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXoClQJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DA9C4CEC3;
	Tue, 10 Sep 2024 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964258;
	bh=K6dGNg+dGOe4KxJIGneD24U+KrzDF4fKIOl4BhvmYxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXoClQJhtP52FciZlctEEVlkMHidYGXu/hYFiI7oo6sNZDm/2bBSqHEWrrN5L/kyF
	 QpBjTCmzrgwviUcbmPlDksxhQuLwgp7l+gw3y7zj5MgmpzA8+0aeKQi7+1gxn11jvG
	 yu3XQkx5oSH1o1kdLV6zPF+qgxnZX5dQBKwshNrs=
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
Subject: [PATCH 6.6 094/269] drm/amd/display: Check denominator pbn_div before used
Date: Tue, 10 Sep 2024 11:31:21 +0200
Message-ID: <20240910092611.559619329@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 44c155683824..f0ebf686b06f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6937,7 +6937,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 			}
 		}
 
-		if (j == dc_state->stream_count)
+		if (j == dc_state->stream_count || pbn_div == 0)
 			continue;
 
 		slot_num = DIV_ROUND_UP(pbn, pbn_div);
-- 
2.43.0




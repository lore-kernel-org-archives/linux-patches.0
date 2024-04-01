Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D555E383BA;
	Mon,  1 Apr 2024 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987213; cv=none; b=VtxlfJGiv4m7oRc7aykKHcsDen9PONiVI1yR5BTl+CI5cGcVHqvQ3XuVNZJh5SiKUYX8jo5hojf1MaW2B18RqSG4yPXjTT0mRZg00MgpluFzbVbE6BBD7hg1yKvfuw3J94gKNOMUnbf4zNsOlbBT3T5EQfNPBh4teKZw51jWFaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987213; c=relaxed/simple;
	bh=eekFva2wKXS7yzevAD4aTEtWjOQ6Km1y047lvrv+szI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAGM0A8L4O+BGgx5wCNoNlf/4+IzwiNDuwvugxtwncO6Ugg0xsx6UMsFsnu9OXAssN/74ocgAkwDPOlQXFe63LUzu4VQayvBIA/QhPS47SQFon1uX6ewD1h2g0oDaaCNS3A9yViaRs9a4vmiMRZh0DxsyXjhS9mCgwY0+kucEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhSOTKdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhSOTKdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5ECC433C7;
	Mon,  1 Apr 2024 16:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987213;
	bh=eekFva2wKXS7yzevAD4aTEtWjOQ6Km1y047lvrv+szI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhSOTKdbwVDD6aFdZOdp3iEaH8zM+9ddH4qH1m8sXIWeHsF5NzMdpNd38awl61wvJ
	 Xhut00Yug0KJ+2f6XD3X5DDsoutkAsX8TjK4ubTbM1pjcG24z0MLM9eCMeREVlJsqT
	 bkHghXurxF8w+b0gVeeHP9JCNNYE3d1ykBtC5u5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Allen Pan <allen.pan@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 218/399] drm/amd/display: Add a dc_state NULL check in dc_state_release
Date: Mon,  1 Apr 2024 17:43:04 +0200
Message-ID: <20240401152555.689253910@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Pan <allen.pan@amd.com>

[ Upstream commit 334b56cea5d9df5989be6cf1a5898114fa70ad98 ]

[How]
Check wheather state is NULL before releasing it.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Allen Pan <allen.pan@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_state.c b/drivers/gpu/drm/amd/display/dc/core/dc_state.c
index 180ac47868c22..5cc7f8da209c5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_state.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_state.c
@@ -334,7 +334,8 @@ static void dc_state_free(struct kref *kref)
 
 void dc_state_release(struct dc_state *state)
 {
-	kref_put(&state->refcount, dc_state_free);
+	if (state != NULL)
+		kref_put(&state->refcount, dc_state_free);
 }
 /*
  * dc_state_add_stream() - Add a new dc_stream_state to a dc_state.
-- 
2.43.0




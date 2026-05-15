Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E104F3B9D84;
	Fri, 15 May 2026 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861504; cv=none; b=B5Nv81wJqYL6cjjE6bxLdy9vyOQaDG3799BcBJWITFd+AyxyWWBaZzXH8f5VcGE+YZEtf/LP5tV8ewfQ5lc9qjK58EtXpa3ez2NRQ9TnOifzlHGE4ziT7JogWe4skIjKSiq9dK2/lZqdUE46cn1mTTaPMaPS/usSKw1XggBVsCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861504; c=relaxed/simple;
	bh=Yg6udlmUaymaKtO04LMJ+SDXgJYhutIUgAf+YtXQnTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gr28sikSSVRFKTSfsAhbUBhK8+KwaEYDF+f5+GoBm9S3vNzKElDm1lwVcQZadTsK6yieFvWvG8JIaQMyoOG1hhxMELG5S5ad8SNO7CGumwutChT3s8llp0bjrmaxNyQqI20SYB/VN6/qDuGaFuSxQQ3sVKxxMRHqAriAkwTF6RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDFlMau1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDFlMau1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F9EC2BCB0;
	Fri, 15 May 2026 16:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861503;
	bh=Yg6udlmUaymaKtO04LMJ+SDXgJYhutIUgAf+YtXQnTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDFlMau1pAUi0St9XgBbwSMaeYSCINAbK9qOcT8W4yPlooZ91Ib9qgOD7lzr/fo0j
	 5ItGGLs2HtnDFcQoYzKwdyUIVgD1Hj7u+mDgcuMgVg0ykz2h0HLJ/HbhLCsMaB49GR
	 gddQ/RM6Bj4MpbjLzhoofbaMXo6540ZcWpJlppv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 354/474] drm/amdgpu/pm: align Hawaii mclk workaround with radeon
Date: Fri, 15 May 2026 17:47:43 +0200
Message-ID: <20260515154722.676839166@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 1987c79b4fe5789dfa14423e78b5c25f6acf3e9d upstream.

Align the hawaii mclk workaround with radeon and windows.

Link: https://gitlab.freedesktop.org/drm/amd/-/work_items/1816
Fixes: 9f4b35411cfe ("drm/amd/powerplay: add CI asics support to smumgr (v3)")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9649528b637f668c5af9f2b83ca4ad8576ae2121)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/smumgr/ci_smumgr.c
@@ -1329,10 +1329,10 @@ static int ci_populate_all_memory_levels
 	if ((dpm_table->mclk_table.count >= 2) &&
 	    ((dev_id == 0x67B0) ||  (dev_id == 0x67B1)) &&
 	    (adev->pdev->revision == 0)) {
-		smu_data->smc_state_table.MemoryLevel[1].MinVddci =
-				smu_data->smc_state_table.MemoryLevel[0].MinVddci;
-		smu_data->smc_state_table.MemoryLevel[1].MinMvdd =
-				smu_data->smc_state_table.MemoryLevel[0].MinMvdd;
+		smu_data->smc_state_table.MemoryLevel[1].MinVddc =
+				smu_data->smc_state_table.MemoryLevel[0].MinVddc;
+		smu_data->smc_state_table.MemoryLevel[1].MinVddcPhases =
+				smu_data->smc_state_table.MemoryLevel[0].MinVddcPhases;
 	}
 	smu_data->smc_state_table.MemoryLevel[0].ActivityLevel = 0x1F;
 	CONVERT_FROM_HOST_TO_SMC_US(smu_data->smc_state_table.MemoryLevel[0].ActivityLevel);



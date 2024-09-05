Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47797156225;
	Thu,  5 Sep 2024 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530195; cv=none; b=TgGCY4yLBUvaW3KtZgLWpNm8yQEEAurmuCAPPcjfrl43+FUvl4FVr0dC+WVg/+2tY9Y7HKTjU0RCyeDIJAxp8OH0kyFnNn2NeHnMjgWciKoDVs5yiEgNFtQcm6CU7OTOnZL6gf/NZM9Vro2pDGzFPezJgHv+BpTP0mYALH6VjnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530195; c=relaxed/simple;
	bh=uLXFQdtXHhwaaAvE9oSqu/sofyZ6FxsyYKVp5CNyQM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdftdSFZG/8eDS4poIvuCuSwVaq0o5GRtPsLljtmAIm4iXwW5I/qMO/HOSSKK0uqkL/aUDmjizXEvyH8A7XV79sPxknn9oTGJEbb7V9YKSqpCExIwMDJNQVMzFb5V27+FXmcuPfzAzkHLAlqnkNzpl4vjyz30N3Uz7lBdVT3jXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1SqGv2E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1SqGv2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1325C4CEC3;
	Thu,  5 Sep 2024 09:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530195;
	bh=uLXFQdtXHhwaaAvE9oSqu/sofyZ6FxsyYKVp5CNyQM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1SqGv2E0UitUT8f/Rg8V47RPIMRfRDhuDJd39wkl5DuS4EalT8uI7to0GAh4vmGp
	 I3RGx7jEypzc6zM4EmOEC8lTHjOa21j1lMB8J0drfrDLu6ea3QLBHIMHFgpo9iodwD
	 ZIyi9LIrUMxxN9Y2UnQ/psxt3iFa0C4iB9jZ8RL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/132] drm/amd/pm: check specific index for smu13
Date: Thu,  5 Sep 2024 11:41:10 +0200
Message-ID: <20240905093725.478336145@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit a3ac9d1c9751f00026c2d98b802ec8a98626c3ed ]

Check for specific indexes that may be invalid values.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index be4b7b64f878..44c5f8585f1e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -2058,6 +2058,8 @@ static int smu_v13_0_6_mode2_reset(struct smu_context *smu)
 
 	index = smu_cmn_to_asic_specific_index(smu, CMN2ASIC_MAPPING_MSG,
 					       SMU_MSG_GfxDeviceDriverReset);
+	if (index < 0)
+		return index;
 
 	mutex_lock(&smu->message_lock);
 
-- 
2.43.0




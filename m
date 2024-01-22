Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106016BB44;
	Tue, 23 Jan 2024 02:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975365; cv=none; b=Rq54mQy9qPKOD0QyLtIV8aUVJk6i8wx70UOIMXscVTSPIT8NSvgSFEtMtSyt4JZFAQrqahc0kBOUuMeg/dzF+C4Sjqlr73NiGyf9o3+7gofMD0UvChJINpP7tGcl+oVL5PufZXaKVAwnXuIi1ncvhg9zFSwazqBdAgVHpsVNNTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975365; c=relaxed/simple;
	bh=aU5kX4TSPwKHFzPTMvnnWyIq4gTXbdGq0QubJJp5w4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H/GuR+quTneaPLshsAV5hJ6PYWMLaPTO6oZW6fJ9tTBFMUucyf7KSmjQAmkRZm7XE+0Q4ulqSGtLkG9IAjpI8lanpO5Q4Zf+hPQuizs0dqcAiYE2ObWWJ4PpYdUVMV24r7vtxRSNyouYV0R770v3F/ygAJzAGu/SNyn7AoAM6yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lj9KM8ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lj9KM8ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD866C43390;
	Tue, 23 Jan 2024 02:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975364;
	bh=aU5kX4TSPwKHFzPTMvnnWyIq4gTXbdGq0QubJJp5w4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj9KM8ny7h0ASYooIfEM3Nrrlfp0O/n4SbYCjGk+DgzRYiI96qmHlYw7dm0h7+Yw9
	 4XfsL+YdNarwyen91saMaag9Zfy4RHPY403CAVLH2oPN5VYHpZM49oK+jbYJscCUWF
	 QAOEOzi0wb2XL/idqrhTg+jr7UefkE/v7VvstqDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 326/583] drm/amdkfd: Fix type of dbg_flags in struct kfd_process
Date: Mon, 22 Jan 2024 15:56:17 -0800
Message-ID: <20240122235822.028403397@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 217e85f97031791fb48a2d374c7bdcf439365b21 ]

dbg_flags looks to be defined with incorrect data type; to process
multiple debug flag options, and hence defined dbg_flags as u32.

Fixes the below:

drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_packet_manager_v9.c:117 pm_map_process_aldebaran() warn: maybe use && instead of &

Fixes: 0de4ec9a0353 ("drm/amdgpu: prepare map process for multi-process debug devices")
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index df7a5cdb8693..3287a3961395 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -971,7 +971,7 @@ struct kfd_process {
 	struct work_struct debug_event_workarea;
 
 	/* Tracks debug per-vmid request for debug flags */
-	bool dbg_flags;
+	u32 dbg_flags;
 
 	atomic_t poison;
 	/* Queues are in paused stated because we are in the process of doing a CRIU checkpoint */
-- 
2.43.0




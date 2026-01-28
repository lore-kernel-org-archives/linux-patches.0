Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5B31D6AA;
	Wed, 28 Jan 2026 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615990; cv=none; b=Dx+IsfNNknV5Zuk32f3m5guE+ImBOJhjSCwc6BbqsrPZqlW4fbKBK4liTewNV0StpgtXE7lJCYDCCH5riYJKvbU6zJ95p7jQKg0sU1osD8Ih0/nt6OTKMMLzc5hsb6OzuLuvPNQ6nRg+9Upo8/YeFkwvVCNTTZ4vXFJDtiXEwnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615990; c=relaxed/simple;
	bh=8YEpHmLx1ou1Sqvf4GRRFeEVKk7FR6e3BPryNnfGApo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJjRb5ZMSmqwAr75/nEDDJmdSq09eTOmGDv+6mPyx4mCcRX0onE6RmK8G4UmibcIsmnZx5xasV7KHnYKF10Do/vdeSeDf7prvJrNfE62CNxBUyzbQb8dC5rRxBLyFoeiZNYvFcriOB63e3w5qNbyo2WinGkSMA+9dY3zGjOdF2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRF1wOSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRF1wOSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194C4C4CEF1;
	Wed, 28 Jan 2026 15:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615990;
	bh=8YEpHmLx1ou1Sqvf4GRRFeEVKk7FR6e3BPryNnfGApo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRF1wOSE7+kp2W6040nSyPWEgiCQSCdhKRUFX8QKvXg2khg28jI2DcN+0EmFu+2vM
	 MeeGeelyY+e2B6YHSYh2f7hqS1r6imeaBAjgc7FmrWO3eQX0rzcqGCmtTJogQicD4R
	 LS3QG1fOcuuaqifQdsnXPoePU2TtSztp+l37rVss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/227] drm/amdgpu: fix type for wptr in ring backup
Date: Wed, 28 Jan 2026 16:22:57 +0100
Message-ID: <20260128145349.210087499@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 095ca815174e51fc0049771712d5455cabd7231e ]

Needs to be a u64.

Fixes: 77cc0da39c7c ("drm/amdgpu: track ring state associated with a fence")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 56fff1941abd3ca3b6f394979614ca7972552f7f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 18a7829122d24..89a639044d520 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -804,7 +804,7 @@ void amdgpu_fence_save_wptr(struct dma_fence *fence)
 }
 
 static void amdgpu_ring_backup_unprocessed_command(struct amdgpu_ring *ring,
-						   u64 start_wptr, u32 end_wptr)
+						   u64 start_wptr, u64 end_wptr)
 {
 	unsigned int first_idx = start_wptr & ring->buf_mask;
 	unsigned int last_idx = end_wptr & ring->buf_mask;
-- 
2.51.0




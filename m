Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC02196446;
	Thu,  5 Sep 2024 09:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529484; cv=none; b=INY35G9SdNpYj7tZjYYufvUnrl4v/5rNihGowADEeaibHR2FnRLCuK1qTacFP/2ME8hUuOTXfdB6MQbLoFUPe8ISrxIiRVIRMnwB7oufsa1fDkwyX59iZaj9ndAt49eKIaiEiArt8Q+aPQK6s+5Xnt1uFLui0V0SYXTf86IcAAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529484; c=relaxed/simple;
	bh=FhCynjHHV824borMJAykmot/8dZiw/1zgPlEKHRcc9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5B6ogt2GeAEcmG8VEtR0vBXWHf1URAlTk9RfWMRMbaag8rMSTmqCngFU82BkeGRguZ4rCkgK1O7TVBILBDj7I8JW9NTogrL0v/dZi9wB9dRwLHFdasA1wQdPKxPZuw6NM6T3HPGT5zAgpr7VKPeGyPwkCZaVhqTCCSfLKlJygQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uep50fr9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uep50fr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63180C4CEC3;
	Thu,  5 Sep 2024 09:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529483;
	bh=FhCynjHHV824borMJAykmot/8dZiw/1zgPlEKHRcc9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uep50fr9/HZNu58RTX549zBsdvlRfqhNOHZnldcVAaTw5nznV7aobSEIp3gdbmL8D
	 tpXGRu+OoaTsidenqq+DP1YCnO++MIsG5DsZ0Bo8glRsI3R/53JXvzBJp6LyDdDZ1z
	 vBGj4aVU8P0yFE9jlma3DmsCq5KA3MZJYXIRl/Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 047/184] drm/amd/pm: fix uninitialized variable warning
Date: Thu,  5 Sep 2024 11:39:20 +0200
Message-ID: <20240905093734.083241910@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 7c836905520703dbc8b938993b6d4d718bc739f3 ]

Check the return of function smum_send_msg_to_smc
as it may fail to initialize the variable.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index f531ce1d2b1d..a71c6117d7e5 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -99,7 +99,7 @@ static void pp_swctf_delayed_work_handler(struct work_struct *work)
 	struct amdgpu_device *adev = hwmgr->adev;
 	struct amdgpu_dpm_thermal *range =
 				&adev->pm.dpm.thermal;
-	uint32_t gpu_temperature, size;
+	uint32_t gpu_temperature, size = sizeof(gpu_temperature);
 	int ret;
 
 	/*
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070E81946A2;
	Thu,  5 Sep 2024 10:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530465; cv=none; b=cvExi64iiQFFQvARqstPmakaejh0vRoYOY1qEp/lG8KybbUyz7te5Lg1tWaVhy+p00npd2roTLZQEaReLSKY+o46lPoj2ot6yQOhzGN0FyBZ37nx0/tc+W6P5MkZmKBskLGIIDr7E70rcAN8ZWtsonlNFk+Ia1BNk5m1G5M0Tqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530465; c=relaxed/simple;
	bh=0iN7/YzYH0WiMmG2L57OATQWjOauphaDoJUg36vGdR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfUNRVS3rvI0WWiMWNzsUe3T8ZtT3mmLRzxL91M9twsxKiLp/AkGq5uYagRZBCadBHow+pcqGTVf/yHEmaHFTsfdDoR8PAeIRFJYwRz3qjIBZbXJlMdg8pqgXNBu7jXErSlpaiuDtD7MoYf1PocXwVJYdh/fDbZoNl7H2My+9qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=surTXQHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="surTXQHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D59C4CEC3;
	Thu,  5 Sep 2024 10:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530464;
	bh=0iN7/YzYH0WiMmG2L57OATQWjOauphaDoJUg36vGdR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=surTXQHpvecBM6E6GoDzxLWOuj/1GMQnTwxsRIqsra8XBD1hj4WaVHDPqb2bkmS6f
	 y9L23G49xPA173E1Ds/Mra+EaXGK+yVOKIxRpDTNNYMdJI1zfJOL3Jyz7r7eea/LAp
	 ktD87oNM5eJEV2cK5vHqnDIEVDYWQNo5fj2gR8+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/101] drm/amd/pm: fix uninitialized variable warning
Date: Thu,  5 Sep 2024 11:41:05 +0200
Message-ID: <20240905093717.424918749@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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
index f3668911a88f..eae4b4826f04 100644
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




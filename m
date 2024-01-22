Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AFB144619;
	Tue, 23 Jan 2024 00:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969538; cv=none; b=Mf7EDH5Yl5sZEk0ax5NUgSYNHmNogah+9AwsEYzqmq4A+1rfGqDou5F8Fv3tjfDpyS09tL1MaNkmvWTKRdyQlbAUltQNC3U7sSos8Tby9Nj97ZDodJO+7qOb/3jGy+/GIf8Mmk2nsAHjQNjeD0NLT3DtbteDQTX1qCI+NBnBbZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969538; c=relaxed/simple;
	bh=R8rW/OG0g2tmfGVa2N4AuCMTCLhnlqk8f9zsH2EjC2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6VRHgsNF4M/zK3pIooUu6srDkyssktVDUpOxOZnsjqzpT0KUEbRF4X2gZ+C/6Adr/kkkB9B54MCfM03E3v3R9Eae7SGIZOG5/jNP2WIHxNO9BvZugD7z0zDD9eASPBoUrWgSlvlQn62y4PyMxOYI4CdNyBfGQov9kffzZ4ZYio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUE46KK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUE46KK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC21AC43394;
	Tue, 23 Jan 2024 00:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969538;
	bh=R8rW/OG0g2tmfGVa2N4AuCMTCLhnlqk8f9zsH2EjC2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUE46KK4PVKx3CrBkuGG1JMGSP0bYDGdaQi5NXejJiz8ct67yqhfPEdFri2ylYZvq
	 p9wqOmlF+1V0fliAIGt9svtPmDrpwn7Xmwl5X6FmscFuoQa7kPJMQwgEgGnekDQxUl
	 3tsPJdiF54P+do3ibBnQsBS+1TPhBn5BfsXCIwQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 312/641] drm/msm/adreno: Fix A680 chip id
Date: Mon, 22 Jan 2024 15:53:36 -0800
Message-ID: <20240122235827.668510341@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 3e6688fd96966b6c275e95c39aa367bc0a490ccd ]

The only A680 referenced from DeviceTree is patch level 1, which since
commit '90b593ce1c9e ("drm/msm/adreno: Switch to chip-id for identifying
GPU")' isn't a known chip id.

Correct the chip id to allow the A680 to be recognized again.

Fixes: 90b593ce1c9e ("drm/msm/adreno: Switch to chip-id for identifying GPU")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/569839/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 41b13dec9bef..3ee14646ab6b 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -464,7 +464,7 @@ static const struct adreno_info gpulist[] = {
 			{ 190, 1 },
 		),
 	}, {
-		.chip_ids = ADRENO_CHIP_IDS(0x06080000),
+		.chip_ids = ADRENO_CHIP_IDS(0x06080001),
 		.family = ADRENO_6XX_GEN2,
 		.revn = 680,
 		.fw = {
-- 
2.43.0




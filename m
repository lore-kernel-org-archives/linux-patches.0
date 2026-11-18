Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055681;
	b=uppT4zlGPET+2B43mMPV2nwjnDUIvMAla48QeifwczM9EDl3BzB0my/yUpFUd8EWLPNO
	 K5HYKDUjqmCSzVyuXP5sg/QwXlL7tgLQVx3APfFVAVBCTmLc2ROqlckjGViM0hQk6W+8r
	 r2247qguzgaQCvEtfyECNEL57ZKRZyCA2v74VJGIhj2NWFjmVLVS9BjvBoUrk5hY5Ky/F
	 /YLIWr/MHvi85+wWD9smYcaxHlgtsUzRF05cIZYacXiT8ASwopzl2HMtRwYItJj9ZHRVz
	 PJJcE8f177wgwaQcWrtXZSVmOxd6/oiztxvyAUokj3CrsvL1J2f8f+QZO45xAgz7yGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=whZuVYNWwlPR3fnz09ZGKUwnr5FHWHQPJ27ytVLkQkc=;
	b=PAC2tsfw4qKTcLCM26ViBtjofdTYvbVjGUKFsqoOBg3c0VssmSbTePnGZs52j8eWupMI
	 rluLJ+7oJ+hNJ69ydmjmUBZcfW9BYfxHmiR+1c94DzATQWn3bU/Z24e+z9tsGSBIabCNZ
	 Nt1Q3ztZMCJ6mVT8Ocahdnajx2HTAEZgL6Sm8HpbADtvj0k2jSfJyEHB2sg5FcZJfS8gR
	 YA8V9TPM3fwLvRXN++vxXA427NIl2+3kPqLX0VRCqSGrpU94lkBQk1y8PM5Kj24XTTVqM
	 ahTTMX3IqbIsyQK6zaL1GrfoymUEU0V9237tcENl0Pp8hO3tu6jNxFHs2o2Ih8pK0tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/JGK148";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7A860A2602;
	Thu, 19 Nov 2026 02:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/JGK148
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D94B1F000C5;
	Thu, 19 Nov 2026 02:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055680;
	bh=whZuVYNWwlPR3fnz09ZGKUwnr5FHWHQPJ27ytVLkQkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/JGK148WM4wZfq6zqX1nGwUzUw2m+zWfjV4QV5/5cKE/lMjI418bIGmUhCe/0MVx
	 4YpyKOziL1TajKSgxc1iIqwGUnLvzJ7rxklAfgOpUw/HeZyqUCULod2wOAISRDL1bk
	 Ao4Jp+RBN3jLAMD2xvwDBfkBWA2O0QNWKeoqZWnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1717/2214] drm/msm/dp: dont report link training success after a reinit
Date: Wed, 18 Nov 2026 15:56:33 +0100
Message-ID: <20261118150120.424106712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Keri <okerixx@gmail.com>

[ Upstream commit a47987366e7fc2c05aeffc97f8e1f776e583f792 ]

When every training attempt fails, the retry loop in
msm_dp_ctrl_on_link() ends on a successful
msm_dp_ctrl_reinitialize_mainlink(), leaving rc at 0. The caller then
enables the stream on an untrained link and the display stays dark.

The retry counter only reaches zero in that case, so treat it as a
training failure.

Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/756528/
Link: https://lore.kernel.org/r/20260925125314.16563-1-okerixx@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 85f86afc55052..2b0ec2149dd51 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1746,6 +1746,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	if (ctrl->link->sink_request & DP_TEST_LINK_PHY_TEST_PATTERN)
 		return rc;
 
+	if (!link_train_max_retries)
+		rc = -ETIMEDOUT;
+
 	if (rc == 0) {  /* link train successfully */
 		/*
 		 * do not stop train pattern here
-- 
2.53.0




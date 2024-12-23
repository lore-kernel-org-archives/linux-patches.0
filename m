Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F40319E98B;
	Mon, 23 Dec 2024 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969981; cv=none; b=ejdVJTltuFSaJiHSSOxGDCsZTMvRJr9lDVkcH3LIxYVy7eDf5YaW5Yzl52zCSnvGtax2g0s5ec2FUpH9vv9mIHWAK5rsFUjcB3J1bkysg/F0xzSRqAmavkpacxAzMwE+h01HFA3Uy75ZXaUCSoLSMdrrD9pJ+gkNlIJMA65OLTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969981; c=relaxed/simple;
	bh=psSOdECkqP0J6J4s3V+bxVx6KeDcU0VNpAW8EhdwfVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDoxx17IyFNw/SxvdmRJbzTOdnKnx1Ukb4/+KWG0md8sxHq8N/ZFCdPfuyqmfqw0EWciYEbUac/8QgS71pi/RxYmI/IYVx3LAvXsYM3ddAydeubhpV3qymU66N2TN+9KFpnBhmi0v3q1hhLBqNQ9HtewqeLhaiRiStPW6HSChu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqsQkYm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqsQkYm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E303FC4CED3;
	Mon, 23 Dec 2024 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969981;
	bh=psSOdECkqP0J6J4s3V+bxVx6KeDcU0VNpAW8EhdwfVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqsQkYm3RbfVdIUWNmQLJo71phNp9fWIhlqFHvg6qlSGQQN/OKc84mIxSqXta3jQa
	 wwDX9qFGB8j++zQY37YTI+nS8mByLRVkkVsD3tmih7tMwveVnm4X3+B3SE8/TiX/kS
	 /GQ33Pn16VS991aSe1f/h8hK7AmqyHjqo72FbCik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 108/160] drm/amdgpu/smu14.0.2: fix IP version check
Date: Mon, 23 Dec 2024 16:58:39 +0100
Message-ID: <20241223155412.852940120@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9e752ee26c1031312a01d2afc281f5f6fdfca176 upstream.

Use the helper function rather than reading it directly.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8f2cd1067afe68372a1723e05e19b68ed187676a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2108,7 +2108,7 @@ static int smu_v14_0_2_enable_gfx_featur
 {
 	struct amdgpu_device *adev = smu->adev;
 
-	if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(14, 0, 2))
+	if (amdgpu_ip_version(adev, MP1_HWIP, 0) == IP_VERSION(14, 0, 2))
 		return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_EnableAllSmuFeatures,
 										   FEATURE_PWR_GFX, NULL);
 	else



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D6313BC0C;
	Mon, 23 Dec 2024 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970019; cv=none; b=PWXvABMR8LuH8reg6iaYILN58H/GHMvgZfE77Zp0cIuM37o45WAg2NtnoTEK0cVK7Cr9OtzOG9mXQu/l6/hqdI+RooMmoPnfdkOkTrvoL1w2JV92ZYUVvksyVkfczcOFCFDIlxQay8Vcl+ka4KhhP78/fsQbHp56/i5mZE/QH/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970019; c=relaxed/simple;
	bh=DGJHVQtY6fHFIkYy4i9PnqNo0AHN2G3LnnLpgdRvP00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDA/yG3hk3sio3IV6PDHczjjzfUYIr/PNENcQfYdau8HrE1miDeNC3p0VGiioskmNjVIa03heqlAYjpTEImuudlf3LDGABUqJIAQg0laFioM/cIWeTSRpOJbE0wvsGIJZoJ5LWoVx8A5PftwnKChae+Su6Z6HqhCiEhxugkrC3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZbHgwa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZbHgwa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBEAC4CED3;
	Mon, 23 Dec 2024 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970018;
	bh=DGJHVQtY6fHFIkYy4i9PnqNo0AHN2G3LnnLpgdRvP00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZbHgwa7RMeWfDEE/sXRzr4ZMezyaxk9nfiXxUtQn4DzndIO1qOGjKzlHb545j+g3
	 i7fWo7gaC9a5EiG+rNX9E7X5a4xt5REdIiKyagdrQMCQdGmkAVm8ftDNSdfdbWp5Xn
	 pUCJxvNgzAG8b3+FGXulTz6iVyhwYW9FKT5FEFhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 121/160] drm/amdgpu/mmhub4.1: fix IP version check
Date: Mon, 23 Dec 2024 16:58:52 +0100
Message-ID: <20241223155413.442155835@linuxfoundation.org>
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

commit 6ebc5b92190e01dd48313b68cbf752c9adcfefa8 upstream.

Use the helper function rather than reading it directly.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 63bfd24088b42c6f55c2096bfc41b50213d419b2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
index 0fbc3be81f14..f2ab5001b492 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v4_1_0.c
@@ -108,7 +108,7 @@ mmhub_v4_1_0_print_l2_protection_fault_status(struct amdgpu_device *adev,
 	dev_err(adev->dev,
 		"MMVM_L2_PROTECTION_FAULT_STATUS_LO32:0x%08X\n",
 		status);
-	switch (adev->ip_versions[MMHUB_HWIP][0]) {
+	switch (amdgpu_ip_version(adev, MMHUB_HWIP, 0)) {
 	case IP_VERSION(4, 1, 0):
 		mmhub_cid = mmhub_client_ids_v4_1_0[cid][rw];
 		break;
-- 
2.47.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDD5233735;
	Tue, 29 Apr 2025 17:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949104; cv=none; b=JXQkWCMwNWShFblIUaCIRfIB+LqyotV1JedkzYNnkbPxF+uaYXUqS4PHPTFpzC59pZupY3NCLy0/vJ9djm0QD37r9qZ1rXdJO4St8jdX+m/ViImagyJmiMlTJI+OBEZBGydLThAug7AOpPUDtmjJOQumnk21/jolidgsmxUk3GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949104; c=relaxed/simple;
	bh=hE+BSLewlo1KIrKLU/dxM0nNgPYdYa7Y1Ldt/+Q5OYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmCndJk6h9EvgViQgV8VkXDa+HI0PIIcy86+kSHpmhBLeWIlNCukicpHOnrbzixzyN+pQFiebrsL4O3BtJ5xhQ07gYtUAwotRfcA9//kMqH36exZZYbHuDTSDx6/9Ew7exoImhZicSmqj2xmqWSbzRROpEpTJnnzUoJ6j2z1PJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/rR2TJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/rR2TJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95CBC4CEE3;
	Tue, 29 Apr 2025 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949104;
	bh=hE+BSLewlo1KIrKLU/dxM0nNgPYdYa7Y1Ldt/+Q5OYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/rR2TJ7d9z2QIaZORDG9yKaN3cQq2unuv0ZYHdjNd2WWvrr46ahxhlc68IUlw07B
	 SJ1J6vYCuXbECUchyHaj5J/kvn5TNUiYMoRynp5o3ePoOO6Ct8Np/D6KtljvATdBKy
	 xt1gVmLarVig5UZVdkH5ZcRifG4prHHaEBFvhHG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 213/373] drm/amd/display: Stop amdgpu_dm initialize when link nums greater than max_links
Date: Tue, 29 Apr 2025 18:41:30 +0200
Message-ID: <20250429161131.920887319@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

commit cf8b16857db702ceb8d52f9219a4613363e2b1cf upstream.

[Why]
Coverity report OVERRUN warning. There are
only max_links elements within dc->links. link
count could up to AMDGPU_DM_MAX_DISPLAY_INDEX 31.

[How]
Make sure link count less than max_links.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Minor conflict resolved due to code context change. And the macro MAX_LINKS
 is introduced by Commit 60df5628144b ("drm/amd/display: handle invalid
 connector indices") after 6.10. So here we still use the original array
 length MAX_PIPES * 2]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4321,17 +4321,17 @@ static int amdgpu_dm_initialize_drm_devi
 	}
 #endif
 
+	if (link_cnt > (MAX_PIPES * 2)) {
+		DRM_ERROR(
+			"KMS: Cannot support more than %d display indexes\n",
+				MAX_PIPES * 2);
+		goto fail;
+	}
+
 	/* loops over all connectors on the board */
 	for (i = 0; i < link_cnt; i++) {
 		struct dc_link *link = NULL;
 
-		if (i > AMDGPU_DM_MAX_DISPLAY_INDEX) {
-			DRM_ERROR(
-				"KMS: Cannot support more than %d display indexes\n",
-					AMDGPU_DM_MAX_DISPLAY_INDEX);
-			continue;
-		}
-
 		aconnector = kzalloc(sizeof(*aconnector), GFP_KERNEL);
 		if (!aconnector)
 			goto fail;



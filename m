Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC482FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4D0C433D2;
	Mon, 15 May 2023 16:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169887;
	bh=Db35oJ7nP8VKQqC6YjMXrYMAho4NgfrfuTh2jHm7xq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXuoVMm6A7NIC2xDGqoTWXiH33v2zBuBj51HLln8/rP2Z1WIzjy810U4v524NENol
	 h9F34grEYYwDothxNTILJ46qeaqoNCEqhB8YHK6L0bVpt0v18EdST82ySA/zmxxdQl
	 vjDcGX+fDT9IN1dRy5IlWrdGLPMi/v27jN/7XrbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Yogesh Mohan Marimuthu <Yogesh.Mohanmarimuthu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tim Huang <Tim.Huang@amd.com>
Subject: [PATCH 6.3 202/246] drm/amdgpu: change gfx 11.0.4 external_id range
Date: Mon, 15 May 2023 18:26:54 +0200
Message-Id: <20230515161728.668845415@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 996e93a3fe74dcf9d467ae3020aea42cc3ff65e3 upstream.

gfx 11.0.4 range starts from 0x80.

Fixes: 311d52367d0a ("drm/amdgpu: add soc21 common ip block support for GC 11.0.4")
Cc: stable@vger.kernel.org
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reported-by: Yogesh Mohan Marimuthu <Yogesh.Mohanmarimuthu@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -778,7 +778,7 @@ static int soc21_common_early_init(void
 			AMD_PG_SUPPORT_VCN_DPG |
 			AMD_PG_SUPPORT_GFX_PG |
 			AMD_PG_SUPPORT_JPEG;
-		adev->external_rev_id = adev->rev_id + 0x1;
+		adev->external_rev_id = adev->rev_id + 0x80;
 		break;
 
 	default:



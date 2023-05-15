Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B110CFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B9FC4339C;
	Mon, 15 May 2023 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170563;
	bh=YqDo/tczgT6Erja8rEHFm2scRcY6JC5nKPwxOy0rONA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpJRDL85IETwVdA58qPMq3vfGIvwb9GIIDQW8NOYnhfIIljYvxZxCAmDwkZGPJzp9
	 boBFSium1cJhuPom0DTC0mdzWAEdtYqPS7J/6OTu0tM1iZ3zFUZk+L9FqEcJ9Bri4c
	 Oe7hnhSgwE1gP7+zGGumzQ2k63DtTwIpm6/hm53k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Yogesh Mohan Marimuthu <Yogesh.Mohanmarimuthu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tim Huang <Tim.Huang@amd.com>
Subject: [PATCH 6.1 170/239] drm/amdgpu: change gfx 11.0.4 external_id range
Date: Mon, 15 May 2023 18:27:13 +0200
Message-Id: <20230515161726.771738201@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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
@@ -715,7 +715,7 @@ static int soc21_common_early_init(void
 			AMD_PG_SUPPORT_VCN_DPG |
 			AMD_PG_SUPPORT_GFX_PG |
 			AMD_PG_SUPPORT_JPEG;
-		adev->external_rev_id = adev->rev_id + 0x1;
+		adev->external_rev_id = adev->rev_id + 0x80;
 		break;
 
 	default:



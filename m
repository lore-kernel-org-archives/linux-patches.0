Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB9FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2069C433D2;
	Mon, 15 May 2023 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169884;
	bh=doUGeYeK5D6hC+5KFMRRy2mVHjf3LgxF2nqwGpUT1Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLiabosLGKet1xLDMX+A5CStZCgyivWnSgJWDzVuhXJiDTsQDZr6ZBdt9Vf9oV7zn
	 iYwxTvOLG9933ChZRFhULo+LMlpik6DXH+tcmnSKU5y4ezO2M8lmTGlL/P9d5/FVmi
	 20fUjBWi7gQe5fTpNBXMNF9O7DKy1wqpsdXHyYUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>,
	Veerabadhran Gopalakrishnan <Veerabadhran.Gopalakrishnan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 201/246] drm/amdgpu/jpeg: Remove harvest checking for JPEG3
Date: Mon, 15 May 2023 18:26:53 +0200
Message-Id: <20230515161728.639274295@linuxfoundation.org>
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

From: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>

commit 5b94db73e45e2e6c2840f39c022fd71dfa47fc58 upstream.

Register CC_UVD_HARVESTING is obsolete for JPEG 3.1.2

Signed-off-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Reviewed-by: Veerabadhran Gopalakrishnan <Veerabadhran.Gopalakrishnan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -54,6 +54,7 @@ static int jpeg_v3_0_early_init(void *ha
 
 	switch (adev->ip_versions[UVD_HWIP][0]) {
 	case IP_VERSION(3, 1, 1):
+	case IP_VERSION(3, 1, 2):
 		break;
 	default:
 		harvest = RREG32_SOC15(JPEG, 0, mmCC_UVD_HARVESTING);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4F52590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F0CC433EF;
	Sun, 22 Jan 2023 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401261;
	bh=GTd9lWxKOd0LYbHAsUVxiMu7IToZO3Q0AM0M1eNUIJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrTCd1QpYToiKVgrXbOHuKnjeJaBEBllIcgDzIQ3J5bZ3IZgGBaQmpPILG1bWizCP
	 /JbXhF2DpQBtgw1lPxeAqfLKFw9I//ljhJdd4xgmaxZg+AN1PEV4tVXxNzQGrS/1JP
	 +zRDHsmeJ8mEFjV2v5UZEQleDE51vgDUHTGRL7v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 172/193] drm/amdgpu/pm: add GFXOFF control IP version check for SMU IP v13.0.11
Date: Sun, 22 Jan 2023 16:05:01 +0100
Message-Id: <20230122150254.277484454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

commit 9f83e61201bb21957e4993736532edad7a11c7fa upstream.

Enable the SMU IP v13.0.11 GFXOFF control

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -845,6 +845,7 @@ int smu_v13_0_gfx_off_control(struct smu
 	case IP_VERSION(13, 0, 7):
 	case IP_VERSION(13, 0, 8):
 	case IP_VERSION(13, 0, 10):
+	case IP_VERSION(13, 0, 11):
 		if (!(adev->pm.pp_feature & PP_GFXOFF_MASK))
 			return 0;
 		if (enable)



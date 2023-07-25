Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD3C134C1
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C592C4167D;
	Tue, 25 Jul 2023 10:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282202;
	bh=xooRu0cCCOEw1oT9me3jZBrlvMDLb5FEYYhjeHL0XAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLeQMGgU5eyVdTVjjtNw7khnRI6ep8XEc6lOTw0Q/D20F6eJn12swsUwvCELxcX+i
	 5m6XpXzK84XF+yASHkhlyFWPDL27WMMlx82A98iDIXQRlg09zZiqsQ0PMDi8fy+aSr
	 A9VVDVlmsoiZOu2xAKa51LkbQ0mnj5I6DUhEVSN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 045/227] drm/amdgpu/pm: make gfxclock consistent for sienna cichlid
Date: Tue, 25 Jul 2023 12:43:32 +0200
Message-ID: <20230725104516.667140025@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit a4eb11824170d742531998f4ebd1c6a18b63db47 upstream.

Use average gfxclock for consistency with other dGPUs.

Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -1927,12 +1927,16 @@ static int sienna_cichlid_read_sensor(st
 		*size = 4;
 		break;
 	case AMDGPU_PP_SENSOR_GFX_MCLK:
-		ret = sienna_cichlid_get_current_clk_freq_by_table(smu, SMU_UCLK, (uint32_t *)data);
+		ret = sienna_cichlid_get_smu_metrics_data(smu,
+							  METRICS_CURR_UCLK,
+							  (uint32_t *)data);
 		*(uint32_t *)data *= 100;
 		*size = 4;
 		break;
 	case AMDGPU_PP_SENSOR_GFX_SCLK:
-		ret = sienna_cichlid_get_current_clk_freq_by_table(smu, SMU_GFXCLK, (uint32_t *)data);
+		ret = sienna_cichlid_get_smu_metrics_data(smu,
+							  METRICS_AVERAGE_GFXCLK,
+							  (uint32_t *)data);
 		*(uint32_t *)data *= 100;
 		*size = 4;
 		break;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C3F134C1
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD047C433C8;
	Tue, 25 Jul 2023 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282205;
	bh=aXsBD8vEtU4R9P40FIRXk5xuGyk9gGsfxT2EMAqxmaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cl5N/BgXIeh/vk9El1sCa3LDvQ4pqALkwFUH3NT7jMZFG21oR3RU5ihbcGxFHh+Yr
	 sYQj7yTq7T3oyvrXF1XbQ9JYCSzIhXwHHiNmfiF4LxNG+dqs11Y15avvv9HfHUDMvS
	 D0zqJNX/cwdiI4ML0uP9sRs+m4Yh9u6QtLQDkuGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 046/227] drm/amdgpu/pm: make mclk consistent for smu 13.0.7
Date: Tue, 25 Jul 2023 12:43:33 +0200
Message-ID: <20230725104516.709048419@linuxfoundation.org>
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

commit 068c8bb10f37bb84824625dbbda053a3a3e0d6e1 upstream.

Use current uclk to be consistent with other dGPUs.

Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -940,7 +940,7 @@ static int smu_v13_0_7_read_sensor(struc
 		break;
 	case AMDGPU_PP_SENSOR_GFX_MCLK:
 		ret = smu_v13_0_7_get_smu_metrics_data(smu,
-						       METRICS_AVERAGE_UCLK,
+						       METRICS_CURR_UCLK,
 						       (uint32_t *)data);
 		*(uint32_t *)data *= 100;
 		*size = 4;



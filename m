Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D611170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918E0C433C8;
	Mon, 11 Sep 2023 14:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442600;
	bh=lKgbaCcnU9veixBRGsdDBT2TUrvSDq5ut8ZN53AVVR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cl+D9KxV4+2Bgwg0q2aIpNkuBlVL6beWBUAI6NU/6iXiaybUST8DlBjiAPOv5a0nT
	 1vl2CSw4CXP00ouSLoAzc3er7Tm3pM85+nbQ68Xo8mAgkjCPW3eBd5sqNT/p6J6gu/
	 oQHF0fWEK8MG1wf0H6Zo5aKxfLTZQn53jTY24mig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 081/737] drm/amd/pm: Fix temperature unit of SMU v13.0.6
Date: Mon, 11 Sep 2023 15:39:00 +0200
Message-ID: <20230911134652.772814166@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 8d036427f0042a91136e6f19a39542eedec4e96c ]

Temperature needs to be reported in millidegree Celsius.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index c9093517b1bda..bfa020fe0d4fe 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -697,16 +697,19 @@ static int smu_v13_0_6_get_smu_metrics_data(struct smu_context *smu,
 		*value = SMUQ10_TO_UINT(metrics->SocketPower) << 8;
 		break;
 	case METRICS_TEMPERATURE_HOTSPOT:
-		*value = SMUQ10_TO_UINT(metrics->MaxSocketTemperature);
+		*value = SMUQ10_TO_UINT(metrics->MaxSocketTemperature) *
+			 SMU_TEMPERATURE_UNITS_PER_CENTIGRADES;
 		break;
 	case METRICS_TEMPERATURE_MEM:
-		*value = SMUQ10_TO_UINT(metrics->MaxHbmTemperature);
+		*value = SMUQ10_TO_UINT(metrics->MaxHbmTemperature) *
+			 SMU_TEMPERATURE_UNITS_PER_CENTIGRADES;
 		break;
 	/* This is the max of all VRs and not just SOC VR.
 	 * No need to define another data type for the same.
 	 */
 	case METRICS_TEMPERATURE_VRSOC:
-		*value = SMUQ10_TO_UINT(metrics->MaxVrTemperature);
+		*value = SMUQ10_TO_UINT(metrics->MaxVrTemperature) *
+			 SMU_TEMPERATURE_UNITS_PER_CENTIGRADES;
 		break;
 	case METRICS_THROTTLER_STATUS:
 		*value = smu_v13_0_6_get_throttler_status(smu, metrics);
-- 
2.40.1




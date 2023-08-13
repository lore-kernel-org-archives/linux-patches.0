Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8819E9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D213EC433C8;
	Sun, 13 Aug 2023 21:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961909;
	bh=y7owYjLEcq1YjbAW5hgxUYdVCLKfH1uUL4417HbRVgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWIPnz27Hlc5+l0g8Y3SiGneg60PcuF1AZo0PBRzymWBsruakCtSqu09S2uGq3xTN
	 DeOw4MNLSTqDbYq7AMY7JKmXZad2jo/TX0KmspJy5F4XlLVzgZinyv8pez39Dkxa9o
	 KEooVZt832/Qfsq2csf3nzoWFgAh0fsmWsNvdW7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 043/206] drm/amd/pm: correct the pcie width for smu 13.0.0
Date: Sun, 13 Aug 2023 23:16:53 +0200
Message-ID: <20230813211726.223724540@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kenneth Feng <kenneth.feng@amd.com>

commit bd60e2eafd8fb053948b6e23e8167baf7a159750 upstream.

correct the pcie width value in pp_dpm_pcie for smu 13.0.0

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1030,7 +1030,6 @@ static int smu_v13_0_0_print_clk_levels(
 	struct smu_13_0_dpm_context *dpm_context = smu_dpm->dpm_context;
 	struct smu_13_0_dpm_table *single_dpm_table;
 	struct smu_13_0_pcie_table *pcie_table;
-	const int link_width[] = {0, 1, 2, 4, 8, 12, 16};
 	uint32_t gen_speed, lane_width;
 	int i, curr_freq, size = 0;
 	int ret = 0;
@@ -1145,7 +1144,7 @@ static int smu_v13_0_0_print_clk_levels(
 					(pcie_table->pcie_lane[i] == 6) ? "x16" : "",
 					pcie_table->clk_freq[i],
 					(gen_speed == DECODE_GEN_SPEED(pcie_table->pcie_gen[i])) &&
-					(lane_width == DECODE_LANE_WIDTH(link_width[pcie_table->pcie_lane[i]])) ?
+					(lane_width == DECODE_LANE_WIDTH(pcie_table->pcie_lane[i])) ?
 					"*" : "");
 		break;
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE0EBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B49C433EF;
	Tue,  7 Mar 2023 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210898;
	bh=GmoqgQjS8GrD7H/UaNkiPlOwZIiDMOQSslpLAim/nmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmqTKiJSty0YS2EhfeaKRJgCBHPZ2t7PFkdi5Fos3s3G8mUDOu59dM1cXEzttRB/R
	 mh7srQ8gNd21oDv9hrziIpGcawrdsBUayYvOuV3xkthNin2OjvzR9LUtOWjLHI0FZ2
	 aUK6gQd8ksUHgYI6u7d6/euFrRMaRaaL+pkyJPqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Lei <Jun.Lei@amd.com>,
	Jasdeep Dhillon <jdhillon@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0688/1001] drm/amd/display: Reduce expected sdp bandwidth for dcn321
Date: Tue,  7 Mar 2023 17:57:40 +0100
Message-Id: <20230307170051.466997959@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 6b81090d6d4cc0fd818c9ec9dbb6906f921ad396 ]

[Description]
Modify soc BB to reduce expected sdp bandwidth and align with measurements to
fix underflow issues.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
index f4b176599be7a..0ea406145c1d7 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
@@ -136,7 +136,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_21_soc = {
 	.urgent_out_of_order_return_per_channel_pixel_only_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_pixel_and_vm_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_vm_only_bytes = 4096,
-	.pct_ideal_sdp_bw_after_urgent = 100.0,
+	.pct_ideal_sdp_bw_after_urgent = 90.0,
 	.pct_ideal_fabric_bw_after_urgent = 67.0,
 	.pct_ideal_dram_sdp_bw_after_urgent_pixel_only = 20.0,
 	.pct_ideal_dram_sdp_bw_after_urgent_pixel_and_vm = 60.0, // N/A, for now keep as is until DML implemented
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5259413D600;
	Tue, 23 Jul 2024 18:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760033; cv=none; b=l/e19cYVtKxEMpjAPaoA6RahwNZ1wESDk2I6iMhSVebO9n6+xadkmeCAsUMfHgXOLcJempod9rcehNjYCvmHSrSului+5Il0EivMirZKa3vJHDo/MT+iyfMknTuGTS88dFeJELlLFnbR18Db2pSfahZsBd+Vep1GwbF96x1k6wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760033; c=relaxed/simple;
	bh=1qlIWpgVtBUtOUY3B0G9ms6o0U2loS3WvnKfYDOXWUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay+9o9/ewxibMryx/AThSOYDgVszK9wEqK9ATdGX7EWl40+TLjUSLG6dSuNwK7lT7JVnm1OaLFy/O4Avo7KS6w1BqVyD7GfpTtCQcjLZuce/QgfSktpmLsgytPrHHEINk2jtl0PoHvcIKc/3NH3WWp021SGc6vKr9ry/yK2yh1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HyW7svDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HyW7svDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C302CC4AF0A;
	Tue, 23 Jul 2024 18:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760033;
	bh=1qlIWpgVtBUtOUY3B0G9ms6o0U2loS3WvnKfYDOXWUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HyW7svDGtqvWJNqE/LwSy27FbQ2eMh8x99UWwXyKcziZIBe4fhzmCxuTMkl+cp2Bv
	 TEll5uafr7L6qKOKYGKtztMq3xvev3Gg9QUOrjRQwgv7ZOoHHx5yO/Jo+4DlJ1hNVL
	 Eq+DnG0LuCYlyG8eZwyozOPnDhyQ/u0HckOiCJsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Paul Hsieh <paul.hsieh@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 081/163] drm/amd/display: change dram_clock_latency to 34us for dcn35
Date: Tue, 23 Jul 2024 20:23:30 +0200
Message-ID: <20240723180146.599614174@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Hsieh <paul.hsieh@amd.com>

[ Upstream commit 6071607bfefefc50a3907c0ba88878846960d29a ]

[Why & How]
Current DRAM setting would cause underflow on customer platform.
Modify dram_clock_change_latency_us from 11.72 to 34.0 us as per recommendation from HW team

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
index 53e40d3c48d4b..6716696df7719 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
@@ -177,7 +177,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_5_soc = {
 	.urgent_latency_pixel_data_only_us = 4.0,
 	.urgent_latency_pixel_mixed_with_vm_data_us = 4.0,
 	.urgent_latency_vm_data_only_us = 4.0,
-	.dram_clock_change_latency_us = 11.72,
+	.dram_clock_change_latency_us = 34.0,
 	.urgent_out_of_order_return_per_channel_pixel_only_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_pixel_and_vm_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_vm_only_bytes = 4096,
-- 
2.43.0




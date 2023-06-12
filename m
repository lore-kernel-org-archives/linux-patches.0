Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D785DD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA55C433D2;
	Mon, 12 Jun 2023 10:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566940;
	bh=2c5OzuTU4BorGtknvixVZrayK3gjQ1jc+jO6m5Ec02g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KrIkADqNPEF61iXFfYLACitOoY7rSV7q3uG7m6oLA3dJVYhxr3FWMH0N+jGOVcac
	 dzEhSo4HW60SJ0jZRQGp6uvYlbxb9uzsYoHz+OOrreR9KCvRe6D4Ucf66qqjdEgODN
	 brmo2EvAKaXyMI8VLkRXom91nA1D+Y720sdTsa2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Stylon Wang <stylon.wang@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Nevenko Stupar <Nevenko.Stupar@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.3 090/160] drm/amd/display: Reduce sdp bw after urgent to 90%
Date: Mon, 12 Jun 2023 12:27:02 +0200
Message-ID: <20230612101719.133909983@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <alvin.lee2@amd.com>

commit e1a600208286c197c2696e51fc313e49889315bd upstream.

[Description]
Reduce expected SDP bandwidth due to poor QoS and
arbitration issues on high bandwidth configs

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Stylon Wang <stylon.wang@amd.com>
Signed-off-by: Alvin Lee <alvin.lee2@amd.com>
Reviewed-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -138,7 +138,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 	.urgent_out_of_order_return_per_channel_pixel_only_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_pixel_and_vm_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_vm_only_bytes = 4096,
-	.pct_ideal_sdp_bw_after_urgent = 100.0,
+	.pct_ideal_sdp_bw_after_urgent = 90.0,
 	.pct_ideal_fabric_bw_after_urgent = 67.0,
 	.pct_ideal_dram_sdp_bw_after_urgent_pixel_only = 20.0,
 	.pct_ideal_dram_sdp_bw_after_urgent_pixel_and_vm = 60.0, // N/A, for now keep as is until DML implemented



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36DD47791;
	Mon,  8 Jan 2024 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wX+1R2B/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDA8C433C9;
	Mon,  8 Jan 2024 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726957;
	bh=qUZ4YcrcQQ7zezcRSLfKxgPk6qInWDHLRRzgj3he4JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wX+1R2B/dfRqae8Uzx/oPcL0i+Zb8MQrMAiUtxuX0HKOQ4edGnnF8D3q/frYjuDMA
	 rsZxwCCuxfsB3+6D3jQ3ar4u9ylkCsUzIseBlV9Ns4nYNlQ3rYpTmFuho4YqSF+Mr7
	 bVIdCeEQtKQZrBaCXLnxgpcbak+FSA30FU4ttuKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 115/124] drm/amd/display: add nv12 bounding box
Date: Mon,  8 Jan 2024 16:09:01 +0100
Message-ID: <20240108150608.264489150@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7e725c20fea8914ef1829da777f517ce1a93d388 upstream.

This was included in gpu_info firmware, move it into the
driver for consistency with other nv1x parts.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2318
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c |  110 ++++++++++++++++++-
 1 file changed, 109 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -438,7 +438,115 @@ struct _vcs_dpi_soc_bounding_box_st dcn2
 	.use_urgent_burst_bw = 0
 };
 
-struct _vcs_dpi_soc_bounding_box_st dcn2_0_nv12_soc = { 0 };
+struct _vcs_dpi_soc_bounding_box_st dcn2_0_nv12_soc = {
+	.clock_limits = {
+		{
+			.state = 0,
+			.dcfclk_mhz = 560.0,
+			.fabricclk_mhz = 560.0,
+			.dispclk_mhz = 513.0,
+			.dppclk_mhz = 513.0,
+			.phyclk_mhz = 540.0,
+			.socclk_mhz = 560.0,
+			.dscclk_mhz = 171.0,
+			.dram_speed_mts = 1069.0,
+		},
+		{
+			.state = 1,
+			.dcfclk_mhz = 694.0,
+			.fabricclk_mhz = 694.0,
+			.dispclk_mhz = 642.0,
+			.dppclk_mhz = 642.0,
+			.phyclk_mhz = 600.0,
+			.socclk_mhz = 694.0,
+			.dscclk_mhz = 214.0,
+			.dram_speed_mts = 1324.0,
+		},
+		{
+			.state = 2,
+			.dcfclk_mhz = 875.0,
+			.fabricclk_mhz = 875.0,
+			.dispclk_mhz = 734.0,
+			.dppclk_mhz = 734.0,
+			.phyclk_mhz = 810.0,
+			.socclk_mhz = 875.0,
+			.dscclk_mhz = 245.0,
+			.dram_speed_mts = 1670.0,
+		},
+		{
+			.state = 3,
+			.dcfclk_mhz = 1000.0,
+			.fabricclk_mhz = 1000.0,
+			.dispclk_mhz = 1100.0,
+			.dppclk_mhz = 1100.0,
+			.phyclk_mhz = 810.0,
+			.socclk_mhz = 1000.0,
+			.dscclk_mhz = 367.0,
+			.dram_speed_mts = 2000.0,
+		},
+		{
+			.state = 4,
+			.dcfclk_mhz = 1200.0,
+			.fabricclk_mhz = 1200.0,
+			.dispclk_mhz = 1284.0,
+			.dppclk_mhz = 1284.0,
+			.phyclk_mhz = 810.0,
+			.socclk_mhz = 1200.0,
+			.dscclk_mhz = 428.0,
+			.dram_speed_mts = 2000.0,
+		},
+		{
+			.state = 5,
+			.dcfclk_mhz = 1200.0,
+			.fabricclk_mhz = 1200.0,
+			.dispclk_mhz = 1284.0,
+			.dppclk_mhz = 1284.0,
+			.phyclk_mhz = 810.0,
+			.socclk_mhz = 1200.0,
+			.dscclk_mhz = 428.0,
+			.dram_speed_mts = 2000.0,
+		},
+	},
+
+	.num_states = 5,
+	.sr_exit_time_us = 1.9,
+	.sr_enter_plus_exit_time_us = 4.4,
+	.urgent_latency_us = 3.0,
+	.urgent_latency_pixel_data_only_us = 4.0,
+	.urgent_latency_pixel_mixed_with_vm_data_us = 4.0,
+	.urgent_latency_vm_data_only_us = 4.0,
+	.urgent_out_of_order_return_per_channel_pixel_only_bytes = 4096,
+	.urgent_out_of_order_return_per_channel_pixel_and_vm_bytes = 4096,
+	.urgent_out_of_order_return_per_channel_vm_only_bytes = 4096,
+	.pct_ideal_dram_sdp_bw_after_urgent_pixel_only = 40.0,
+	.pct_ideal_dram_sdp_bw_after_urgent_pixel_and_vm = 40.0,
+	.pct_ideal_dram_sdp_bw_after_urgent_vm_only = 40.0,
+	.max_avg_sdp_bw_use_normal_percent = 40.0,
+	.max_avg_dram_bw_use_normal_percent = 40.0,
+	.writeback_latency_us = 12.0,
+	.ideal_dram_bw_after_urgent_percent = 40.0,
+	.max_request_size_bytes = 256,
+	.dram_channel_width_bytes = 16,
+	.fabric_datapath_to_dcn_data_return_bytes = 64,
+	.dcn_downspread_percent = 0.5,
+	.downspread_percent = 0.5,
+	.dram_page_open_time_ns = 50.0,
+	.dram_rw_turnaround_time_ns = 17.5,
+	.dram_return_buffer_per_channel_bytes = 8192,
+	.round_trip_ping_latency_dcfclk_cycles = 131,
+	.urgent_out_of_order_return_per_channel_bytes = 4096,
+	.channel_interleave_bytes = 256,
+	.num_banks = 8,
+	.num_chans = 16,
+	.vmm_page_size_bytes = 4096,
+	.dram_clock_change_latency_us = 45.0,
+	.writeback_dram_clock_change_latency_us = 23.0,
+	.return_bus_width_bytes = 64,
+	.dispclk_dppclk_vco_speed_mhz = 3850,
+	.xfc_bus_transport_time_us = 20,
+	.xfc_xbuf_latency_tolerance_us = 50,
+	.use_urgent_burst_bw = 0,
+};
 
 struct _vcs_dpi_ip_params_st dcn2_1_ip = {
 	.odm_capable = 1,



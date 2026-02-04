Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA7928B7EA;
	Wed,  4 Feb 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216561; cv=none; b=D0IcDtjglrOBUBewf+OLCHe+cCHASsIyN68nd1VqUys2iTRjjt7qshSgkVa/NScUaau19VvDzAuPMFh4AxcDj2SdUk8DOpeqZBqdeGDNNeZ5nL/Yf9gLjLDu5uOCPXkUq3/vTgDRHgJXNwVQRXRvD0BbsIGZSlIfcBGSlzoB95c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216561; c=relaxed/simple;
	bh=//9KM3w2ybjMBU9saNbAplFdkauI4N/pPqLMuBKBK+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2M78SQDjNujS0viwwOdH389FpIRCPJxjjv9wluYMqIk0WTF7/FOsx5pl1c0i4Mr5ndNi08kqjmv5WLZF3wGOq5USNXqM2pXH/I6ka0I+t+fjfyp0RhXHzyiJDQ3Ntb6NRqHPfcRYIM/jyGM3F8zVSwRQ+n/b8YFJAK258SajMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWZ5eIRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWZ5eIRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB28AC4CEF7;
	Wed,  4 Feb 2026 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216561;
	bh=//9KM3w2ybjMBU9saNbAplFdkauI4N/pPqLMuBKBK+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWZ5eIReK8nraUiT8Yf/g9fw5UCiD0bNdS/cp0G4Gk3IVlwoXW7OBv5s2lASOsF/z
	 MFPYGwlK6+eGKIHDyqXBfGYTiVz0awAHFTQJ0x5TWcpXp4D9Wgqv9s0qRESXJHHATX
	 sLumQoOZUy7XqZGs3eDbHRV7t64EA+yhRGWFOVGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saeed Mahameed <saeedm@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/161] net/mlx5: Add HW definitions of vport debug counters
Date: Wed,  4 Feb 2026 15:39:47 +0100
Message-ID: <20260204143856.206678314@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 3e94e61bd44d90070dcda53b647fdc826097ef26 ]

total_q_under_processor_handle - number of queues in error state due to an
async error or errored command.

send_queue_priority_update_flow - number of QP/SQ priority/SL update
events.

cq_overrun - number of times CQ entered an error state due to an
overflow.

async_eq_overrun -number of time an EQ mapped to async events was
overrun.

comp_eq_overrun - number of time an EQ mapped to completion events was
overrun.

quota_exceeded_command - number of commands issued and failed due to quota
exceeded.

invalid_command - number of commands issued and failed dues to any reason
other than quota exceeded.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 476681f10cc1 ("net/mlx5e: Account for netdev stats in ndo_get_stats64")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 88dbb20090805..303cbf0355a2e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1282,7 +1282,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0xa];
+	u8         reserved_at_130[0x9];
+	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
 	u8         reserved_at_140[0x6];
@@ -1472,7 +1473,11 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         nic_receive_steering_discard[0x1];
 	u8         receive_discard_vport_down[0x1];
 	u8         transmit_discard_vport_down[0x1];
-	u8         reserved_at_343[0x5];
+	u8         eq_overrun_count[0x1];
+	u8         reserved_at_344[0x1];
+	u8         invalid_command_count[0x1];
+	u8         quota_exceeded_count[0x1];
+	u8         reserved_at_347[0x1];
 	u8         log_max_flow_counter_bulk[0x8];
 	u8         max_flow_counter_15_0[0x10];
 
@@ -3128,11 +3133,21 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         transmit_discard_vport_down[0x40];
 
-	u8         reserved_at_140[0xa0];
+	u8         async_eq_overrun[0x20];
+
+	u8         comp_eq_overrun[0x20];
+
+	u8         reserved_at_180[0x20];
+
+	u8         invalid_command[0x20];
+
+	u8         quota_exceeded_command[0x20];
 
 	u8         internal_rq_out_of_buffer[0x20];
 
-	u8         reserved_at_200[0xe00];
+	u8         cq_overrun[0x20];
+
+	u8         reserved_at_220[0xde0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
-- 
2.51.0




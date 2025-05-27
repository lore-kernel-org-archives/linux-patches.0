Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3124A26F469;
	Tue, 27 May 2025 17:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366341; cv=none; b=aVZwiQmPdKxDLFkyzRbnSPW5wgK7/kMMJTCb9UwViK/2GT+MZqmvHtMJjWLwUD2y8DTlqeDiGtEPKLpMUbcpMrWxCQlbH9yexge8JnLGYZCJoIM7kPZ3ZZFQna/6FjbuJqHqx2bnHWqcbowG/KGESBwAGJ/2A5NJMLoM/SGyqHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366341; c=relaxed/simple;
	bh=yldAQB1/NrU8HpMLiqUEuc2MmO5u7wgHvJEUkrG2MLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQgIdW/PEcz3mYKg7EIj6fyXqABWFrEP2E2n+zWPWsWPj/vZ8ieETraJ1D2pxbJ7mY5tOQD7RwofEAH8qwIDclVEPgg7s0fw+9OI1R49lYNdTKk2JmJRDGtdIaxf/eSWQIhi3fzPCBVDVBZHJhR+UWNd9Gtq9czPq9SMZj8GhKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYfIhaUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYfIhaUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9397EC4CEE9;
	Tue, 27 May 2025 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366341;
	bh=yldAQB1/NrU8HpMLiqUEuc2MmO5u7wgHvJEUkrG2MLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYfIhaUmRrC9+x4OtS2gMmk2DlDFC0Qtiwdyk3B7p5OO6KNxAS9BNwaI9oX3j2+93
	 WNBhB/Am7kHoq29NrSUczXMHDiB81Xz7KLCBgyifJmYIK2t7oswkwARZKO6pX9QoX1
	 oGm81cIml074d6JdUjfzAakdYmHB4I1kWA3qelJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Nicholas Susanto <nsusanto@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Mark Broadworth <mark.broadworth@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 036/783] drm/amd/display: Enable urgent latency adjustment on DCN35
Date: Tue, 27 May 2025 18:17:13 +0200
Message-ID: <20250527162514.597048075@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Susanto <nsusanto@amd.com>

[ Upstream commit 756c85e4d0ddc497b4ad5b1f41ad54e838e06188 ]

[Why]

Urgent latency adjustment was disabled on DCN35 due to issues with P0
enablement on some platforms. Without urgent latency, underflows occur
when doing certain high timing configurations. After testing, we found
that reenabling urgent latency didn't reintroduce p0 support on multiple
platforms.

[How]

renable urgent latency on DCN35 and setting it to 3000 Mhz.

This reverts commit 3412860cc4c0c484f53f91b371483e6e4440c3e5.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Nicholas Susanto <nsusanto@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cd74ce1f0cddffb3f36d0995d0f61e89f0010738)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
index 47d785204f29c..beed7adbbd43e 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
@@ -195,9 +195,9 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_5_soc = {
 	.dcn_downspread_percent = 0.5,
 	.gpuvm_min_page_size_bytes = 4096,
 	.hostvm_min_page_size_bytes = 4096,
-	.do_urgent_latency_adjustment = 0,
+	.do_urgent_latency_adjustment = 1,
 	.urgent_latency_adjustment_fabric_clock_component_us = 0,
-	.urgent_latency_adjustment_fabric_clock_reference_mhz = 0,
+	.urgent_latency_adjustment_fabric_clock_reference_mhz = 3000,
 };
 
 void dcn35_build_wm_range_table_fpu(struct clk_mgr *clk_mgr)
-- 
2.39.5




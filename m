Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757B31F3FFE;
	Tue, 21 Jan 2025 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482565; cv=none; b=SSWgPSHMuXPKaelXpHcmtqlBsqgl+qTTtaHaGycHfdLSw//c8MMdlymnwY1MUXfVqkLc+OhGXnPh7mA4kFJ/UL7qqruSda8NgmrbPGwNhrmuyp+YcYPG2k+7Z4OoXjvCNkz97CCbARBi5iIi3qExp1yOj+KxUTZS7D8p0vI7tus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482565; c=relaxed/simple;
	bh=pC91bgrX18y2Ey7N9DKAM5W4twk8wCaD7d5LCeB8aos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cizg+f/gNfAvN1CYvzk4j5euMW5XW0APJVLHyGHy5NcGbZjoI/yF6sBbSp4zR+Yn/+fSYO0rgu57AU8wsIC/tFAFKHiYI08X6YF7JrQFsznwIePGFkthytRVQTYq8OYGte7CVhKKW+QzHxd8/y0WIZ/6ff4DNBbhd6AjGCJ8wk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tC8n/JjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tC8n/JjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A34C4CEDF;
	Tue, 21 Jan 2025 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482565;
	bh=pC91bgrX18y2Ey7N9DKAM5W4twk8wCaD7d5LCeB8aos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC8n/JjR/DCGmTpu5y4JXxDSEjkmQ2g687Sz81c4h4U/E9znZlAt83vwjossmmLXg
	 8wmkFuFgcn4YA6yByrpd03B/tJr9ibrkYuOxTS7ImhZd3Dayk5RyY+BWzwJQZbojbk
	 d303VuyyC9phIe1vCLEvL3OfMIlwK9srxzc+yIKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Nicholas Susanto <Nicholas.Susanto@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 120/122] Revert "drm/amd/display: Enable urgent latency adjustments for DCN35"
Date: Tue, 21 Jan 2025 18:52:48 +0100
Message-ID: <20250121174537.687113589@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Susanto <Nicholas.Susanto@amd.com>

commit 3412860cc4c0c484f53f91b371483e6e4440c3e5 upstream.

Revert commit 284f141f5ce5 ("drm/amd/display: Enable urgent latency adjustments for DCN35")

[Why & How]

Urgent latency increase caused  2.8K OLED monitor caused it to
block this panel support P0.

Reverting this change does not reintroduce the netflix corruption issue
which it fixed.

Fixes: 284f141f5ce5 ("drm/amd/display: Enable urgent latency adjustments for DCN35")
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Nicholas Susanto <Nicholas.Susanto@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c7ccfc0d4241a834c25a9a9e1e78b388b4445d23)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn35/dcn35_fpu.c
@@ -195,9 +195,9 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 	.dcn_downspread_percent = 0.5,
 	.gpuvm_min_page_size_bytes = 4096,
 	.hostvm_min_page_size_bytes = 4096,
-	.do_urgent_latency_adjustment = 1,
+	.do_urgent_latency_adjustment = 0,
 	.urgent_latency_adjustment_fabric_clock_component_us = 0,
-	.urgent_latency_adjustment_fabric_clock_reference_mhz = 3000,
+	.urgent_latency_adjustment_fabric_clock_reference_mhz = 0,
 };
 
 void dcn35_build_wm_range_table_fpu(struct clk_mgr *clk_mgr)



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AAC226D18;
	Mon, 18 Aug 2025 13:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523787; cv=none; b=nH5EVVxzuLLz2kYnNxb/F8/vF+59L8reFKvaAHIXaTRM3f0lz+kWmNcqgC1BuwqFFN49UOdQIp59k+fSO75GeqJp/vP9mCe+MsnPqaHjtLTueRNar632/ogIyZDgHWi/os/VCHSZOMlrFe5K7cMlSF6wxnbeGW2by5kRSDt5GeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523787; c=relaxed/simple;
	bh=6NL+uRW92AhhKi4hEL+snRvTE/kRrw13BkTXpXEoJDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qaipi6bLkVQSTXICsOVJu4gtfmsgyWozPXksvzL7eP0Z5D7AXOzjiK4xmv4T8Gl90d7m/KqUEmtNKv+WNUHvPO4jrcoYK3OJLXkSCC0ZRccn1ULeieYyOC5k0nkzTFVQKxosC8ObX1z0xvAd4BvbOn/VY5NlkixKfJA3bGlNAF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po7RvYzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po7RvYzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6B5C4CEEB;
	Mon, 18 Aug 2025 13:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523785;
	bh=6NL+uRW92AhhKi4hEL+snRvTE/kRrw13BkTXpXEoJDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po7RvYzRXplbFARySHc1YhWjltbdWEEQaFtHRkvon63vsfdnoWpcjQYGFA3Vawwvl
	 GS7uvjDWwedOCB11CpxabiW3jOZHPCpng7olfVTlQtmGvLpziqY0K8o1K+xuCGjzV1
	 myS04RQFcFQmNzOKPx2cu4LU9RMNs7rvIkILV3EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cruise Hung <cruise.hung@amd.com>,
	Peichen Huang <PeiChen.Huang@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 273/515] drm/amd/display: add null check
Date: Mon, 18 Aug 2025 14:44:19 +0200
Message-ID: <20250818124508.929544587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peichen Huang <PeiChen.Huang@amd.com>

[ Upstream commit 158b9201c17fc93ed4253c2f03b77fd2671669a1 ]

[WHY]
Prevents null pointer dereferences to enhance function robustness

[HOW]
Adds early null check and return false if invalid.

Reviewed-by: Cruise Hung <cruise.hung@amd.com>
Signed-off-by: Peichen Huang <PeiChen.Huang@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index d6f0c82d8dda..ff94ceea2218 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -6265,11 +6265,13 @@ struct dc_power_profile dc_get_power_profile_for_dc_state(const struct dc_state
  */
 bool dc_get_host_router_index(const struct dc_link *link, unsigned int *host_router_index)
 {
-	struct dc *dc = link->ctx->dc;
+	struct dc *dc;
 
-	if (link->ep_type != DISPLAY_ENDPOINT_USB4_DPIA)
+	if (!link || !host_router_index || link->ep_type != DISPLAY_ENDPOINT_USB4_DPIA)
 		return false;
 
+	dc = link->ctx->dc;
+
 	if (link->link_index < dc->lowest_dpia_link_index)
 		return false;
 
-- 
2.39.5




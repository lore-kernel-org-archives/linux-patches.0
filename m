Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9D7234984;
	Mon, 18 Aug 2025 13:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525540; cv=none; b=tZKwbCDoE6Q/OJBGM88gDkVpeXigEOQ3x0+Ela7y1984VkMi1b9zDitERHcBpsUFa+lWgVLvpQryweJrW+LTuvf/+068MY92hCsR2n/juNguVGjqPuuI4K1WPmaz5nePDhf8W/U5Y9lPNuHeOJkUsy6cXkXUaARrAYT26Y2YK5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525540; c=relaxed/simple;
	bh=iJ6oi0x/p7B3RnSHVD5ijc1EzMbwxJyDasH6QQEid/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF+Y7gRuQebroHWK7M9ItFUOgCK9tBMbb7KV0NrOCRCKquWF3ZE1PXjCIt64Z/QOI3EH+Kt/7/Q7L65HcOoHTp6912Bkt+WXUdVI/NCQ4GFNi3/NDguJuyEpFojCId7znzOcaeZtrPCk+ZuEiIepzkymF7wi1ZbUR3T7BolZ7Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqmocDcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqmocDcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE1FC4CEEB;
	Mon, 18 Aug 2025 13:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525540;
	bh=iJ6oi0x/p7B3RnSHVD5ijc1EzMbwxJyDasH6QQEid/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqmocDcmIGvfW3RWgjd/lwFe6Yr8js7zTRB9IBHGjkOFgD14gIGSI5lCJioFLrn9B
	 x2KxD3G9YQ4Ff2vA8Z9S9R0GSPm8iBMIc2xFc42lt8alQmvWMn0vckeZ+ikMebm8Mr
	 aW1UjjoQKi8jJlux0nQoqpCRG+rPsk5LgAt41Zao=
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
Subject: [PATCH 6.16 293/570] drm/amd/display: add null check
Date: Mon, 18 Aug 2025 14:44:40 +0200
Message-ID: <20250818124517.134347750@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 3dd7e2b6d530..943ebd5c79e3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -6394,11 +6394,13 @@ unsigned int dc_get_det_buffer_size_from_state(const struct dc_state *context)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51984306B39;
	Tue, 11 Nov 2025 01:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823897; cv=none; b=frgixaBzxl1TgsfrHy5fIvH0Xe7t5TflBO7yRwqCjbO/S50i12Nb9lZptHKLl6GA6q0jd0tee2A1kGqLqqAeSXWTrxj0ZZPzhRtrDfUZDduJqq8a9MDzIGWXA+x5SjWsDn3V26ZmlkN9bWMavIL5g9ZCiErgTFpdEPr+iF4UB/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823897; c=relaxed/simple;
	bh=8uUu4oCba0J3A6r0hmJ6+RDLJb0CAWz/JtbeLEVNsyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSdt/ua/gV/tcTOhMAk+fiOhL2MWP2SG6eHqHAcrX6SmRVyG6rydFx+R0qUi4XOwaH+IrtVgtYkrAVy1pQ+NCqetHxlmyi+UZSOkfdjcJQxrgaBLCrJM9YAYiIobv6vwhdAB68rtU9gtdyS27e0xhgErD1XgrDxGC6esqHZttmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRX20t5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRX20t5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8114DC16AAE;
	Tue, 11 Nov 2025 01:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823896;
	bh=8uUu4oCba0J3A6r0hmJ6+RDLJb0CAWz/JtbeLEVNsyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRX20t5rD+/K3AXcyeiS+ViHeIMsRDCJOfsZzabAAWBBmT494GihOAIf9InQl2RAA
	 xnXtDLffWYRVME0ryeQzOr+GQRqLKJ2h59im0wEu2UuHpQsctI0BrasevuegEwG1oy
	 6SHUwwRlmE3neawU8l39EawtkfM1bNo4KrkZ/S/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Clay King <clayking@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 393/849] drm/amd/display: incorrect conditions for failing dto calculations
Date: Tue, 11 Nov 2025 09:39:23 +0900
Message-ID: <20251111004545.937874758@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clay King <clayking@amd.com>

[ Upstream commit 306cbcc6f687d791ab3cc8fbbe30f5286fd0d1e5 ]

[Why & How]
Previously, when calculating dto phase, we would incorrectly fail when phase
<=0 without additionally checking for the integer value. This meant that
calculations would incorrectly fail when the desired pixel clock was an exact
multiple of the reference clock.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Clay King <clayking@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c b/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
index 668ee2d405fdf..0b8ed9b94d3c5 100644
--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn401/dcn401_dccg.c
@@ -619,7 +619,7 @@ void dccg401_set_dp_dto(
 		dto_integer = div_u64(params->pixclk_hz, dto_modulo_hz);
 		dto_phase_hz = params->pixclk_hz - dto_integer * dto_modulo_hz;
 
-		if (dto_phase_hz <= 0) {
+		if (dto_phase_hz <= 0 && dto_integer <= 0) {
 			/* negative pixel rate should never happen */
 			BREAK_TO_DEBUGGER();
 			return;
-- 
2.51.0




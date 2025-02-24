Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF89151998;
	Mon, 24 Feb 2025 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408302; cv=none; b=G8zuRM+NjNk0mR+2nFE09iJx12+ZSLnEawmQjFzvs2uwCK6uKj6vREgoFlA7a+9RUAKx68g/aHrl4WCzhjv/m309SxOsukpvnbzzs9Umc4DwGFmub5nW9hy31D5Qxhv+DH/VKMOf63AeKGAjQFYnlKUgb92xL95n6P0idwWbHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408302; c=relaxed/simple;
	bh=9XD5Kwlkw331ukH35WIt7v4bJXXiLnvlzr9/Z+jGTAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+0tpd6aONKrfLeRopfeIr8+f4XpyjdLCPcCHTw+4/s6Ci6pnMTj0UyxpCfYYPcYXidn8kmrEIexnYhAvetZt/MHTXgYP1vgnakjEEl/pdDN5jeHwQyZGSS08nCFDfSwfrH+uiLYZjGGXhgF3YfII22kkPhB3H9GHnNDgsZ4nWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6lOdX8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6lOdX8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9573AC4CED6;
	Mon, 24 Feb 2025 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408302;
	bh=9XD5Kwlkw331ukH35WIt7v4bJXXiLnvlzr9/Z+jGTAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6lOdX8Ty+L83+MaqDMRDLQgmsU43GANqXankkHKnPC4PIoWfCwS56Jp2ZZPwziGK
	 4HDhGX3z3ptjtaRFcv4Zdqf347QTRnF8hA/9J/lUH7e8Abcf3PShrEkQLXIvja0gKY
	 BSiLyBjUpM0wMKB2wzy93aJZspkmMKIJHHgUVCUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mounika Adhuri <mounika.adhuri@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Lohita Mudimela <lohita.mudimela@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/154] drm/amd/display: Refactoring if and endif statements to enable DC_LOGGER
Date: Mon, 24 Feb 2025 15:33:37 +0100
Message-ID: <20250224142607.792668445@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Lohita Mudimela <lohita.mudimela@amd.com>

[ Upstream commit b04200432c4730c9bb730a66be46551c83d60263 ]

[Why]
For Header related changes for core

[How]
Refactoring if and endif statements to enable DC_LOGGER

Reviewed-by: Mounika Adhuri <mounika.adhuri@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Lohita Mudimela <lohita.mudimela@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: f88192d2335b ("drm/amd/display: Correct register address in dcn35")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c    | 5 +++--
 .../gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c  | 6 +++---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c    | 1 +
 .../drm/amd/display/dc/link/protocols/link_dp_capability.c  | 3 ++-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
index e93df3d6222e6..bc123f1884da3 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn31/dcn31_clk_mgr.c
@@ -50,12 +50,13 @@
 #include "link.h"
 
 #include "logger_types.h"
+
+
+#include "yellow_carp_offset.h"
 #undef DC_LOGGER
 #define DC_LOGGER \
 	clk_mgr->base.base.ctx->logger
 
-#include "yellow_carp_offset.h"
-
 #define regCLK1_CLK_PLL_REQ			0x0237
 #define regCLK1_CLK_PLL_REQ_BASE_IDX		0
 
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
index 29eff386505ab..91d872d6d392b 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn314/dcn314_clk_mgr.c
@@ -53,9 +53,6 @@
 
 
 #include "logger_types.h"
-#undef DC_LOGGER
-#define DC_LOGGER \
-	clk_mgr->base.base.ctx->logger
 
 
 #define MAX_INSTANCE                                        7
@@ -77,6 +74,9 @@ static const struct IP_BASE CLK_BASE = { { { { 0x00016C00, 0x02401800, 0, 0, 0,
 					{ { 0x0001B200, 0x0242DC00, 0, 0, 0, 0, 0, 0 } },
 					{ { 0x0001B400, 0x0242E000, 0, 0, 0, 0, 0, 0 } } } };
 
+#undef DC_LOGGER
+#define DC_LOGGER \
+	clk_mgr->base.base.ctx->logger
 #define regCLK1_CLK_PLL_REQ			0x0237
 #define regCLK1_CLK_PLL_REQ_BASE_IDX		0
 
diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index 3bd0d46c17010..bbdc39ae57b9d 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -55,6 +55,7 @@
 #define DC_LOGGER \
 	clk_mgr->base.base.ctx->logger
 
+
 #define regCLK1_CLK_PLL_REQ			0x0237
 #define regCLK1_CLK_PLL_REQ_BASE_IDX		0
 
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index d78c8ec4de79e..885e749cdc6e9 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -51,9 +51,10 @@
 #include "dc_dmub_srv.h"
 #include "gpio_service_interface.h"
 
+#define DC_TRACE_LEVEL_MESSAGE(...) /* do nothing */
+
 #define DC_LOGGER \
 	link->ctx->logger
-#define DC_TRACE_LEVEL_MESSAGE(...) /* do nothing */
 
 #ifndef MAX
 #define MAX(X, Y) ((X) > (Y) ? (X) : (Y))
-- 
2.39.5




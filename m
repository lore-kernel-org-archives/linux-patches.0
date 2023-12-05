Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087AB6110;
	Tue,  5 Dec 2023 03:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N71ZXjfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD80C433C7;
	Tue,  5 Dec 2023 03:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746715;
	bh=nM0n2/qtk8FlXqQ0XatNqjqg4manBbpHR50SHnMHFH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N71ZXjfATsiyzeN6iOMt+mlb71bQ5b5YGwgnYr7V40JGSf3B71P7xYgRcNqZInGbr
	 330LPKIhnHZ+TltmhhnByVzHGImZrIfCW4v8kuj89BQYz04unhOVj89+BIEFPigP7W
	 2nkZxP7IxNgEHjYA8j18ADvq2PDhsLdv+xPwpKGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agustin Gutierrez <agustin.gutierrez@amd.com>,
	Roman Li <roman.li@amd.com>,
	Swapnil Patel <swapnil.patel@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/134] drm/amd/display: Reduce default backlight min from 5 nits to 1 nits
Date: Tue,  5 Dec 2023 12:16:40 +0900
Message-ID: <20231205031543.563083819@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Swapnil Patel <swapnil.patel@amd.com>

[ Upstream commit 5edb7cdff85af8f8c5fda5b88310535ab823f663 ]

[Why & How]
Currently set_default_brightness_aux function uses 5 nits as lower limit
to check for valid default_backlight setting. However some newer panels
can support even lower default settings

Reviewed-by: Agustin Gutierrez <agustin.gutierrez@amd.com>
Acked-by: Roman Li <roman.li@amd.com>
Signed-off-by: Swapnil Patel <swapnil.patel@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: d9e865826c20 ("drm/amd/display: Simplify brightness initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/link/protocols/link_edp_panel_control.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
index e1708c296b7df..a602202610e09 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -281,8 +281,8 @@ bool set_default_brightness_aux(struct dc_link *link)
 	if (link && link->dpcd_sink_ext_caps.bits.oled == 1) {
 		if (!read_default_bl_aux(link, &default_backlight))
 			default_backlight = 150000;
-		// if < 5 nits or > 5000, it might be wrong readback
-		if (default_backlight < 5000 || default_backlight > 5000000)
+		// if < 1 nits or > 5000, it might be wrong readback
+		if (default_backlight < 1000 || default_backlight > 5000000)
 			default_backlight = 150000; //
 
 		return edp_set_backlight_level_nits(link, true,
-- 
2.42.0




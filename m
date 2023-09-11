Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E90211706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E73C433C8;
	Mon, 11 Sep 2023 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444506;
	bh=gPjyesZZ/t769mjN2hyEQUuXhQqHVE/8RRftuUGBXCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0IDHoh0/KAna9zSh1TKfE0XWrIx2UnnOT3x/PK0K7VKERUQ7yU/cFWud1eZ2vninN
	 8r9Tkh5woglByRDjaRaqG1WO7UVGq3sMw4rQF7g2Yz5Al6mduKrPjZiortfnLhn+TT
	 M/O3//zZw0psI92bunN8FVPIwy6FTsA1hTGlgJDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Jun Lei <jun.lei@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Daniel Miess <daniel.miess@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/600] Partially revert "drm/amd/display: Fix possible underflow for displays with large vblank"
Date: Mon, 11 Sep 2023 15:40:35 +0200
Message-ID: <20230911134633.699445714@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Miess <daniel.miess@amd.com>

[ Upstream commit a99a4ff6ef205d125002fc7e0857074e4e6597b6 ]

This partially reverts commit de231189e7bf ("drm/amd/display: Fix
possible underflow for displays with large vblank").

[Why]
The increased value of VBlankNomDefaultUS causes underflow at the
desktop of an IP KVM setup

[How]
Change the value from 800 back to 668

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Reviewed-by: Jun Lei <jun.lei@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Daniel Miess <daniel.miess@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
index 8a88605827a84..551a63f7064bb 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/dcn314_fpu.c
@@ -32,7 +32,7 @@
 #include "dml/display_mode_vba.h"
 
 struct _vcs_dpi_ip_params_st dcn3_14_ip = {
-	.VBlankNomDefaultUS = 800,
+	.VBlankNomDefaultUS = 668,
 	.gpuvm_enable = 1,
 	.gpuvm_max_page_table_levels = 1,
 	.hostvm_enable = 1,
-- 
2.40.1




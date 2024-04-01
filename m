Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8AB1C0DE7;
	Mon,  1 Apr 2024 16:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989089; cv=none; b=Qp1utf28hl9NS5gGpWLjLp/7uFOGeMHnMCXSkfW9qk2ypnthHOzpv8u9MLUyga8CmjvjNSpvaZZNTZMnbF4aBbzCf4XOEhWOHAReA0BJYRC6PrnA9pm9nb+pHb1c2uB8ULGAFFb5DHm26XhuvMRdBhLKi43Q0tMKTLzBr10X06s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989089; c=relaxed/simple;
	bh=h5VmkAyVKJD3IGjmmAxEC9TOfSIbDxN4OuBeKOtk4Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnbCS6O4+hHi/5aEAtgcxgKhl5hEIoD3BBVAtDUC9LXp6o7C3W6IWd7VNtWyI5C4y13yleaIpGAV+4e0TIb73UFLSkpdPhXFNlBmwjDLq0mg/EzJGBoiZ3hORR5tyfPM6l/wVRZdu08YyZVDu7d0HpjsD56f0TxKA+1mjBPL9I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1h+q9dx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1h+q9dx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28395C433F1;
	Mon,  1 Apr 2024 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989089;
	bh=h5VmkAyVKJD3IGjmmAxEC9TOfSIbDxN4OuBeKOtk4Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1h+q9dx+fRDxl1rwdaLSMVeExngQdejlPq/qwyGdLRU6eOGqLG/o2/NwISKc+btP5
	 e8y9Mgar1GJHs4vn2sQqiYGhD6PxDU6WVtnJPC5CsmQ49mmwSmmDSKV+e4+MPzNdt2
	 woGDxl/9Q6xpxcuqNbuzwHIaBnTtU9T5RpSBbD1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 377/432] drm/amd/display: Fix bounds check for dcn35 DcfClocks
Date: Mon,  1 Apr 2024 17:46:04 +0200
Message-ID: <20240401152604.532840946@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Li <roman.li@amd.com>

commit 2f10d4a51bbcd938f1f02f16c304ad1d54717b96 upstream.

[Why]
NumFclkLevelsEnabled is used for DcfClocks bounds check
instead of designated NumDcfClkLevelsEnabled.
That can cause array index out-of-bounds access.

[How]
Use designated variable for dcn35 DcfClocks bounds check.

Fixes: a8edc9cc0b14 ("drm/amd/display: Fix array-index-out-of-bounds in dcn35_clkmgr")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -705,7 +705,7 @@ static void dcn35_clk_mgr_helper_populat
 		clock_table->NumFclkLevelsEnabled;
 	max_fclk = find_max_clk_value(clock_table->FclkClocks_Freq, num_fclk);
 
-	num_dcfclk = (clock_table->NumFclkLevelsEnabled > NUM_DCFCLK_DPM_LEVELS) ? NUM_DCFCLK_DPM_LEVELS :
+	num_dcfclk = (clock_table->NumDcfClkLevelsEnabled > NUM_DCFCLK_DPM_LEVELS) ? NUM_DCFCLK_DPM_LEVELS :
 		clock_table->NumDcfClkLevelsEnabled;
 	for (i = 0; i < num_dcfclk; i++) {
 		int j;



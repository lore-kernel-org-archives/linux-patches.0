Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C0324EF7A;
	Mon, 24 Feb 2025 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408335; cv=none; b=D5OaMxQLkV+xeymbdhFZDuOOw5/PybkK83rtXRm21bgxlqtRYhcKO9pny00sUzIoMLyeFbq/5r7X4IY042bSAXNC0URpErjtR5DAqHaBM0i2A/0R1qcH2+0hjaiS6mKPuy9xNcVRTsZDc0CHvjTfRITwVZNVwZl6Lrbnc2Y5AKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408335; c=relaxed/simple;
	bh=FB2cvsK0NWOa+qQ3Uu9XhKpcj2Luo9dHUjQQAjieDyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QT8GOq78Y/DL3imYZOYG7A8Syd4+Ulg8Wlb6jwN891E8ABCvlGZVbF8Z0h9qS6u1ENSne+8uNG9YNiOK/hT2AfvepeCTy4tsoe9gcKMUPTb/f/OTE00Pipr7sdkq/RjasWSvY7RFmsDiuxcubQROsSA4OjDmUBxC+C/gEB56lrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvZBEVeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvZBEVeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9934CC4CED6;
	Mon, 24 Feb 2025 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408335;
	bh=FB2cvsK0NWOa+qQ3Uu9XhKpcj2Luo9dHUjQQAjieDyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvZBEVeGd6aU2UcFd8oaT3ntSvWU7TyCXU3iczPSLe0nV6UBjMsPMptKCW2nGm/cD
	 BA9aOTzKRn9/Y3U/D/p+6kH/EyQo2ejR9eiKhw8bHueNkwBZnLzJPPjn99Ivuw0pTM
	 UdRDtMXNDMDQ4t1C9NDRQhJvLMO4kmiC4vfJsPR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Lo-An Chen <lo-an.chen@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/154] drm/amd/display: Correct register address in dcn35
Date: Mon, 24 Feb 2025 15:33:39 +0100
Message-ID: <20250224142607.871530410@linuxfoundation.org>
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

From: loanchen <lo-an.chen@amd.com>

[ Upstream commit f88192d2335b5a911fcfa09338cc00624571ec5e ]

[Why]
the offset address of mmCLK5_spll_field_8 was incorrect for dcn35
which causes SSC not to be enabled.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Lo-An Chen <lo-an.chen@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index d8a4cdbb5495d..7d0d8852ce8d2 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -89,7 +89,7 @@
 #define mmCLK1_CLK4_ALLOW_DS 0x16EA8
 #define mmCLK1_CLK5_ALLOW_DS 0x16EB1
 
-#define mmCLK5_spll_field_8 0x1B04B
+#define mmCLK5_spll_field_8 0x1B24B
 #define mmDENTIST_DISPCLK_CNTL 0x0124
 #define regDENTIST_DISPCLK_CNTL 0x0064
 #define regDENTIST_DISPCLK_CNTL_BASE_IDX 1
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82769BE5A;
	Tue,  2 Jul 2024 17:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940170; cv=none; b=tzlueQY0EqV8/dXP+S7h5AlyTqbxMwPyqcfbLfFE1C0rnCc5ibX6v3Q/WMJr8avgthWIB7C68GhJ0sY1r6ZDV3HrnQH3qZNPY06yO8qDONfCKffFOCv++HTym8PyjecbSK3GnfbhcI/BRWFIz+LabBXMhu+E35GIwx2RKpNhddg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940170; c=relaxed/simple;
	bh=492McN/CjzrLjcLZqCyGBjvPIlwSXqtHkrCVuVUfLCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JC67aIiYps1rBPG7o8gQmZSRDrSpWeQbRVbj9gt4T67imzwFSI7p5a0DFWhUElGIP5zdRqtJtD3+DUNIfhRVUk4Stqzrllyhzv0v97CS15VT8V7vrAcQdwYqLOYe0vTdzxearU0Ikg0esylSLrjBePVIMh6CL8+JDKjYzwop+Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0FSnhdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0FSnhdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000E7C116B1;
	Tue,  2 Jul 2024 17:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940170;
	bh=492McN/CjzrLjcLZqCyGBjvPIlwSXqtHkrCVuVUfLCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0FSnhdlI7KgZ4/9aBGWOhEefBnY/WSzZ9/TwDrCK7rCCpBSPz+nnqKVihInBUGsF
	 Sq8Ddy1rmBtC0DHrKjDNs1NLmMiaZg59Wrl8tKySjOA5bYG2eaDcwCjarmwHt2zcsE
	 TZ6YSGMMepIGvKEj+PhG3efV808vVb4QoOEXLV8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Sherry Wang <Yao.Wang1@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 073/222] drm/amd/display: correct hostvm flag
Date: Tue,  2 Jul 2024 19:01:51 +0200
Message-ID: <20240702170246.771225948@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Wang <Yao.Wang1@amd.com>

[ Upstream commit 3a13d1fddaf51b98cdba20b486cb8fd6080b71b7 ]

[Why]
Hostvm should be enabled/disabled accordding to the status of
riommu_active, but hostvm always be disabled on DCN31 which causes
underflow

[How]
Set correct hostvm flag on DCN31

Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Sherry Wang <Yao.Wang1@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
index 04d142f974745..2fb1d00ff9654 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
@@ -892,7 +892,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.disable_z10 = true,
 	.enable_legacy_fast_update = true,
 	.enable_z9_disable_interface = true, /* Allow support for the PMFW interface for disable Z9*/
-	.dml_hostvm_override = DML_HOSTVM_OVERRIDE_FALSE,
+	.dml_hostvm_override = DML_HOSTVM_NO_OVERRIDE,
 	.using_dml2 = false,
 };
 
-- 
2.43.0




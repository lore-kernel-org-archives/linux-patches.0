Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA321991CE;
	Thu,  6 Jun 2024 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683166; cv=none; b=YmWToN61GI0v6JADeoEMG01Jlv2wHQwp6TYWfjt47UEjuJZURgVdrOr/uO9b8Vnc42CyZMr12LkCxaW5VT2P0xphm1Th/cbvubda+gMUvtvPZnjfkniArmDq+pRoSFy9ZyCQCVvXvU21ZNu3eK/gw+0RbqENbUs/VACY9sRj6qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683166; c=relaxed/simple;
	bh=iOZe5F6jCHlIxR1E7nphmlmdMJsZc4nW/uKBFjOxKSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4Sp2W+ho4Yp6Y8i3tM0crxxJbGlfx8HBtYXQMTc5PrfhqzMq9LRHNoiemhnnsLZJxLJB29Wi8z3k+Wpapxn7u740h3G3WLJ3Jwcc7c2tQtr20fbvUflB1kqIJJ/g9ZBLTTfSoXnto3gK+zhjHywCS1q1zk5fLU74MIbKCQ3nKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cT3710xL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cT3710xL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B845C2BD10;
	Thu,  6 Jun 2024 14:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683166;
	bh=iOZe5F6jCHlIxR1E7nphmlmdMJsZc4nW/uKBFjOxKSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cT3710xLLYZg65pkAil880I90s9wLA39SBhiFNUhM5INEwiHkMCQeP+BSctk/YoA3
	 DkIRyWw1c11R0EbH5GBqCoznjGAepYmn9S4PZDhs45lpaQVcvbt5ff3ydNMsUI+bn+
	 rvKyecsgY9Ly3wMUdIVyKuavCpalQDSjbBptXjPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Koo <anthony.koo@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Sung Joon Kim <sungjoon.kim@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/744] drm/amd/display: Disable seamless boot on 128b/132b encoding
Date: Thu,  6 Jun 2024 15:55:53 +0200
Message-ID: <20240606131735.001691001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Sung Joon Kim <sungjoon.kim@amd.com>

[ Upstream commit 6f0c228ed9184287031a66b46a79e5a3d2e73a86 ]

[why]
preOS will not support display mode programming and link training
for UHBR rates.

[how]
If we detect a sink that's UHBR capable, disable seamless boot

Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Sung Joon Kim <sungjoon.kim@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 46b10ff8f6d41..72db370e2f21f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1710,6 +1710,9 @@ bool dc_validate_boot_timing(const struct dc *dc,
 		return false;
 	}
 
+	if (link->dpcd_caps.channel_coding_cap.bits.DP_128b_132b_SUPPORTED)
+		return false;
+
 	if (dc->link_srv->edp_is_ilr_optimization_required(link, crtc_timing)) {
 		DC_LOG_EVENT_LINK_TRAINING("Seamless boot disabled to optimize eDP link rate\n");
 		return false;
-- 
2.43.0




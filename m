Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FC1222D59;
	Thu, 12 Dec 2024 15:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018819; cv=none; b=eCM9+uJEwfw5c1L7w5A+iK5+yncnMljVljB2FDKyVGg8ruKzQX1EjsXGm4aUFGifIrVRdzH3LA5bO2WnnzXPmumd8oCY3h5+6T1IKfuQy8WL0Tp6lLL2swbMvDY04vemVR/zkPLQkeVHl8PimeZyNjj7u0tHQBKx0w5c5XNPb2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018819; c=relaxed/simple;
	bh=nJC3YtPubtisH3cFKzCxhSsEbxsN8N/rIeCcn7Jwhb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0XMGcUa9HLJHcZYZIAetrFqH9bFhI52l8ivFLk4ILHQr28r1DCbwSRQaFK1wzRMQ4JtPJoj39oeZvKsebw25DFOyuk8iKkIpN8b/D6WZpD5yC3ytRhjd1jT3yEWyodSCyv9Qu5Qpg/uXPAk9CI3JhCPeYxbMXtAB2pqpSDkOYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBNCFd6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBNCFd6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F6CC4CED0;
	Thu, 12 Dec 2024 15:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018819;
	bh=nJC3YtPubtisH3cFKzCxhSsEbxsN8N/rIeCcn7Jwhb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBNCFd6iOZMwJKLjTWvyKSPXox0WH6w/YFT3XpIFhelq+BuMkL0wytMsv+9i7ROwp
	 pNbp+gMkFR8WMmg+zeMviTI2mHbOiDK3cE317PFn5iYSrbRSC8DCSzPN4IUKs1ndHk
	 SfVpx96h+BoSgPQVDd7Js1FMwnCfO+gqddIdme/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/772] drm/amd/display: Initialize denominators default to 1
Date: Thu, 12 Dec 2024 15:49:48 +0100
Message-ID: <20241212144351.715691212@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit b995c0a6de6c74656a0c39cd57a0626351b13e3c ]

[WHAT & HOW]
Variables used as denominators and maybe not assigned to other values,
should not be 0. Change their default to 1 so they are never 0.

This fixes 10 DIVIDE_BY_ZERO issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Xiangyu: Bp to fix CVE: CVE-2024-49899
Discard the dml2_core/dml2_core_shared.c due to this file no exists]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c   | 2 +-
 drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
index 548cdef8a8ade..543ce9a08cfd3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
@@ -78,7 +78,7 @@ static void calculate_ttu_cursor(struct display_mode_lib *mode_lib,
 
 static unsigned int get_bytes_per_element(enum source_format_class source_format, bool is_chroma)
 {
-	unsigned int ret_val = 0;
+	unsigned int ret_val = 1;
 
 	if (source_format == dm_444_16) {
 		if (!is_chroma)
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c b/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
index 3df559c591f89..70df992f859d7 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
@@ -39,7 +39,7 @@
 
 static unsigned int get_bytes_per_element(enum source_format_class source_format, bool is_chroma)
 {
-	unsigned int ret_val = 0;
+	unsigned int ret_val = 1;
 
 	if (source_format == dm_444_16) {
 		if (!is_chroma)
-- 
2.43.0




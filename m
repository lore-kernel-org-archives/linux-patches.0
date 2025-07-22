Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4572EBDE0;
	Tue, 22 Jul 2025 14:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193368; cv=none; b=paFIbtxTOmmtJeI/Ta8HZ+bz/TQzDE6rB5ZMD9qW3XKk3od3IS1cVFIDOlfMPs6AYR/HQn78QMm3RSmn7+Qqw24L23F+zRWlgVvW2gzQJGo2lG/8FVZdvActPR3VJh4StylIbrjeV1RQAEviGRtutjtOLAbLBHzNopBDsiU42vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193368; c=relaxed/simple;
	bh=nGyBaBzgERxbV7PMR+Tsxthb6b774a3Q5Il2tLdLhiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5ksjWX8T7IjhnLKPXJd8auOGQIvkiatoyQjyz2bBb1o/qyRFZo9Es8UcufQETI+OXjinky1665hE3Rv1/oA4200f+y2yIRBQ/vxwls6p+Vw6sNRJPe7jGb/xhSJ6quEhX79UX3c046PZyiEV9OB694A1Pj8Gm7SdRZtbuctjvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmMvq6MK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmMvq6MK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD19C4CEEB;
	Tue, 22 Jul 2025 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193367;
	bh=nGyBaBzgERxbV7PMR+Tsxthb6b774a3Q5Il2tLdLhiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmMvq6MKxmQ1c0riX5ILnwzhRgAsHPtLyETtqbMNBYCwkLvN4qUy1norUAQPacnOs
	 L8i3+4g2+Z4iABjvs6bop4WiNmDJ38ItpO4Gy9jkuFtBBhI9ctmlc7YKvnA9Fze9ZS
	 +f6JRD2F80QDJ1UC/iHQtYOBtMBPrbA+k+OVCJZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Aberback <joshua.aberback@amd.com>,
	Clayton King <clayton.king@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 037/187] drm/amd/display: Free memory allocation
Date: Tue, 22 Jul 2025 15:43:27 +0200
Message-ID: <20250722134347.139451101@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clayton King <clayton.king@amd.com>

commit b2ee9fa0fe6416e16c532f61b909c79b5d4ed282 upstream.

[WHY]

Free memory to avoid memory leak

Reviewed-by: Joshua Aberback <joshua.aberback@amd.com>
Signed-off-by: Clayton King <clayton.king@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fa699acb8e9be2341ee318077fa119acc7d5f329)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
@@ -1565,7 +1565,7 @@ struct clk_mgr_internal *dcn401_clk_mgr_
 	clk_mgr->base.bw_params = kzalloc(sizeof(*clk_mgr->base.bw_params), GFP_KERNEL);
 	if (!clk_mgr->base.bw_params) {
 		BREAK_TO_DEBUGGER();
-		kfree(clk_mgr);
+		kfree(clk_mgr401);
 		return NULL;
 	}
 
@@ -1576,6 +1576,7 @@ struct clk_mgr_internal *dcn401_clk_mgr_
 	if (!clk_mgr->wm_range_table) {
 		BREAK_TO_DEBUGGER();
 		kfree(clk_mgr->base.bw_params);
+		kfree(clk_mgr401);
 		return NULL;
 	}
 



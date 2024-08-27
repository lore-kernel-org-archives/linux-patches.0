Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C901CFEBC;
	Tue, 27 Aug 2024 15:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772657; cv=none; b=aPFTFXpJZFL0dccZdmYXuHzmbsrP5WxoDfU/tWfY9GbBOFRl4jwwXHHFmk4jxJbskD58XFOlPeIHPSSMBzX7mgTbkt5w83cETavYRMIwWnDA+5b5T9MZpscxtKVQBs9ovSxn6Dt9+XXYVORKnQE9SISmjHTGx431yCpYJ9Y0FnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772657; c=relaxed/simple;
	bh=cG9kFtvAITUWaMGiS3jei3JtbBbrdUJMMAxnPYnyk8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBD6/onfuupcug3SrA5RGa29jUOhGC80zsG64bdKfG615TXBBd9mkMlr5FloMtTeWtq46pksItDO7cRVYx1NqBkXOoZuVvAzrHUdHiN73zd3QYFDiW3weo1zUODfFCL6bJP3N0KCVgjSPo5xdSX2Gbw91CSBlgWhEMi0qpuE7Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeAg2dG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeAg2dG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DD9C4DDE9;
	Tue, 27 Aug 2024 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772657;
	bh=cG9kFtvAITUWaMGiS3jei3JtbBbrdUJMMAxnPYnyk8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeAg2dG64IEBWvu36Ys23Icc8E25APLZ6p+aUxed3ZqopU9CSVpmfUOU/ROLXB717
	 XZAGX5JBs/jaytpDyUriOMPqSXTsqZjrHxcvDeM4XtB7wu5Hz3DtpgvOtCj3r+dncw
	 15XsC4QUebIv6J0pJpmIxcMvoOWjaoQ0mK9WrUK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 281/321] Revert "drm/amd/display: Validate hw_points_num before using it"
Date: Tue, 27 Aug 2024 16:39:49 +0200
Message-ID: <20240827143848.946209421@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

commit 8f4bdbc8e99db6ec9cb0520748e49a2f2d7d1727 upstream.

This reverts commit 58c3b3341cea4f75dc8c003b89f8a6dd8ec55e50.

[WHY & HOW]
The writeback series cause a regression in thunderbolt display.

Signed-off-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dwb_cm.c
@@ -243,9 +243,6 @@ static bool dwb3_program_ogam_lut(
 		return false;
 	}
 
-	if (params->hw_points_num == 0)
-		return false;
-
 	REG_SET(DWB_OGAM_CONTROL, 0, DWB_OGAM_MODE, 2);
 
 	current_mode = dwb3_get_ogam_current(dwbc30);



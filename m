Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57D208A7;
	Sun,  1 Sep 2024 16:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209693; cv=none; b=oaTm5BiRpA6BJ1BXT+LDTEZjA41DO4HF9rSAh0m3I3LGWSOAtY0MgK2y82Egm9sobGOF9pO4/tkwunSB9KAjS0ytC2rDJXGuO3xof75cFa6cZTLNZJh+zFe4wJTKBxz9dorr2xlNMD0w+WXAvu5izrzj6DwcOCD2u5SDOHYJR5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209693; c=relaxed/simple;
	bh=fJRPSyThuURO/QFSC4grS883v4xTEbFpPJLQxx3Em0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3GFwb9CWPr8yr98Fx1V+uG4Wanp/cuVAcg04KXASIwmcIS05c/Np4tVlLVTePFk3aT5OT4q49iS8yeTQ0Eqag//1SgVJM9x2PSpcRwl7ZKJKp0caXLEhyqjnp66RnJ06kv/Nmey777sdBWII1faUw3NfUsaiHO4KqgaQPgIVRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxg/gwwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxg/gwwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D549AC4CEC3;
	Sun,  1 Sep 2024 16:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209693;
	bh=fJRPSyThuURO/QFSC4grS883v4xTEbFpPJLQxx3Em0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxg/gwwzKGAeSkIrSZWJdbdtzLIQUQJ1IIuMpbtbbkBOeVCRDJ6DQLDGBMf7lNyZk
	 9AbmiXD/wJj0FR0tv/80piz/35R9MNLeQK7wL2oh9uZUmryVPKPaCuEBQb1GSGMOEW
	 CaKwi2VD5J8ICOMCFdh2krqiTBp0SUd0V7X/R/9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 115/151] Revert "drm/amd/display: Validate hw_points_num before using it"
Date: Sun,  1 Sep 2024 18:17:55 +0200
Message-ID: <20240901160818.435500543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8278317C;
	Sun,  1 Sep 2024 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210368; cv=none; b=sZhB5KQYDF34zZ1VqT2kRgZa1FfrVmHx2QoHiI0Nb2F0ruBCgXPQT6jzszSt/duEUYDbE2JYhk1x1q3St8k8utmoay53jl+iSAK4ucmnHIv1VFxeaheHjGs446mqDkWIGlSH36LmvYxclNb8MS5IIuPpuFTN6FX1p1DdgzNiGIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210368; c=relaxed/simple;
	bh=8sxaB70xG92Vjx/X9qSnKADNaT5yXqNKjJypfZyDdec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHy4rP5Y6UMgv8B3IL6kf8n1KP4dRgggt2jMBL8GTk8Alwp7A6QD0KHa67n1EmjhlCh1wflhtOGpLyZQPM459kyL8ZAnLuykLNhZkSP2aEnlN1RtKNidhVdXPTKV98R5OsxZ+WUPdpx5bBNt6cvJHAC7dgJULJTff66AkqKQv7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1CszhFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1CszhFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026A4C4CEC3;
	Sun,  1 Sep 2024 17:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210368;
	bh=8sxaB70xG92Vjx/X9qSnKADNaT5yXqNKjJypfZyDdec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1CszhFZtvSsn2hZSOSqtyqc4KvgRnFII7ywG8cet/sU03VrTkB4XC/Z7RnZHV+Uh
	 1TUXNbwR5rggfKzgjEGM3/jq+W5qWt3iiWEtzQoATnzk0bBtGIBdRSQmNRVAE0GuPo
	 hQ8DaWmkrQ672v4JV+BvDhs6Y9x9FkBAxal2zc/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 167/215] Revert "drm/amd/display: Validate hw_points_num before using it"
Date: Sun,  1 Sep 2024 18:17:59 +0200
Message-ID: <20240901160829.671891739@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4245918D65C;
	Wed,  5 Mar 2025 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198204; cv=none; b=lDkyZMXGS7eGF2me3t1Xt537C06c31cMs/fN6NIm4UxAssMKpdeeuzD0J/1C1zSneRSnCJxIJwNy6PbI2k++MNuswd4SlWaoyiXjS8yOAMap5EoXhxlt0dLEUIWmGE2N5DmWBfidl7rGOMstwmU/saQa6InW1f3pBotozkJxJvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198204; c=relaxed/simple;
	bh=UAWBMUlS02RoNT1ir+yGhOVUjntPg16eBzbqaFa+khY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvQ/woCJcckC9WxRA4lgf+Jz96jau8CHWpxSBwJ56hixuG1gtRtMCoUOM5nti6suvY6pNeDwSkFoAvIUSSTT3853I58O2Nkj3b3PY634TVYxOXwA3YTLpoCKM2EqkvwuYR3GSwd22pVtV6kJVzw3JGA2R3CaRfU1F5XV3kjuz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMXZ6hlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMXZ6hlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CBBC4CEE0;
	Wed,  5 Mar 2025 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198203;
	bh=UAWBMUlS02RoNT1ir+yGhOVUjntPg16eBzbqaFa+khY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMXZ6hltRSXP1JdrDNW9gwosyeDs1vpO5K3yr7BRY2K4a6w7MNXkORKbBKbg4tw4g
	 8aZFk/yT5BlN7CWeSsFOC0MO1ef8rDQcVw2IUWcWedqrfjcDLskRck7rSx8FJjgf37
	 03S1bjd6RjWhrvov1o4knv16a6/Cxbqflh98mu3o=
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
Subject: [PATCH 6.12 099/150] drm/amd/display: Disable PSR-SU on eDP panels
Date: Wed,  5 Mar 2025 18:48:48 +0100
Message-ID: <20250305174507.787545088@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

commit e8863f8b0316d8ee1e7e5291e8f2f72c91ac967d upstream.

[Why]
PSR-SU may cause some glitching randomly on several panels.

[How]
Temporarily disable the PSR-SU and fallback to PSR1 for
all eDP panels.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3388
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6deeefb820d0efb0b36753622fb982d03b37b3ad)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -54,7 +54,8 @@ static bool link_supports_psrsu(struct d
 	if (amdgpu_dc_debug_mask & DC_DISABLE_PSR_SU)
 		return false;
 
-	return dc_dmub_check_min_version(dc->ctx->dmub_srv->dmub);
+	/* Temporarily disable PSR-SU to avoid glitches */
+	return false;
 }
 
 /*



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6B946444;
	Tue, 10 Sep 2024 09:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961726; cv=none; b=fdJB8Nun19q6dpbgX1Ss//qQqHfj9DPS5derFotxpyl0dkSN/JlvoQafwMF7a/gCGv/IOBOipe+G0cioIYRBa1IaGoJY/HWjsfNBUdIyQT9pzZyb2eScIbd44uI+JGq2IDLBN3sy7zK5S1oJ4Rzom7g1ya4yBczE0Ypyjx9U4wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961726; c=relaxed/simple;
	bh=6BRlDBYX3JN/8erFKomtD4TPYjYBPaturLuoGv/FohY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0cDR5BA51MG6ROJ9GivmjnrekmwsWQJuMXsEezgPge9xrQeusjwfWIR7m+UMlOxdvqKtlSL2yvD2lKek4j04Q7T3qbnuhknasMgdFHIli+L0Z/Z+xy8nYJD+LNb1Bha3ZmZx7bxRtMYudX1/r8LDdRvNAYDGuMEdmbskVbaeyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXmufjLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXmufjLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A33C4CEC6;
	Tue, 10 Sep 2024 09:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961726;
	bh=6BRlDBYX3JN/8erFKomtD4TPYjYBPaturLuoGv/FohY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXmufjLG+GiraRUUb70pjA+cbibp/AASPTAzFnxqUkzYAfMfccG/YnFrfkGlp7Vxn
	 DtJpOr6Kp1l1ghjKxmb25EgyHxNWQQ4EbigwmeoFkpI7k63vrX1EEqiv5YEYsgyyfP
	 wZ4ay1YS+qUdECCIc3KyyO9OKOn0DSUHTlS1or9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 141/375] drm/amd/display: Check denominator pbn_div before used
Date: Tue, 10 Sep 2024 11:28:58 +0200
Message-ID: <20240910092627.199842494@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 116a678f3a9abc24f5c9d2525b7393d18d9eb58e ]

[WHAT & HOW]
A denominator cannot be 0, and is checked before used.

This fixes 1 DIVIDE_BY_ZERO issue reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0627961b7115..27e641f17628 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7302,7 +7302,7 @@ static int dm_update_mst_vcpi_slots_for_dsc(struct drm_atomic_state *state,
 			}
 		}
 
-		if (j == dc_state->stream_count)
+		if (j == dc_state->stream_count || pbn_div == 0)
 			continue;
 
 		slot_num = DIV_ROUND_UP(pbn, pbn_div);
-- 
2.43.0




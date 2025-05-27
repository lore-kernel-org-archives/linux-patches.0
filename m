Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FDE27FD53;
	Tue, 27 May 2025 17:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367213; cv=none; b=kKKkDA2fC+D7bHqnSsvcivIutZFvTjf/DoT4YtRG7AoSH3YvKEv82GTibq4ZXuMSwLKUVojjy5tnN8VhjJ6k5J9F5OZ/b/IpLlj2lgl2tOMdXBEnIvMp2hdTlMRGzlqH0/VTzgqT1JF9P/fBZ0I6mYuQGvWb9DMWYHH3nXNzvhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367213; c=relaxed/simple;
	bh=xBqA2l8vUtkzz/X2A4eb/IHB32s7ak/yu2rSfPNmFWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZQBpSjaIXlS2j7NTW4qnkoMPJExpRteF3lFqRsa5Bx7x7dIIlRvbED0LE7Dt/dzKBIcyQ444sXvhOmBgkJPKD4wuSfSIrfRr6aZc/wNzxcci7UNaydjLPDi0IJsyEsbq+4yOJYgtLfxFdyco1bv7L3t7BifiRczk2t7ZfqkvYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e28kHGOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e28kHGOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54848C4CEE9;
	Tue, 27 May 2025 17:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367212;
	bh=xBqA2l8vUtkzz/X2A4eb/IHB32s7ak/yu2rSfPNmFWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e28kHGOwY7z/GCYUSKUc4Jqybud/tfs/yVGOR16hKzFO5TQfJEJs8fv3cYlBzzaKZ
	 zHwnZhKg3Ov8hvvzfiBnkmSfkiQJeQlaKhx34g63dg/foKDbjK3eHeiO7v/M+6JBR1
	 Le710388z1YRnPGaxSB9jMoE4LDrCqxMZGgpVLWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 284/783] drm/amd/display: Fix p-state type when p-state is unsupported
Date: Tue, 27 May 2025 18:21:21 +0200
Message-ID: <20250527162524.653495798@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit a025f424af0407b7561bd5e6217295dde3abbc2e ]

[WHY&HOW]
P-state type would remain on previously used when unsupported which
causes confusion in logging and visual confirm, so set back to zero
when unsupported.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
index a49604b7701f7..1406ee4bff801 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_hw_sequencer.c
@@ -563,6 +563,7 @@ void set_p_state_switch_method(
 	if (!dc->ctx || !dc->ctx->dmub_srv || !pipe_ctx || !vba)
 		return;
 
+	pipe_ctx->p_state_type = P_STATE_UNKNOWN;
 	if (vba->DRAMClockChangeSupport[vba->VoltageLevel][vba->maxMpcComb] !=
 			dm_dram_clock_change_unsupported) {
 		/* MCLK switching is supported */
-- 
2.39.5




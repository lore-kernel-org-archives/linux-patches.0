Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB202110E;
	Tue, 27 May 2025 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365508; cv=none; b=hNrvJUHpQeApTnE2i1QHiJzYfmoZg0y8fX8nI64WXaXYDB6SJyhrQuLaIzSHAQyCINp6ukUUIjGCGUFBofsVBJUr8vP4BoIev7x5Tot7VGxDXZL09K+hjOkK4OTV/bygo2MCJaTxfzHAFquEWxakHxCbKN+EaaZ3frV1KMr4kQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365508; c=relaxed/simple;
	bh=gVb9fCj/8l3svltIcJU9CFrNx0rFEpVqL6X75y4EIAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCci2rbk7x3lInoUWy7Js09Jfw6GHkp7KMLkiZ4Snm+0neh5fb/vZ8itNYYnlpXiedTNAS71lQuTu9ZtyFyadjrjfBmeCXNKrN1sm8dRhguzhMhnyAEE7uQLUQjYEO+tx7jZw/8ZjMc0deAZCaXN9xKtIavxR2F0XSZ1qQSi0EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yo3Eu2iE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yo3Eu2iE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE0CC4CEE9;
	Tue, 27 May 2025 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365507;
	bh=gVb9fCj/8l3svltIcJU9CFrNx0rFEpVqL6X75y4EIAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yo3Eu2iEGrQ0O66fkxvRLiy/PwMfGUji2gUO4PmCIyIiWLzV7DbuR7f6epb5XhNG1
	 ISPH8RErtrIahzaBAFJI1D6df7cTGofd6avHTWZHnA7/Q5IxF9MUIDKRhKcYEBfMzI
	 SvlOlPYuTNLz6vVgOyakAkLiCtEPxQTIN8vVBBck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Joshua Aberback <joshua.aberback@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 398/626] drm/amd/display: Increase block_sequence array size
Date: Tue, 27 May 2025 18:24:51 +0200
Message-ID: <20250527162501.191894621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Joshua Aberback <joshua.aberback@amd.com>

[ Upstream commit 3a7810c212bcf2f722671dadf4b23ff70a7d23ee ]

[Why]
It's possible to generate more than 50 steps in hwss_build_fast_sequence,
for example with a 6-pipe asic where all pipes are in one MPC chain. This
overflows the block_sequence buffer and corrupts block_sequence_steps,
causing a crash.

[How]
Expand block_sequence to 100 items. A naive upper bound on the possible
number of steps for a 6-pipe asic, ignoring the potential for steps to be
mutually exclusive, is 91 with current code, therefore 100 is sufficient.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Joshua Aberback <joshua.aberback@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/inc/core_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index e1e3142cdc00a..62fb2009b3028 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -621,7 +621,7 @@ struct dc_state {
 	 */
 	struct bw_context bw_ctx;
 
-	struct block_sequence block_sequence[50];
+	struct block_sequence block_sequence[100];
 	unsigned int block_sequence_steps;
 	struct dc_dmub_cmd dc_dmub_cmd[10];
 	unsigned int dmub_cmd_count;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE11C57BF;
	Tue, 27 Aug 2024 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772442; cv=none; b=i61l+CUNbyuNJUm/xmqA8tQDSRU3AZ2yRQR0qdCOy/4BVeeYsliaMrB8Vt/jK4dM2jGwzJads1kVvFLQ1b1C0GpMdSahuuS3YPb4Ff36vhnAdVWEgvEsvm9k9c9/7tmPfrHTuPyGIJMqqB1pQzOaKCdkCu5x4CFSSSDa9q0+0p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772442; c=relaxed/simple;
	bh=pYv8s/Az7GPAUHhpFOyKq1aAYvcVAfF44busSN0Tmy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXQR9Q9q9KO4u2+8szDm+Sp3IK+OJ4nM8B8seY0N64RCXGVr5v10+Imz66PswDmtraFCi6ZMCKkoo6BNDosOPC8MXKQa4gIrdXXglpm04E9fsxh91JgjEWA7t8PxnuUeL4Jp0Sk5qWC3yW4/0RmIzudLUhhtP6f4sfBMpRYC7cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qdw3GyHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qdw3GyHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75BAC4DE14;
	Tue, 27 Aug 2024 15:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772442;
	bh=pYv8s/Az7GPAUHhpFOyKq1aAYvcVAfF44busSN0Tmy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qdw3GyHAaXhg64cxSVCPwlPOsW75uWklRg9oQM8UVzNgMXTu98z7ugknWCQcrWkUp
	 dvNukm9fYysbYoZd0DDE57WkGYTinn6dBErarNOBv88+6Zb/lQfV1099DMVEfpmcLR
	 Txcr6VlcSeSF24QKCAerjnkXjo1sR82NEPreWRCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/321] drm/amd/display: Adjust cursor position
Date: Tue, 27 Aug 2024 16:38:45 +0200
Message-ID: <20240827143846.494072167@linuxfoundation.org>
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

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 56fb276d0244d430496f249335a44ae114dd5f54 ]

[why & how]
When the commit 9d84c7ef8a87 ("drm/amd/display: Correct cursor position
on horizontal mirror") was introduced, it used the wrong calculation for
the position copy for X. This commit uses the correct calculation for that
based on the original patch.

Fixes: 9d84c7ef8a87 ("drm/amd/display: Correct cursor position on horizontal mirror")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8f9b23abbae5ffcd64856facd26a86b67195bc2f)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index d6c5d48c878ec..416168c7dcc52 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3633,7 +3633,7 @@ void dcn10_set_cursor_position(struct pipe_ctx *pipe_ctx)
 						(int)hubp->curs_attr.width || pos_cpy.x
 						<= (int)hubp->curs_attr.width +
 						pipe_ctx->plane_state->src_rect.x) {
-						pos_cpy.x = 2 * viewport_width - temp_x;
+						pos_cpy.x = temp_x + viewport_width;
 					}
 				}
 			} else {
-- 
2.43.0




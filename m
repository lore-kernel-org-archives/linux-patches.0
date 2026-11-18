Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016486;
	b=Jlrjpqbo9JDIs69KilGfpqEPgns1poKAZfkuqYlMabSTtLSVoL9CUso0/9NrnVo0Igg7
	 5thvVI/KKiIT+tZN01aMeGmrSPPohLWYsoIV6g6Bqf/vxMbfSMVfpbtbgrl8AI1OsGA6x
	 G+FdIpKpi3CPkKT3Sb5XWSmZY3UXrTzLazjajCYASlQfEFhyUH99xIATheWuT4OLW55bd
	 WfiXDHaJq7RlI6XB1GXLsqKLWAcKeCEf7N/hkTgXObBnzrMKtw6IPIVIjz4o/KJ9Agj9/
	 thF1G2tcRT6q5VCbhAhPHyDResBsQ13QGFrulIttymRqFLoUZOrcztZ9lMWzNOJR2pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/rvqJbcR0oI0qsctTPIMAZePctJG/X8xS+DjgxbsYlk=;
	b=ffqP2soXDp5fae+mXo8An30wA/LIE8mr3/RvOMyQkpMxWlgH6D5x8ddimvhJfU331s1e
	 sI05sqY0vDMXlNfsp+fgNzx3HFfsDfA9VNeIOFPIoHq4bPj8TkCK2faM5c8xEtvoiu62n
	 t23Orv8eA3aAGtsWaYHQcOpVkU66FunLLItI4Kl0U2AIhwQVkyVfVMYvHloCbtsx+kk0k
	 WXsq8mtr3ULYlgNRLxv/Vg8Iz7gd4BqgPCeCmpsmcSa6aO1c3AYHkrngrIDdHEJlUqQd7
	 SMN814ZPpbo0Ea3hN5UvP3ZGl5ZbEaBZVANvsOOHSFHWVNoFssMXzocnX5cQzQxx6ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYTIpMyG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283EA606A320;
	Wed, 18 Nov 2026 15:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DYTIpMyG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499BD1F000C4;
	Wed, 18 Nov 2026 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016486;
	bh=/rvqJbcR0oI0qsctTPIMAZePctJG/X8xS+DjgxbsYlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DYTIpMyGVb6LARAsYBmw2kmS5fCVqPtFtSgagl2CEyl6MHnZyCvj73wflW/4J64BX
	 VRFQoOLiG//SYyla82xcfhiE4rdmyUJYgblu2L5QiKY0F5CkgNEx+ktisxfeQnySWS
	 huUkXmoKeLKJ4zt1vLgEu0VPhe5OSBGZgyMyhPzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Leo Chen <leo.chen@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0545/2651] drm/amd/display: Fix redundant NULL check on dc->clk_mgr in dcn42_prepare_bandwidth
Date: Wed, 18 Nov 2026 15:29:45 +0100
Message-ID: <20261118150307.369015808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 346d81ef808ba28465a3f19f2a0d63a758e7409c ]

dc->clk_mgr is already dereferenced inside dcn401_prepare_bandwidth(),
so the dc->clk_mgr NULL check that follows is redundant and misleading.
Drop it.

Fixes: 53845307d52e ("drm/amd/display: Register DCN as a PMFW DF C-state client on DCN42")
Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Ivan Lipski <ivan.lipski@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Wayne Lin <wayne.lin@amd.com>
Cc: Dan Wheeler <daniel.wheeler@amd.com>
Cc: Leo Chen <leo.chen@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.c
index 23d4786ea2464..bde918acba5be 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn42/dcn42_hwseq.c
@@ -683,7 +683,7 @@ void dcn42_prepare_bandwidth(
 	/* valid C-state watermarks have now been committed to HW, so it
 	 * is safe to vote "allow" to PMFW.
 	 */
-	if (dc->clk_mgr && dc->clk_mgr->funcs && dc->clk_mgr->funcs->notify_cstate_disable)
+	if (dc->clk_mgr->funcs->notify_cstate_disable)
 		dc->clk_mgr->funcs->notify_cstate_disable(dc->clk_mgr, false);
 }
 
-- 
2.53.0




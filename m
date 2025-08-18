Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B4E217F3D;
	Mon, 18 Aug 2025 13:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522156; cv=none; b=mDR3Pp2JYr6HbxAT3ycMv0cDSzaBHJD5G8fyxnQKwz0EC3YUlQoSkPLsgiG79Rf4bHfziOia35uEzxEpO+Y8TLoG0rcPvJjKPC/2hX7vbuu4ZAmT0+Hpq9FLJnclTK+ZSJuBsshq/tCWuIG8iTy3HYP0gAyuFRviM58AK3zzR0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522156; c=relaxed/simple;
	bh=T2a7s9Omx7DKe6sRHw5uSYI8mUQd1+UaWppwEaxf+f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdZ+IFw2p3V7uzmps/eOetgndVh1hzbjWfpnE5ejSxORh3z2VuiRzHxI/sh5/Av2CcjH8QeLL5KavtlK9L+lqIT5jwBfc1/3zbsWz/emvFmMQmsTFSaTy3glZ0ND4Bnqu0NYioKWVcpKnrwu4CgtWdIrn2k+xb/cfdqmCC3MgqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMsQNHkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMsQNHkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCBCC4CEEB;
	Mon, 18 Aug 2025 13:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522156;
	bh=T2a7s9Omx7DKe6sRHw5uSYI8mUQd1+UaWppwEaxf+f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMsQNHkGIyHlZNbFYdYSwYcyNyDsXz9FvUUQP4sAJ9Ah4yIRHBhHWCs2SJEyNzrGQ
	 wrieYkgYxsrpbH6TPmUQDSvLh6OwfB0HBEANaiCFsG9ca2orOEmUK0iT+VcZFg9/Wa
	 Nb+1TXaTp7isqnKiv7flYKULz1Yj6w9s5WRIQbOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/444] drm/amd/display: Initialize mode_select to 0
Date: Mon, 18 Aug 2025 14:44:19 +0200
Message-ID: <20250818124457.573388673@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 592ddac93f8c02e13f19175745465f8c4d0f56cd ]

[WHAT]
mode_select was supposed to be initialized in mpc_read_gamut_remap but
is not set in default case. This can cause indeterminate
behaviors.

This is reported as an UNINIT error by Coverity.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c b/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
index 37ab5a4eefc7..0f531cfd3c49 100644
--- a/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
+++ b/drivers/gpu/drm/amd/display/dc/mpc/dcn401/dcn401_mpc.c
@@ -571,7 +571,7 @@ void mpc401_get_gamut_remap(struct mpc *mpc,
 	struct mpc_grph_gamut_adjustment *adjust)
 {
 	uint16_t arr_reg_val[12] = {0};
-	uint32_t mode_select;
+	uint32_t mode_select = MPCC_GAMUT_REMAP_MODE_SELECT_0;
 
 	read_gamut_remap(mpc, mpcc_id, arr_reg_val, adjust->mpcc_gamut_remap_block_id, &mode_select);
 
-- 
2.39.5




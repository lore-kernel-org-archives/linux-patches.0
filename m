Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935287BAE3;
	Mon,  8 Apr 2024 13:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582912; cv=none; b=ERDKU8SEVhilf8Fo5vufc/GKz4pvds0gnxgZy6zbOQ73WS428Iinw5Ed7XhMOU9V0Mi7zVCM18lkE7UIm/Cx87LcPNrWM+SliF9ZUZfdRpql2hs+m7vsQ21O+uPO2tNthoDoiTYtV1cEFZ7WD9Z0Qrn/IXJdKVLCSO1INWO3zfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582912; c=relaxed/simple;
	bh=R+AlE7D8G0x0osvxGqUSniHMFBF+oymulx55WPXTrMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6150MXIEXS41y/DkJZUst/I5aQ4gzDX4Kys1Z4t05RwN26Cdo669HT8V+6dhfiq8vwz4PLnPr2um63dGkTwccKvSDAAdaKprDh9b3rsutiGEzF5qos2zK0iNcNFXibprr+xJ47lNm76aPfIlbQHwYZiEh1ZMAMOn6yWNYyRsLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHnQjnO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHnQjnO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1360DC433F1;
	Mon,  8 Apr 2024 13:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582912;
	bh=R+AlE7D8G0x0osvxGqUSniHMFBF+oymulx55WPXTrMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHnQjnO/ExC4GNTwEatDZevQqkOS1e0rpFzVLiId/gR+m5+NInYEH/vdYnfK66BST
	 OsFzUijKmqKikQX2Q3/kbxvFtaQw5aaQ0WXtpKzjNSid6Wdub8ZA56hzGsOAWWShNs
	 tr6+agebo/0Yj2IIKqKgoqh5yW+BSIEfQ0fOKl5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Chris Park <chris.park@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/252] drm/amd/display: Prevent crash when disable stream
Date: Mon,  8 Apr 2024 14:57:14 +0200
Message-ID: <20240408125310.828373158@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Park <chris.park@amd.com>

[ Upstream commit 72d72e8fddbcd6c98e1b02d32cf6f2b04e10bd1c ]

[Why]
Disabling stream encoder invokes a function that no longer exists.

[How]
Check if the function declaration is NULL in disable stream encoder.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Chris Park <chris.park@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 2ac41c2a7238c..7b5c1498941dd 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1181,7 +1181,8 @@ void dce110_disable_stream(struct pipe_ctx *pipe_ctx)
 		if (dccg) {
 			dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
 			dccg->funcs->set_dpstreamclk(dccg, REFCLK, tg->inst, dp_hpo_inst);
-			dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
+			if (dccg && dccg->funcs->set_dtbclk_dto)
+				dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
 		}
 	} else if (dccg && dccg->funcs->disable_symclk_se) {
 		dccg->funcs->disable_symclk_se(dccg, stream_enc->stream_enc_inst,
-- 
2.43.0




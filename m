Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034899;
	b=q12+iKV0/41LoCtUZnSG7vmihcLo5lV5AV/jsQ4tPZcM0G/9itioQqGtsoVKKFbKnvUp
	 fQ7If1Fw+TmwBkYexInjAi35l2KoXLNtzZmDgzZMSj5Qx5OkspFcWU/WWGxMoeneBcQc3
	 28ZA0jt4qtTxdNznoouNEExiu/qU2UhwPpDuy/E2TgU4uP+o9/5Pwwnt7/8h3CQjPLMWS
	 B89jScf5aOwhIPKece+QtQrq9ElbLqxLeuJAIIRFiJy/T/zfpn5PSxvREQSPUFyefJrZU
	 l3NuaqOAdNt2eARfcNSOi9XigI5DdV3b5ay4WFB+KFzjHmBZU311RRUMh/MytVxlGYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0WSXVpdX1aEJj6zGRriOOeaVoP8CvdOpmJR+Udveukk=;
	b=Vtxqrkc9l68HAB537Zxny15aQDyjV2TXw+SXfun4WKe2784pjrW253VQS2NjAKUfIvdF
	 RUuywt+6l+cZZ7Veswiud+IJb9omrwoIY0MSaf/Eg5PZOgCl0G1OS/Q8Vkw1XBEMyrNP9
	 7iEVQERvA0MCFdKu+7yU1cBUySrvVpLAkJKJrkNbeQIEMj8f7Z+3c6dnVRh4eRAhdOSh7
	 Ski6MG/vxAAgDuzF5GnMVH1ptwZUYyxpwMukCcS8z2DyJZa/Oek25PYmilqoK6GeqOSeF
	 g4E2SUFq380JntnFeHUMwJ9fnqsYBsI+6vkJpTz9tzyXHQ4b/kXhyE8rrau3oAI9YMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBlqVLwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53695606A31C;
	Wed, 18 Nov 2026 20:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBlqVLwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EACE1F000C4;
	Wed, 18 Nov 2026 20:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034899;
	bh=0WSXVpdX1aEJj6zGRriOOeaVoP8CvdOpmJR+Udveukk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBlqVLwaSPk5M7T3eqXsbj9aoxIl8/w8YACklGfZGdu201f+ho10JEYtA6zHMvbTA
	 g2aGaPXaz0qp6ImOV14Uy5fBEdNV55C88o429hHs72VuT5aatj+qgsI4CHD74y/QKB
	 vukR1jx0KmasYqS59Oj0t4Ps0k0SNEaAR753aA8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0532/3318] drm/amd/display: guard dc_sink dereferences in MST mode validation
Date: Wed, 18 Nov 2026 15:19:14 +0100
Message-ID: <20261118150333.193683700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 217f64f348c90cba62164e7ff38e0ccf78a5ca09 ]

dm_dp_mst_is_port_support_mode() reads
aconnector->dc_sink->dsc_caps... for the DSC branch-throughput check,
and get_conv_frl_bw()'s HDMI-PCON FRL-bandwidth path reads
aconnector->dc_sink->edid_caps.max_frl_rate, both without a NULL
check. dc_sink is cleared asynchronously on MST unplug, and both
functions run from paths that the driver's own comments document as
racing that teardown: the connector probe worker's ->mode_valid
callback and a compositor's atomic check, neither of which holds the
MST manager lock that the teardown path uses. The former does have an
existing dsc_aux NULL check, but dsc_aux isn't reliably cleared in
every path that clears dc_sink, so it doesn't cover this.

Fail the port-support check and skip the FRL conversion path when the
sink is already gone.

Fixes: f04d275d94e1 ("drm/amd/display: add mst port output bw check")
Fixes: 5c9b8b27a883 ("drm/amd/display: Tie FRL support into amdgpu_dm")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Reviewed-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7c3db8da4e039698ae198c870712428644e965c7)
Cc: stable@vger.kernel.org
[ sashal: Dropped the get_conv_frl_bw() hunk because that function doesn't exist here, and placed the dc_sink NULL guard in dm_dp_mst_is_port_support_mode() before the comment block due to differing context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index acb5362d3450a..ee1bc9dab7db8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1653,6 +1653,9 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 	struct dc_dsc_bw_range bw_range = {0};
 	uint16_t full_pbn = aconnector->mst_output_port->full_pbn;
 
+	if (!aconnector->dc_sink)
+		return DC_FAIL_BANDWIDTH_VALIDATE;
+
 	/*
 	 * Consider the case with the depth of the mst topology tree is equal or less than 2
 	 * A. When dsc bitstream can be transmitted along the entire path
-- 
2.53.0




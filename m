Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6201A619B;
	Tue, 30 Jul 2024 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357581; cv=none; b=NJ5FIWN7PeMPjhfBmutptpjPSOVxcDgmc4NvcsRURn2LsWMRqPhZB4gssD0uYPiNsu42hbDf4h21cb6muS4namsWxDnhwt2wNDiDbaCwfLOJpBd8GVVdcaLE2XQgftuPazX9Ny0kYI0g7L0aD2eynHdpESqyyq8QW4I+BOSgzDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357581; c=relaxed/simple;
	bh=ivEZP8Pd5SojVjmY3AqlqA+00tt52+XQrbKgyMieF0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XWGtCdJ0+2+F9PXnBSCUeo6rIGyZ5KHw28/SW+jSSK95UI+QdG0JXih7box+2SyyIhnEfeTfEz45lUL2tZSPPyy4Y5rfitfnkf/5UrJG/UXsgo+aQH4E0feBqRVpDGarBCxqXI1ndYlWhsrnkTvV8wWAlMbLbWzYcAXq3BW2kCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YvTxYnQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YvTxYnQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC391C4AF0A;
	Tue, 30 Jul 2024 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357581;
	bh=ivEZP8Pd5SojVjmY3AqlqA+00tt52+XQrbKgyMieF0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YvTxYnQVUfMniP1q/xoY8T/bMqHTJx3OWD4XD81EaNCl4DXVEa+hu0g8useX1R7rf
	 1iKTmTb0h4ZCdDPm64oD9rcMLEcIUmamEciwM4bxv9GsrtyJFk8aI2cNCH2idQ/5HG
	 yb9mahz7TB4wEJ9+1y0w3HCTd2so5qqwjFNh4uSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 269/809] drm/i915/display: Do not print "psr: enabled" for on Panel Replay
Date: Tue, 30 Jul 2024 17:42:25 +0200
Message-ID: <20240730151735.221122513@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit d07a578703dbf839ea39bffc425fba2321f45543 ]

After setting has_psr for panel replay as well crtc state dump is
improperly printing "psr: enabled" for Panel Replay as well. Fix this by
checking also has_panel_replay.

Fixes: 5afa6e496098 ("drm/i915/psr: Set intel_crtc_state->has_psr on panel replay as well")
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Animesh Manna <animesh.manna@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240510093823.3146455-3-jouni.hogander@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_crtc_state_dump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c b/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
index 1da4c122c52ec..bddcc9edeab42 100644
--- a/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
+++ b/drivers/gpu/drm/i915/display/intel_crtc_state_dump.c
@@ -252,7 +252,8 @@ void intel_crtc_state_dump(const struct intel_crtc_state *pipe_config,
 			   str_enabled_disabled(pipe_config->sdp_split_enable));
 
 		drm_printf(&p, "psr: %s, selective update: %s, panel replay: %s, selective fetch: %s\n",
-			   str_enabled_disabled(pipe_config->has_psr),
+			   str_enabled_disabled(pipe_config->has_psr &&
+						!pipe_config->has_panel_replay),
 			   str_enabled_disabled(pipe_config->has_sel_update),
 			   str_enabled_disabled(pipe_config->has_panel_replay),
 			   str_enabled_disabled(pipe_config->enable_psr2_sel_fetch));
-- 
2.43.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619169;
	b=aDajzRoRIdadmcLU/g0fTOSL+ibsgPlj4yuOB4EP+WKLdhmsrYlOBXSHge2SPrlnUBf7
	 7Wci4ops/KT0hVqLGlKQDEFzSoN5LpOVBStoPD8TFal6/kdZ99rk13NOAfesZtjFqizHZ
	 wDVnUeI1sX0Uy0GFOM8vaAkxjzugKpprD/6S3qu6fPmrVdOX8mJTOtx7tzkSOVpmwVsNl
	 Uz2K10+J9FbxshY9pUW6smywc0+8gCr0qozFmYGmNhwpD3WB8K3/HBc2KC4lm/3mlKvTv
	 rD/0ahdlueo0SmHtht3dEe3Qnv/WOfyDTifgBiA6Bh8oFo3R8bs/P+hOIMZ8ZNSJpbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hGwApIr3Yfkn8sCwjBSdbRrBKXpwdhMe0+AcgTHNwo8=;
	b=H1Qoelrqoj2MGQ6qGyCLiA4YYvwwJ98Nc8ZvyUsDmAbDnKh5clUP7BxfTTl2eycRSdl7
	 633W4eTRGImqLZ8CDkrXs74D/9ejRVDwrr6KjWWhd4ekKh39lQtmByayau+h/7Cz2RYr7
	 GEIlWC9007NY9klf74nyk1CVBaJdnzBoiVEnYBsC93rE2A4KGGQkd3M0NUJDB8gXH7XUG
	 TEUwinDY1cGgRCxnxkcDeILFNLAYrGhUfONelTgB8rpDUzL/ZfJIdWvu9ieZfHtj4BSEg
	 lVxdixdp0nkcn8y8bQzP976AxX4WfLtJENtdp+gUM5H4WhllJngzo3vCJp447OqcVyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="txRoe/GX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8CB606A321;
	Wed, 25 Nov 2026 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=txRoe/GX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A731F000C0;
	Wed, 25 Nov 2026 15:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619169;
	bh=hGwApIr3Yfkn8sCwjBSdbRrBKXpwdhMe0+AcgTHNwo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txRoe/GXwdrCwTE8MVw3GqGhGgqJY7dCGs8xjJ093revukm1IVa0AhHaotMm4oS4X
	 y4/OCIDKhZUUMmTdIk+MfAvTm4h4DVehIADOPHAPTGsmc10Wvwe0iesh7ZNFNFGe7R
	 7kkACjsmnd3uoXsQtqfjCvrp7B9hdCIPMhMhHWbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0513/1005] drm/i915/psr: Flush on cursor update also when not using Selective Fetch
Date: Wed, 25 Nov 2026 15:30:51 +0100
Message-ID: <20261125143833.762899379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 6b3ea5a07eac0514623da3d0709b34c8c70f2827 ]

Currently we are not doing flush on cursor update if Selective Fetch is not
in use. This does not cause problems in PSR cases as enabling VBI is
triggering PSR exit which triggers sending update to panel. In case of
Panel Replay this does not happen. This causes legacy cursor update not
working if using Panel Replay without Selective Updates.

Dc3co is currently not enabled. Anyways there is no reason to differentiate
calling psr2_dc3co_flush_locked on cursor update depending on selective
fetch being enabled. So remove this dependency.

v2:
  - Keep DC3CO handling for cursor updates.

Fixes: 129a4da11707 ("drm/i915/psr: Use TRANS_PUSH to trigger frame change event")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Link: https://patch.msgid.link/20261102100051.272137-2-jouni.hogander@intel.com
(cherry picked from commit 043ab39fe2daad32f15fe77cf787a759f3f73512)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 01c36ea315fa6..b68859c31d175 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -3717,12 +3717,11 @@ void intel_psr_flush(struct intel_display *display,
 		if (intel_dp->psr.pause_counter)
 			goto unlock;
 
-		if (origin == ORIGIN_FLIP ||
-		    (origin == ORIGIN_CURSOR_UPDATE &&
-		     !intel_dp->psr.psr2_sel_fetch_enabled)) {
+		if (origin == ORIGIN_FLIP || origin == ORIGIN_CURSOR_UPDATE)
 			psr2_dc3co_flush_locked(intel_dp, frontbuffer_bits);
+
+		if (origin == ORIGIN_FLIP)
 			goto unlock;
-		}
 
 		if (pipe_frontbuffer_bits == 0)
 			goto unlock;
-- 
2.53.0




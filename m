Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622199;
	b=da5w0ygQyuDXt8J19s2IUHr4U+0znHUmTN725QqcgFXF/bx6n8KYF+zK4Ri9QI6bgzzM
	 IFwD7bFBqolF0AMKccgD7zjl7XXYLqnaePS1oG6NNcZH99wB4MvjSc+I4QJw1kvDavz++
	 B4Ok1KD8xZpoEgGfFOAJHjuWcQ/zUGWQDY8B/8GfmvdKuc27GN5WZuX5NHKr0EKKvs9Ir
	 N+LlxZKie+M74keSkp3qIK6QRFQJg9FOV3yuGWxG/z1myMEaof/zERCBOfCBxKgxJ+oZu
	 c1XFkFsPnLDM0MqhR+ClDhi3zJuiv0RhiL9sLdCddq9s4O8Iy1BNyd3g5euFIF5lrCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KN+olVxpYFwpSI2fubseOZ9fgKUJSEyQFuw9c7SlClM=;
	b=BgSRbR2NolvwYaTAfW9Ahk5HXmu3Pu6MWFAcoaWGPiSJhpdUddvVrUQQbdm6EAguEtn3
	 +9GmGA3SnaeKo3TiyxlsTPQmXUIMyJ7xG9HJ7ugRp6V7btoAiBLeSiMmeOmWoQ13rN/3G
	 RT8elAhW1Gp9aSMR4LBAd7Ww+ba4k/eCMFoeHiVuA7K0b3XL7Yekjahl2d785LOAM2zzh
	 sRnviIdLomakUvldvECiot3ab+u7wh+HTXOhGOAwujdr0WD43lcVy3hbkbLV7Sivsk+tb
	 C1wGLUIjER4mQ8oTsMUQKGwq0rP2A5j52DoajXCVpPkyKYexYLZNG5D034bKvlNWszg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gdGipji/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88B3606A329;
	Wed, 25 Nov 2026 15:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdGipji/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FCE1F000CA;
	Wed, 25 Nov 2026 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622199;
	bh=KN+olVxpYFwpSI2fubseOZ9fgKUJSEyQFuw9c7SlClM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdGipji/nsy9FI39EFhwlTHtjGd5dIf8UdFaGamhoJO/0qLMgDvo/n7TLflPmK3SJ
	 sbSLpZ2iLx6nEJqiCn3gfKOSOAlUWlkw1Y9Ga3ctIpPrHudl0L/1c8/MiRMuT1xUwX
	 pqJ7yFD0VVvURLFVHCZjB06iGiT4nfMh4muHQ9FU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 462/990] drm/xe/wa_oob: Consolidate some OOB rules
Date: Wed, 25 Nov 2026 15:30:29 +0100
Message-ID: <20261125143832.917638610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit a2d0403de6492a32e5c175b22ebac053f579d350 ]

Given the new policy of allowing graphics/media IP ranges to extend over
unused IP versions, we can consolidate some of the OOB workaround rules
and simplify the table.  If new IP variants eventually show up that use
these unused versions (e.g., media version 30.01, graphics versions
20.03 / 30.02, etc.), and if an existing workaround does not extend to
that new intermediate version, the ranges will be split back apart as
part of the enablement work for that new IP version.

Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260220-forupstream-wa_cleanup-v2-22-b12005a05af6@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: 557c7b434378 ("drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa_oob.rules | 31 ++++++++----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 40ffe05ea2701..b703055eb6331 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -30,18 +30,9 @@
 		MEDIA_VERSION(2000)
 16022287689	GRAPHICS_VERSION(2001)
 		GRAPHICS_VERSION(2004)
-13011645652	GRAPHICS_VERSION(2004)
-		GRAPHICS_VERSION_RANGE(3000, 3001)
-		GRAPHICS_VERSION(3003)
-		GRAPHICS_VERSION_RANGE(3004, 3005)
-14022293748	GRAPHICS_VERSION_RANGE(2001, 2002)
-		GRAPHICS_VERSION(2004)
-		GRAPHICS_VERSION_RANGE(3000, 3005)
-22019794406	GRAPHICS_VERSION_RANGE(2001, 2002)
-		GRAPHICS_VERSION(2004)
-		GRAPHICS_VERSION_RANGE(3000, 3001)
-		GRAPHICS_VERSION(3003)
-		GRAPHICS_VERSION_RANGE(3004, 3005)
+13011645652	GRAPHICS_VERSION_RANGE(2004, 3005)
+14022293748	GRAPHICS_VERSION_RANGE(2001, 3005)
+22019794406	GRAPHICS_VERSION_RANGE(2001, 3005)
 22019338487	MEDIA_VERSION(2000)
 		GRAPHICS_VERSION(2001), FUNC(xe_rtp_match_not_sriov_vf)
 		MEDIA_VERSION(3000), MEDIA_STEP(A0, B0), FUNC(xe_rtp_match_not_sriov_vf)
@@ -59,18 +50,12 @@
 18013179988	GRAPHICS_VERSION(1255)
 		GRAPHICS_VERSION_RANGE(1270, 1274)
 1508761755	GRAPHICS_VERSION(1255)
-16023105232	GRAPHICS_VERSION_RANGE(2001, 3001)
-		MEDIA_VERSION_RANGE(1301, 3000)
-		MEDIA_VERSION(3002)
-		GRAPHICS_VERSION_RANGE(3003, 3005)
-16026508708	GRAPHICS_VERSION_RANGE(1200, 3001)
-		MEDIA_VERSION_RANGE(1300, 3000)
-		MEDIA_VERSION(3002)
-		GRAPHICS_VERSION_RANGE(3003, 3005)
+16023105232	GRAPHICS_VERSION_RANGE(2001, 3005)
+		MEDIA_VERSION_RANGE(1301, 3002)
+16026508708	GRAPHICS_VERSION_RANGE(1200, 3005)
+		MEDIA_VERSION_RANGE(1300, 3002)
 14020001231	GRAPHICS_VERSION_RANGE(2001,2004), FUNC(xe_rtp_match_psmi_enabled)
-		MEDIA_VERSION(2000), FUNC(xe_rtp_match_psmi_enabled)
-		MEDIA_VERSION(3000), FUNC(xe_rtp_match_psmi_enabled)
-		MEDIA_VERSION(3002), FUNC(xe_rtp_match_psmi_enabled)
+		MEDIA_VERSION_RANGE(2000, 3002), FUNC(xe_rtp_match_psmi_enabled)
 16023683509	MEDIA_VERSION(2000), FUNC(xe_rtp_match_psmi_enabled)
 		MEDIA_VERSION(3000), MEDIA_STEP(A0, B0), FUNC(xe_rtp_match_psmi_enabled)
 
-- 
2.53.0




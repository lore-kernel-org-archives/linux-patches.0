Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447504EFFB0;
	Thu, 17 Sep 2026 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661136; cv=none; b=hd9tlH4MaQAmvbJYxPquobXRsAYD9nNM15FJJMDXe2C9kbdsSSfoK03i6/rSG3PMDJrq6ftpSmWKHL9F3UjRWjeNh0vJ+9kN9kZWtzKSAPLWxe4booRSoZi5eWzj9/nXkvroQf9hM1udQRq3HeaSiBcPyP2BxCkjAPWs3349nA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661136; c=relaxed/simple;
	bh=rQC9+zip0TeYenF8g5v/fmOMqKAAEEkc8DVBnEf2FoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u5wf+M5iPceETBHmhePuAq4/PPhEjmElbeVLJNoEFrlQeqhk9+xU2kXYm+fjncpXU3XEaiUO24VPLQNkvel6R8ItUWiqXL/7vaKn+fcTCTeNe4m04PHVjBdQjYBAjYEJOqb+kTimeHdk2kg4YITShv/Bv5f8h0cpmK1STEznIkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzfdbAzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzfdbAzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA571F000FF;
	Thu, 17 Sep 2026 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661135;
	bh=1N+r/rfYsB9Z14ppROW5vlf/jMmPAYifj562ZxBe+AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzfdbAzxRjRSsDDirrODH4eeo0OsMhKtecVj/ZhdKIOwKkC4a1/IebVV8he+vrEkD
	 g+00C6hs3E1H8lVaetUooA4QdS/X2RfgZKPtNUIL9YAIYLiA52OO3SFNeE3DOwPfZM
	 DMqKKNjpav5hL4tco7HG7iqk2XEaBeqrkXlzpnxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>
Subject: [PATCH 6.18 0077/1250] drm/bridge: tc358768: Set pre_enable_prev_first for reverse order
Date: Thu, 17 Sep 2026 15:57:52 +0100
Message-ID: <20260917151554.047755815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parth Pancholi <parth.pancholi@toradex.com>

[ Upstream commit 6b2bb5438bcfd7bad868665cd2aed1caf9ba3f2b ]

Enable the pre_enable_prev_first flag on the tc358768 bridge to reverse
the pre-enable order, calling bridge pre_enable before panel prepare.
This ensures the bridge is ready before sending panel init commands in
the case of panels sending init commands in panel prepare function.

Signed-off-by: Parth Pancholi <parth.pancholi@toradex.com>
Tested-by: João Paulo Gonçalves <joao.goncalves@toradex.com> # Toradex Verdin AM62
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260311-tc358768-v2-2-e75a99131bd5@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index fbdc44e162293..b7a9d3fca07ea 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -448,6 +448,8 @@ static int tc358768_dsi_host_attach(struct mipi_dsi_host *host,
 						    DRM_MODE_CONNECTOR_DSI);
 		if (IS_ERR(bridge))
 			return PTR_ERR(bridge);
+
+		bridge->pre_enable_prev_first = true;
 	}
 
 	priv->output.dev = dev;
-- 
2.53.0




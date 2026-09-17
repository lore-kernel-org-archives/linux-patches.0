Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAE3519E05;
	Thu, 17 Sep 2026 17:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667326; cv=none; b=rwndHt8rB5IPSU5abZjhLx5c9uZ974q2IBKAUj5eN+RsO2AB7rw9P2UM/h5xBXcXy1iPEkpL41XqE2YS0eEFl26a1QG+ncPMFcbPRVXQea4SKByacNJJ/PUOfxoKFpn19ZQBnX2wDx6tFC/2MnUYBVh8YiRlnDPUlQWUs2OfGS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667326; c=relaxed/simple;
	bh=XtAH5CydNCo/7whvi/22mOPKQUOXm+rY7c2elTekDHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOCTRkOIQnZ+RZlgtuDMdIK9Su/zfo/YlxshIZBLIolKIJAguAzpQcyT/OqwTnCPTp3w53av0wPOfKT+cNvDeaUeiX7nzUysNXjsyL94YRTKuxslzeCMEYSeilpnPipbjwIS5EFqZlSjjx/wNoo0XF0n4+bzVApRWsqer3UFzhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ocsRQwO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ocsRQwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62AC1F000FF;
	Thu, 17 Sep 2026 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667325;
	bh=leKfqlDD/Nng7MM9eyK1XvQ5LZOESQZ5zS4u4lEWF9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ocsRQwOQfY5V0LJq1zsWcEkw8LKxqo69UeqkZ5WC6DuN9td9cwwiBhM5+SOX8aE4
	 KwMnxGH0aZzOa9jHZGFGUMvsWgs/h9LuX2BTLCZhGFRtsmwkxCKtHCH1LpU/HEhWFU
	 bQ6BjO2jRGgo356W0vGvcYCAFUFzLQjAuPIJ2+uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>
Subject: [PATCH 6.12 0056/1102] drm/bridge: tc358768: Set pre_enable_prev_first for reverse order
Date: Thu, 17 Sep 2026 15:59:59 +0100
Message-ID: <20260917151540.858563273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bb1750a3dab0d..686add7e9767b 100644
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




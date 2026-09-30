Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142A33DB328;
	Wed, 30 Sep 2026 18:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793948; cv=none; b=s+uZmtrh8bGRFQQ6gsyi8pgmTRo8KY9kzkebMiQU/Myuoyli1A/fGJsGg0IT3YWL+O4XEdb+24RCRH7Ca4Uzn7Ui+XDki6w1hvgp3U7n8hxS/R/GK/6zLTrpH3CRtCXby3PmzCTj33A1DvT/SaFpQvqxjcoeE9nqsQtAYdSNEZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793948; c=relaxed/simple;
	bh=R2GsNrcoAJG4AawhQNOxbU6mIxH74ZUhLl0vE7HLR0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VtJugqm60/DfOPbJr2WBoT2gmvEy56lmMVYX4pEwvWZ7n/w+NAq0dQ+pWC0BLg43hIKfSCOBNtqJW4kqe3Rd6W+E76jic683zeMoZCtKP3daXfvema6Wj1UJpRSjnynIgoeBdBJDodJ5dgEzFN9f7ZnAXN83RqDMpAWTMdl1B8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9fc47je; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9fc47je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBAF1F00898;
	Wed, 30 Sep 2026 18:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793947;
	bh=TX9/gjKRAOvbpFZUQCLQqnDYUA4b5Liuv2tgV3pFCG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9fc47jel9Y8bhnFeTBfeLWIHGS4IQfvZ+i/AezQvtjlSwDJ72fxi02UcAZZwF7T2
	 v6j27qDmdLf3Yp/TN9m2mJipvA7OICGnovn/+s7KXISjNn2haYOoIpvX1lPats+jZh
	 MXPLGo2S5dLaW7o5wpAp0vFtkfNN/tgLBEBdjiWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>
Subject: [PATCH 6.6 0037/1193] drm/bridge: tc358768: Set pre_enable_prev_first for reverse order
Date: Wed, 30 Sep 2026 17:12:01 +0200
Message-ID: <20260930152435.109478481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5d5834a286f0f..a552b6d90e42b 100644
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE7B4C10DD;
	Wed, 30 Sep 2026 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784089; cv=none; b=UZ7L7etV8j66wVIQQMor99ESOYcfX/ABJl7mtpUfnKfTRc+q4Ll/utd0hBZ2V8V/hjsx6PiGsRi+zo6YZuDYXxl7rsfWFj2hAARiCIIiZGulGZ/uRYGOIYQVptjxsaPsaje6YmfNOQA2tNWoHlzUFQ70oWL7P+e5x8g00zduJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784089; c=relaxed/simple;
	bh=YdchVZ6iKfTHANI7YIGSTYhjkRkWKwij3IspCzhd3xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y8fc6hzGNh6BV3BNoKfkOIs1dJhRWhssC3SrTW3zSM0Gi0eI76kgCxz6b7hndNMGNbi4rgt/MKBH1uC/FdwhRgxIVk5tcYAl4LGrHERpSoIQouSq8F+cIYeoJrASQ6dEpE6EvPISG1vLYEnr0dJLt3d8JiHoahuYsVLXsbVl5N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y31Kletl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y31Kletl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6501F00898;
	Wed, 30 Sep 2026 16:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784082;
	bh=NBUBoCHX3yN6N/FOUwKtj/vkHhoAxuy2gXiB95OLlrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y31Kletlc2ZqrYmqwJRab7O1qvbwQWvWvllMJ+PiOtbJx04O918eXN7nq7dNHiavn
	 KFs3tUkdsMn6q22l+d+8fiDk93HZHjs91Gb8Yv/0YMsCpDM/Q0BT3oIvXnsuxY4PCv
	 y2KUO/Uj7uwNw83NG/cScKScLLTYjK4jfd+1iIbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>
Subject: [PATCH 6.1 031/982] drm/bridge: tc358768: Set pre_enable_prev_first for reverse order
Date: Wed, 30 Sep 2026 17:12:47 +0200
Message-ID: <20260930152417.464182321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed8094b2a7ff4..acbbf1e79fb78 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -449,6 +449,8 @@ static int tc358768_dsi_host_attach(struct mipi_dsi_host *host,
 						    DRM_MODE_CONNECTOR_DSI);
 		if (IS_ERR(bridge))
 			return PTR_ERR(bridge);
+
+		bridge->pre_enable_prev_first = true;
 	}
 
 	priv->output.dev = dev;
-- 
2.53.0




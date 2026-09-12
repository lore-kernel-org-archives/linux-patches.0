Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFCF43303F;
	Sat, 12 Sep 2026 10:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209910; cv=none; b=rf90u+2tT9Ve5nxYuK8C/wVw37T6UBq3AuRCK6yi7nvI9KofzJJnFxUecAiC7/W2X3OjiMMFzaO6bBEFGuAvUlg8/qSB84sbpl91h4aQakTE0AQmEu2uohT2IUZHS/hCmu7VNsOaRzZnpU4lTg/MWOLBDPxTSe2ZfnkYrdVYrDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209910; c=relaxed/simple;
	bh=3BxpbUvtmy70oUbhd4/rdNfKE4HecHxEd0YnAhdTdPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OafWB6w41UD+6BrIT845vhOoHET3bBlB14mHfIgvGiMY5TiK4tTBouRrD9sgxflTVBzxAOcdAAxraM4EJjCsdCoTaBfliB8hJiGE703tay7+XBqxk61/8tQLUJxhuIb1RmGbhAiYuFkEAS48RDGieGV/iRLSdCWiEfClqTw81qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykhEaeZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykhEaeZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589181F000FF;
	Sat, 12 Sep 2026 10:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209909;
	bh=/YP8AWfKlC1p/b35h92ErWk0bN+QXGTDaNWdZ4hMwx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykhEaeZBug6RC7oLNMn1msdq07yiHePDkKmo94WiA9EZzDcy05mi3ApGLMeawDr/0
	 8MvpmhZlMqQreuKPlbP5er7vH1+2b+itdKn+Ewv/bG/80lpCAgVGE7RXSoRQMcpmhU
	 XEhMhQjKSymL6XFkFYwolPEsSmxMWLMtUi0s79UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0916/1518] drm/sun4i: tcon: Drop remote endpoint reference
Date: Sat, 12 Sep 2026 08:51:25 +0200
Message-ID: <20260912065644.174199971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 3f77e4072630e2301efdbe521e7fca10311043ec ]

sun4i_tcon_of_get_id_from_port() never drops the reference taken by
of_graph_get_remote_endpoint(). The function is not only called during
bind, but also on every mode set through sun8i_r40_tcon_tv_set_mux(),
so the leak accumulates.

Fixes: e8d5bbf7f4c4 ("drm/sun4i: tcon: get TCON ID and matching engine with remote endpoint ID")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/3f5ec952ad80cb51efebf2fe230df50259041a23.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index de2d66623f7a2..67047e3b657ff 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -972,6 +972,7 @@ static int sun4i_tcon_of_get_id_from_port(struct device_node *port)
 			continue;
 
 		ret = of_property_read_u32(remote, "reg", &reg);
+		of_node_put(remote);
 		if (ret)
 			continue;
 
-- 
2.53.0




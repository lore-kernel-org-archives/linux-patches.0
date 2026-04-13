Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EF926F293;
	Mon, 13 Apr 2026 16:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096769; cv=none; b=pTl4vCSvNtC1zl1JWSQtq/Qc3LCOGuVbH4bGqmzo5mdWzXC7xHv7jNzdKYncIVD46Qfx1MZxbCB1cVTgI7+/w/JSZUVILGjF36QbehgJMdzqt1oF19q62pUNnT9OoVuP2NbYN4CukXxlsBEcdz9RkqpJhwtjr2zfFU5ojIDe97A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096769; c=relaxed/simple;
	bh=OdoPB7ocx2r/KtkrutdvFmhCYkSEHspfl8ccs/dypNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JudLEndmhcfP3Y97hHhE//wlr98KfBvDHPp1F/+tya85V6RwDXOTFGVK80EJOyN/1WEB8c0k0qUZzd3Uj4f8NVdPTlUQKEtZ+72YDIpwWoV0Es37iskuRQa6Q5fZMRtng9oBM3VfOdVzA9DnH95Nz4kRwaJ42bOwr9/fje0SUek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koPpUHok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koPpUHok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08010C2BCAF;
	Mon, 13 Apr 2026 16:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096769;
	bh=OdoPB7ocx2r/KtkrutdvFmhCYkSEHspfl8ccs/dypNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koPpUHokvEpVLZRMya686GDPbiMKED1k4l1+qKTx6cpEVsnbFV/7KRQ8SfAtsKy1t
	 g3msEfLjzhE2jICFG75uwUCEdXyOsT6iy73S/VeBiCkxzsBcDgjiL/k4xfCZ8ULxh8
	 0wOaqPN/+JUJvmIZ4GzhD3LMYWD7RNjtgx9voBGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 13/70] ASoC: simple-card-utils: Dont use __free(device_node) at graph_util_parse_dai()
Date: Mon, 13 Apr 2026 18:00:08 +0200
Message-ID: <20260413155728.683096181@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit de74ec718e0788e1998eb7289ad07970e27cae27 ]

commit 419d1918105e ("ASoC: simple-card-utils: use __free(device_node) for
device node") uses __free(device_node) for dlc->of_node, but we need to
keep it while driver is in use.

Don't use __free(device_node) in graph_util_parse_dai().

Fixes: 419d1918105e ("ASoC: simple-card-utils: use __free(device_node) for device node")
Reported-by: Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
Reported-by: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
Tested-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/87eczisyhh.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index c9f92d445f4c9..0e3ae89d880e5 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1072,6 +1072,7 @@ static int graph_get_dai_id(struct device_node *ep)
 int graph_util_parse_dai(struct device *dev, struct device_node *ep,
 			 struct snd_soc_dai_link_component *dlc, int *is_single_link)
 {
+	struct device_node *node;
 	struct of_phandle_args args = {};
 	struct snd_soc_dai *dai;
 	int ret;
@@ -1079,7 +1080,7 @@ int graph_util_parse_dai(struct device *dev, struct device_node *ep,
 	if (!ep)
 		return 0;
 
-	struct device_node *node __free(device_node) = of_graph_get_port_parent(ep);
+	node = of_graph_get_port_parent(ep);
 
 	/*
 	 * Try to find from DAI node
@@ -1121,8 +1122,10 @@ int graph_util_parse_dai(struct device *dev, struct device_node *ep,
 	 *    if he unbinded CPU or Codec.
 	 */
 	ret = snd_soc_get_dlc(&args, dlc);
-	if (ret < 0)
+	if (ret < 0) {
+		of_node_put(node);
 		return ret;
+	}
 
 parse_dai_end:
 	if (is_single_link)
-- 
2.53.0




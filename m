Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864F1146D6B;
	Mon,  6 Jan 2025 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177891; cv=none; b=Nm9ZAuPXIzUb5rZdYG6QD2ZNfmFJxekIW2gu/d4/a3mbpEf4kDe/baQAt196Ae97OdYHSDYUacDirzcw97HL8Ft1a93O0rrbFNa8pt+TYMJ89vbaQEggoldHqy+ItySCWNep0rN8A7hzAberrC8PSg0OqQBaZnxAEyMndrHI0TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177891; c=relaxed/simple;
	bh=/oELpSGNvwWKajDqFGel/XJmVN+MNMnuc4YR+xpia7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wo20q6VIVgt3X7qwLc9sTGBpjXApLrtXvipAsm5MCEEFR9h25BoHi2ADYgXaBqY2HWbcSj7qTCu9HLui/GEwySyy+Ew7JBdUBlhsgA56XdXfpRmZItZ0MNwDzerdFkhTEPlakVD2MmggZGTMegLOuwx6QqGRr7auStBzrLbFwVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XokFudkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XokFudkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E36C4CED2;
	Mon,  6 Jan 2025 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177891;
	bh=/oELpSGNvwWKajDqFGel/XJmVN+MNMnuc4YR+xpia7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XokFudkhMakkLut0acWFGNni1mBIDuW4TlntHnpirv5t+ciA5UYBH9xwt9h5j5+Vq
	 9F4IvKU2sF2vl0Pq9pq5MGREDdrAnuvhX0IbeYgc46RA8G+XtoO7E9qmdavpKyVwPC
	 3+H/2MJBoWAjxoGf5p19F1OgM/PWyZ18JHRyQdDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Gordon <gordoste@iinet.net.au>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/156] ASoC: audio-graph-card: Call of_node_put() on correct node
Date: Mon,  6 Jan 2025 16:16:18 +0100
Message-ID: <20250106151145.192089651@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stephen Gordon <gordoste@iinet.net.au>

[ Upstream commit 687630aa582acf674120c87350beb01d836c837c ]

Signed-off-by: Stephen Gordon <gordoste@iinet.net.au>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/20241207122257.165096-1-gordoste@iinet.net.au
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/audio-graph-card2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/generic/audio-graph-card2.c b/sound/soc/generic/audio-graph-card2.c
index 93eee40cec76..63837e259659 100644
--- a/sound/soc/generic/audio-graph-card2.c
+++ b/sound/soc/generic/audio-graph-card2.c
@@ -779,7 +779,7 @@ static void graph_link_init(struct simple_util_priv *priv,
 	of_node_get(port_codec);
 	if (graph_lnk_is_multi(port_codec)) {
 		ep_codec = graph_get_next_multi_ep(&port_codec);
-		of_node_put(port_cpu);
+		of_node_put(port_codec);
 		port_codec = ep_to_port(ep_codec);
 	} else {
 		ep_codec = port_to_endpoint(port_codec);
-- 
2.39.5




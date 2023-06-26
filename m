Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A7411CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00CEC433C0;
	Mon, 26 Jun 2023 18:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805212;
	bh=vixycZa0jXtagiMlhPDBWtOLoaPdv3OMpN1lDdPe7/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=furMkqRrxYlN004LeivwhbE17wgM9GjqQnKG02lbcN6i+c05u5EhD2WMS5y+cbCyA
	 uN3VVsgt36Awh6szl2RYB4NhWxvElvBsZ7zpOHmaFDBvnfbXon/xpXLoflpOv0uWwl
	 7mAUDQ3KhPGDwdoSYpbgaoffMufIXg896/sNs3bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 69/81] ASoC: simple-card: Add missing of_node_put() in case of error
Date: Mon, 26 Jun 2023 20:12:51 +0200
Message-ID: <20230626180747.260154652@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 8938f75a5e35c597a647c28984a0304da7a33d63 ]

In the error path, a of_node_put() for platform is missing.
Just add it.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/20230523151223.109551-9-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index d916ec69c24ff..ac97e8b7978c7 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -410,6 +410,7 @@ static int simple_for_each_link(struct asoc_simple_priv *priv,
 
 			if (ret < 0) {
 				of_node_put(codec);
+				of_node_put(plat);
 				of_node_put(np);
 				goto error;
 			}
-- 
2.39.2




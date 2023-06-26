Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B664311CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FC9C433C0;
	Mon, 26 Jun 2023 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804921;
	bh=nTI7pPgS7BOpSuI/AM4DnIKQQrlTz4muk9KdSoreDN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI302yF6VaS8yW0ukifA25vHkvPeikZdaU9SyWUwonKGainun7llCjQtYyMDwY4eD
	 wjzs3mGEIBSoveAo8qqY4gtlydXxRmUBgXrW4fPhnfMg32ZM/JwIp7JC8O9uxV/La4
	 t/ejA2MC9wxRdkeQ/VFn54VCXSf6q5kBvK7ZCRgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 86/96] ASoC: simple-card: Add missing of_node_put() in case of error
Date: Mon, 26 Jun 2023 20:12:41 +0200
Message-ID: <20230626180750.589909998@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
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
index bc3e24c6a28a8..283aa21879aa5 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -417,6 +417,7 @@ static int __simple_for_each_link(struct asoc_simple_priv *priv,
 
 			if (ret < 0) {
 				of_node_put(codec);
+				of_node_put(plat);
 				of_node_put(np);
 				goto error;
 			}
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531481772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9843C433D2;
	Mon, 15 May 2023 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173711;
	bh=UAkM6BCan3pd27mE2CCWJeWMMJYX22ZFb7/qO9LiNVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aB1MEi6/yJV0ERttopRE83orP8mtmQqQZWmTqaJ7mnXPTLuIoaiaiOoO8atyz8yxW
	 6rrzBi0Mpur9OfHnqY6sN8i2wG/PgjKmAffItrQiFuTdWNP7FmlH7Nw/1emhzbKkQV
	 ibfHWrG0s1TmGgK3qCFC3v5JLmXqawhNNXnwYqiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/282] dmaengine: mv_xor_v2: Fix an error code.
Date: Mon, 15 May 2023 18:29:21 +0200
Message-Id: <20230515161727.760075188@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 827026ae2e56ec05ef1155661079badbbfc0b038 ]

If the probe is deferred, -EPROBE_DEFER should be returned, not
+EPROBE_DEFER.

Fixes: 3cd2c313f1d6 ("dmaengine: mv_xor_v2: Fix clock resource by adding a register clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/201170dff832a3c496d125772e10070cd834ebf2.1679814350.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/mv_xor_v2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/mv_xor_v2.c
+++ b/drivers/dma/mv_xor_v2.c
@@ -751,7 +751,7 @@ static int mv_xor_v2_probe(struct platfo
 
 	xor_dev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(xor_dev->clk) && PTR_ERR(xor_dev->clk) == -EPROBE_DEFER) {
-		ret = EPROBE_DEFER;
+		ret = -EPROBE_DEFER;
 		goto disable_reg_clk;
 	}
 	if (!IS_ERR(xor_dev->clk)) {



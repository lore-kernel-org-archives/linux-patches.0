Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062062;
	b=PRPZiILSSkrzJXz1Eby9yygXilfjGKgwjNC90uvXV9VaqdURWggKqRN0/FRaszRnAW5m
	 Xmq+d3H06ZRBq556DgmupPshJOGaeQ+bPwgl2mcpvEyfLJKorVTQem98JN5nCvF7Ho5Ia
	 1coyDos33d62KlF7IS4rLDm2/INqq5S7M+cu6pDxk/mv5m6sbxN1rD7HkWuy/FWLCA3P7
	 gcz8YtWE4Gfi0AyyahIsMVr04lPAUBP7Wfd6fTXjV2qkbeTP5FvfeInrhuwecUe0oLGg9
	 IXOVZo5kJBs22K3n/E9rT2lJqSx/fyNSOsmqEsvz122ONmAexEPU5NRvnfKYR+P/puQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rxy3eAtH7ZmkTZaNFkvYWYvxRLb/wfYfOcQif1J0l1U=;
	b=W8iI0vSmwdt7UEHAtQ2s/I8vIqYh1HzKQX8Zb6FBlUKok/YG1IoOJ3kIkbYtQyRQVB4P
	 UU5ItcAxcr83wrEx0McCw7zboeppumw5AzgjYRL5xKBhdgoYUUpjUPYMqjrH6FoQq7xGR
	 dBFRkG23/qU7CA70DODsu6Xs6IC+6k21pbgivOqyAioxy9LvVNykb/UJfbw1/5UAJe0zq
	 y91cNvNpwZWuvpsv5oUubq3udQdukZlpOawhKlSMwRJonoH20g/oK1QW9ZS4noujeWyGY
	 H/j9JQwJVm7P1hm/JeL/cfSksYUUWxn4aTX8jlgAjeDifVgj2EQZfwsGMGoh3J6TVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPjQgdTY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3102606D80A;
	Sat,  7 Nov 2026 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yPjQgdTY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAC01F008A2;
	Sat,  7 Nov 2026 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062061;
	bh=rxy3eAtH7ZmkTZaNFkvYWYvxRLb/wfYfOcQif1J0l1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPjQgdTYQUW8Wmqny66g0DIpSk8w7cieIp8Xh67hl0bmLdQ7mQ4bzhWbUXGIU00El
	 LRDeDkbfB1GhZ2SZWaUvGLXHnxs1/xQrRozfOiaJbOMpfkRdT1DTz+W//HSamsgDWs
	 CaTmJQVpqmDXSwnKZ6N1gaTVL0uh1dSfYyQS70tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1042/1536] media: marvell: manage the MMP camera clock provider
Date: Sat,  7 Nov 2026 08:50:58 -0500
Message-ID: <20261107135026.941121386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9887716132d6c3c58cc67841dfb441c5a4a0d209 ]

mmpcam_probe() registers an OF clock provider before requesting the IRQ.
Neither a later probe failure nor driver removal unregisters that provider,
although the underlying clock is registered with devm_clk_register().
This leaves the provider referring to a clock whose lifetime has ended.

Use devm_of_clk_add_hw_provider() with the existing mclk_hw so the provider
is unregistered before the managed clock and camera storage are released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell/mmp-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell/mmp-driver.c b/drivers/media/platform/marvell/mmp-driver.c
index 4fa171d469cab..cf642cc02efdb 100644
--- a/drivers/media/platform/marvell/mmp-driver.c
+++ b/drivers/media/platform/marvell/mmp-driver.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 
 #include "mcam-core.h"
 
@@ -269,8 +270,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 	/*
 	 * Add OF clock provider.
 	 */
-	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get,
-								mcam->mclk);
+	ret = devm_of_clk_add_hw_provider(&pdev->dev, of_clk_hw_simple_get,
+					  &mcam->mclk_hw);
 	if (ret) {
 		dev_err(&pdev->dev, "can't add DT clock provider\n");
 		goto out;
-- 
2.53.0




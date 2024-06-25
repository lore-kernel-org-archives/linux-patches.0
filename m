Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB13312EBEA;
	Tue, 25 Jun 2024 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308531; cv=none; b=hHE4RfNFb+PCmmQ81Nozy2+/K7nwgwd4Edl/0rNlP2/T+NjzdUIlhC3TzZhPb50AYfHHk/K+dgS6KrIYrskzaDekMXXqa+LRiUb0dIY7xLk59cUrE+L5xI8XnrhKIyyyfZjmj1MKX6y6JqQmuwbFnxtmmnqk/fB6n5+EztQkNG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308531; c=relaxed/simple;
	bh=qGqZyWF3BcWEzSJHjfeyPaCKdCsSMtESFhiG2NWRP5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWXyl0XOPprNsqAkDf6cWMqQK4aSnlCt1zoZM46dLvnu3EfQ8qZMGGM8WvXUMfDHWD3gXkp4Jf1Ulwd4Vv84GXmTbsncRV/dWyDP65J31md+iaaocgH6y3JFfR0e7AMbz8CQ99kf3Gz0E8fOi2S0dX13Qi2rn2bWcIS3fYTVxEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1DAXrV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1DAXrV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07113C32781;
	Tue, 25 Jun 2024 09:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308530;
	bh=qGqZyWF3BcWEzSJHjfeyPaCKdCsSMtESFhiG2NWRP5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1DAXrV0yhQN1SrrRCRhzzjIaXtlw9BxMAAS3voNfVJwlrIfDg4oLHxVd7qJDGawk
	 7Yh3hzwRZEyOK3QpI16DyHg5FVI2Gz5t0uo5xxxTZsv1/Oj+ooMQTEfzq/ZkpWLrEX
	 OLTRXvm45rzhjVCSWIUtJnQxAJReKG4xxaNP3U9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 152/250] dmaengine: ti: k3-udma-glue: Fix of_k3_udma_glue_parse_chn_by_id()
Date: Tue, 25 Jun 2024 11:31:50 +0200
Message-ID: <20240625085553.894330024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit ba27e9d2207784da748b19170a2e56bd7770bd81 ]

The of_k3_udma_glue_parse_chn_by_id() helper function erroneously
invokes "of_node_put()" on the "udmax_np" device-node passed to it,
without having incremented its reference count at any point. Fix it.

Fixes: 81a1f90f20af ("dmaengine: ti: k3-udma-glue: Add function to parse channel by ID")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Acked-by: Peter Ujfalusi@gmail.com
Link: https://lore.kernel.org/r/20240602013319.2975894-1-s-vadapalli@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma-glue.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/ti/k3-udma-glue.c b/drivers/dma/ti/k3-udma-glue.c
index c9b93055dc9d3..f0a399cf45b2a 100644
--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -200,12 +200,9 @@ of_k3_udma_glue_parse_chn_by_id(struct device_node *udmax_np, struct k3_udma_glu
 
 	ret = of_k3_udma_glue_parse(udmax_np, common);
 	if (ret)
-		goto out_put_spec;
+		return ret;
 
 	ret = of_k3_udma_glue_parse_chn_common(common, thread_id, tx_chn);
-
-out_put_spec:
-	of_node_put(udmax_np);
 	return ret;
 }
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C011C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE7CC433D2;
	Wed, 28 Dec 2022 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243504;
	bh=CrhYTI12EfCuNJIiCDZ0o4WMBOwdSivhCuvyUCKXg8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xh9x6FlXBzaNsqsj1W0BUBPUe/vtRDrP+XPpSz8FpLqh4kNCaUZHblAXbNc6POJ0m
	 SGn04Mf0LZ9mdaXb/Wot+V54kD3iQAx6aLnNj8Caw2qTFPBVnAwRV8UY34kJLHdwK5
	 4ZTQzMmIyg+afJshFZkz1104uxVJI9Top1HM9voo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 728/731] net: stmmac: fix errno when create_singlethread_workqueue() fails
Date: Wed, 28 Dec 2022 15:43:55 +0100
Message-Id: <20221228144317.543382738@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 2cb815cfc78b137ee38bcd65e7c955d6cc2cc250 upstream.

We should set the return value to -ENOMEM explicitly when
create_singlethread_workqueue() fails in stmmac_dvr_probe(),
otherwise we'll lose the error value.

Fixes: a137f3f27f92 ("net: stmmac: fix possible memory leak in stmmac_dvr_probe()")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221214080117.3514615-1-cuigaosheng1@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7046,6 +7046,7 @@ int stmmac_dvr_probe(struct device *devi
 	priv->wq = create_singlethread_workqueue("stmmac_wq");
 	if (!priv->wq) {
 		dev_err(priv->device, "failed to create workqueue\n");
+		ret = -ENOMEM;
 		goto error_wq_init;
 	}
 



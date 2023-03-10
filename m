Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A7A8489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82669C433EF;
	Fri, 10 Mar 2023 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457825;
	bh=2FdVxE4nwc+ZHfnl6GhC5qrx7jfOgWD7CIJ4tKJBp24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7ScuRPeCeBCQmYPWoUf/HzKFTYzAC3yuC+6mLqk9H5h59e6b6Hz4A27NyzXroFeN
	 KOlo7EDRFW3E1S678YSj9MJ+acYwiW4Rze1vk+cGy7qrESST1sy0sGZZ9lVF/Yaf51
	 +ZBzSuW1vKvdEZS0IYg0eSac7K0HXxql3tbdvK50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/252] gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()
Date: Fri, 10 Mar 2023 14:37:21 +0100
Message-Id: <20230310133720.974062477@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

[ Upstream commit 9afdf98cfdfa2ba8ec068cf08c5fcdc1ed8daf3f ]

In ipu_add_client_devices(), we need to call of_node_put() for
reference returned by of_graph_get_port_by_id() in fail path.

Fixes: 17e052175039 ("gpu: ipu-v3: Do not bail out on missing optional port nodes")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20220720152227.1288413-1-windhl@126.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220720152227.1288413-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 0a7d4395d427b..f6e74ff7ef75d 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1238,6 +1238,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 		pdev = platform_device_alloc(reg->name, id++);
 		if (!pdev) {
 			ret = -ENOMEM;
+			of_node_put(of_node);
 			goto err_register;
 		}
 
-- 
2.39.2




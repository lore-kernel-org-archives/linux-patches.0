Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B98BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395E8C433D2;
	Tue,  7 Mar 2023 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209808;
	bh=fDXQaiwd3L1K5OwugWn2eiInNuyj6M7dFn8Gu9ct/OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L76G0Bz8hdavidFKptsfUNXVhxUMitRKW4v5kwi2QEDB7RssuTbYa1LGM9HH7SDcl
	 PQn4n47NB0h8qohZUkgnfqvlVhlC/4iyE8/5x7igAwlv6B3DJKDY/Q4ubFjNpD/paF
	 mzMLCSg3yJT9Lzs9UK5l0bIvht45r+0t81PF1P7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0339/1001] gpu: ipu-v3: common: Add of_node_put() for reference returned by of_graph_get_port_by_id()
Date: Tue,  7 Mar 2023 17:51:51 +0100
Message-Id: <20230307170036.190888121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 118318513e2d2..c35eac1116f5f 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1165,6 +1165,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 		pdev = platform_device_alloc(reg->name, id++);
 		if (!pdev) {
 			ret = -ENOMEM;
+			of_node_put(of_node);
 			goto err_register;
 		}
 
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE4311706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA3CC433C7;
	Mon, 11 Sep 2023 14:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443872;
	bh=XaFOlpTo0K7UW8m3C4bv+d3tuq8OZE1lZ22aySLPbZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAf0ajg25vYs0D8H/CxU2K5DckPqv1aaNykljk8aqTFjAmUsDXDTfLxRaQ1e1WnS8
	 MJchLlkU85Rj3A46cf97DsV5cekFRIlhkH1sWZiYelhFaxmuowVLg8eOs3eT7n51NM
	 9roJL8drN2u0lVdeOaybRxF4JvHUjm+35d3iPDls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 531/737] driver core: test_async: fix an error code
Date: Mon, 11 Sep 2023 15:46:30 +0200
Message-ID: <20230911134705.408517303@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 22d2381bbd70a5853c2ee77522f4965139672db9 ]

The test_platform_device_register_node() function should return error
pointers instead of NULL.  That is what the callers are expecting.

Fixes: 57ea974fb871 ("driver core: Rewrite test_async_driver_probe to cover serialization and NUMA affinity")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/1e11ed19-e1f6-43d8-b352-474134b7c008@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/test/test_async_driver_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/test/test_async_driver_probe.c b/drivers/base/test/test_async_driver_probe.c
index 929410d0dd6fe..3465800baa6c8 100644
--- a/drivers/base/test/test_async_driver_probe.c
+++ b/drivers/base/test/test_async_driver_probe.c
@@ -84,7 +84,7 @@ test_platform_device_register_node(char *name, int id, int nid)
 
 	pdev = platform_device_alloc(name, id);
 	if (!pdev)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	if (nid != NUMA_NO_NODE)
 		set_dev_node(&pdev->dev, nid);
-- 
2.40.1




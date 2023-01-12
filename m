Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09D979C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC825C433D2;
	Thu, 12 Jan 2023 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533344;
	bh=8sqdTsWFYP3san1PFpsmlfbUMGekp50NGrDGRL77oSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hb3MrqN94gmyjooYyxzi7BCEAfFgX6TDNHqH7qnbrNjgEggYxtOUaLhviZ5+U0/Sn
	 8+RjpyG6RPcCFGhLMNmMt0d1vFR0wbx3DjYPUHtQu6962cDcrnO972rU0QDFQr/iT2
	 J/SsuMTpTkbLP9iBe9Jxh7ZiOHkLsmwXaWPFpx3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 449/783] remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()
Date: Thu, 12 Jan 2023 14:52:45 +0100
Message-Id: <20230112135545.069599124@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 38e7d9c19276832ebb0277f415b9214bf7baeb37 ]

The pointer node is returned by of_parse_phandle() with refcount
incremented. We should use of_node_put() on it when done.

Fixes: b9e718e950c3 ("remoteproc: Introduce Qualcomm ADSP PIL")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221203070639.15128-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index d8ef10fba8e8..1a0d6eb9425b 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -365,6 +365,7 @@ static int adsp_alloc_memory_region(struct qcom_adsp *adsp)
 	}
 
 	ret = of_address_to_resource(node, 0, &r);
+	of_node_put(node);
 	if (ret)
 		return ret;
 
-- 
2.35.1




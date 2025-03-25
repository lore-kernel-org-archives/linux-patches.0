Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513F9259CAD;
	Tue, 25 Mar 2025 12:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905782; cv=none; b=a/EXZKcLjiypAmdZjkFdcIOF3MfAm3Mhd6ayFZ+EUPnpMvBJ2MLSzUOEKgLuPm+AnZtQgYgoIJO1nH4B67pgdUwTRskBT0+oC2FrG4FRshZAlLC7yhmtFlsPbzg5Cpx+AlsIiVsndOkPjSRmCiARJo3NomELoti2sXtn/m+fjec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905782; c=relaxed/simple;
	bh=M7wty/YWXqwJciqVW2j+k673FIkSFbFYPACcN32C8iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9YixOxs9FfHrgGoeoGnNcExkX3XpeaHYg/adyFiwzdP1jqTA4cw63Bf5bXfIdg2zKFfzU7WJXC976PWp8BDqVq4kL7q3ADpDXPj0uIHWuS1+uoq4uJAbmrsMHKT9fxe21SJJ0MCGIHvBSCoFpx9SEr+lITjPY3axCw7UNzaxnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXzFBAzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXzFBAzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D76C4CEE4;
	Tue, 25 Mar 2025 12:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905782;
	bh=M7wty/YWXqwJciqVW2j+k673FIkSFbFYPACcN32C8iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXzFBAzwkfOehNHPTiKM8XrG19MU3s308qkeFJ255jQKre3Cf6yNV0tAl9WJtDZW2
	 K2C+eBX+iJ3xierd69j9y/uJsTdNHJpLl4v7Tpe/3cA1yFkhymEyIK7AFABOy1yYU+
	 sQSrhwAJPRyFh5gafZY8WwZRDeOsSW3OQTycPgho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/198] RDMA/hns: Fix wrong value of max_sge_rd
Date: Tue, 25 Mar 2025 08:22:02 -0400
Message-ID: <20250325122200.853589213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6b5e41a8b51fce520bb09bd651a29ef495e990de ]

There is no difference between the sge of READ and non-READ
operations in hns RoCE. Set max_sge_rd to the same value as
max_send_sge.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index afe7523eca909..5106b3ce89f08 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -182,7 +182,7 @@ static int hns_roce_query_device(struct ib_device *ib_dev,
 				  IB_DEVICE_RC_RNR_NAK_GEN;
 	props->max_send_sge = hr_dev->caps.max_sq_sg;
 	props->max_recv_sge = hr_dev->caps.max_rq_sg;
-	props->max_sge_rd = 1;
+	props->max_sge_rd = hr_dev->caps.max_sq_sg;
 	props->max_cq = hr_dev->caps.num_cqs;
 	props->max_cqe = hr_dev->caps.max_cqes;
 	props->max_mr = hr_dev->caps.num_mtpts;
-- 
2.39.5




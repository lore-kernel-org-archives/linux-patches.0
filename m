Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5834551C2B;
	Mon, 11 Dec 2023 18:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osmdBiu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83121C433CA;
	Mon, 11 Dec 2023 18:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702318907;
	bh=qLbH2aCleRDa554YQyoz4d7PQ0yqpCg0bTjXxbQuqUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osmdBiu67zZn7MzeyxzEIA3vAtzs1yTL6CT1KHrzq2V+LtkEZy8i/Me4zmKWdJx5S
	 3baeBAc8yYwTz+OBxR8Sb0g0iFvN3u8v6le7gXhofecplfKC12kCpTHWSWb5oYgwOb
	 cSrNexiXqgsf9bCzU30CPioHUrgR9j5X805Lvt/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/25] RDMA/bnxt_re: Correct module description string
Date: Mon, 11 Dec 2023 19:20:57 +0100
Message-ID: <20231211182008.926090191@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182008.665944227@linuxfoundation.org>
References: <20231211182008.665944227@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 422b19f7f006e813ee0865aadce6a62b3c263c42 ]

The word "Driver" is repeated twice in the "modinfo bnxt_re"
output description. Fix it.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1700555387-6277-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 7d00b6a53ed8c..bd14f6daee52d 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -70,7 +70,7 @@ static char version[] =
 		BNXT_RE_DESC " v" ROCE_DRV_MODULE_VERSION "\n";
 
 MODULE_AUTHOR("Eddie Wai <eddie.wai@broadcom.com>");
-MODULE_DESCRIPTION(BNXT_RE_DESC " Driver");
+MODULE_DESCRIPTION(BNXT_RE_DESC);
 MODULE_LICENSE("Dual BSD/GPL");
 
 /* globals */
-- 
2.42.0




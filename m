Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D17E183CD9;
	Mon, 12 Aug 2024 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479881; cv=none; b=fjHWb8I0zcPpC45xR54sioMkc1DHBFguxGIcm5kqu7Y3JVKmBwK3S3RbLB63ns1xDi5B0Xa2AbDOYEMKgKLTZan4fArBSzYpIoFtyASN8dt9GLWIBEa7QpDw88gE4axLbT4jvq8AZNknWfzS9OaO5WaQVVtGbHJiX8WF1upgDDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479881; c=relaxed/simple;
	bh=JQFGRZk9ZNqIEqorsbr39gqi3VxI/aYZo+txPHdMDJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWUbc9ugd9HQl4r5ZJ/Wk1rLao1EOpAoYprKXr76+EynVrVw2OpzLO+VTQFj9JSmWqPSD8bWTO69NkHB4d67IBwG8lLidbTvlk1FIzfVOVgq25WA9znELUg2fvVJD05+Sy7+G2fEgHhJ9bBXmxyTE2/CZW3pq6M2xkx3eeyBZOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkRzlb8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkRzlb8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14626C32782;
	Mon, 12 Aug 2024 16:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479881;
	bh=JQFGRZk9ZNqIEqorsbr39gqi3VxI/aYZo+txPHdMDJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkRzlb8sE3q+sZtfUaZ0rrDXs4ndHnGgV9TFcC81ZNRNNizvY/S19gqeLAxkC2IZl
	 Qoi/IMDte2AexesdROFqmhSjCVIP/GyhVjJnQdfYuZ9lOZPXd5NCMGeQaG7haVJ4WA
	 dXniiPxHAPsDu6DzEnB6mRlqfbjP7jOPfICa7bzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 030/263] net/smc: add the max value of fallback reason count
Date: Mon, 12 Aug 2024 18:00:31 +0200
Message-ID: <20240812160147.695625119@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit d27a835f41d947f62e6a95e89ba523299c9e6437 ]

The number of fallback reasons defined in the smc_clc.h file has reached
36. For historical reasons, some are no longer quoted, and there's 33
actually in use. So, add the max value of fallback reason count to 36.

Fixes: 6ac1e6563f59 ("net/smc: support smc v2.x features validate")
Fixes: 7f0620b9940b ("net/smc: support max connections per lgr negotiation")
Fixes: 69b888e3bb4b ("net/smc: support max links per lgr negotiation in clc handshake")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Link: https://patch.msgid.link/20240805043856.565677-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_stats.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_stats.h b/net/smc/smc_stats.h
index 9d32058db2b5d..e19177ce40923 100644
--- a/net/smc/smc_stats.h
+++ b/net/smc/smc_stats.h
@@ -19,7 +19,7 @@
 
 #include "smc_clc.h"
 
-#define SMC_MAX_FBACK_RSN_CNT 30
+#define SMC_MAX_FBACK_RSN_CNT 36
 
 enum {
 	SMC_BUF_8K,
-- 
2.43.0




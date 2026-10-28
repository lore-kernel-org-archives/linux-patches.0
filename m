Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215538;
	b=05U9ezVJWDEqbpPNx/JSXUB2EJjXbpwwjhFbOPM+qnZsq1sULnXmV/2dl1EFVDVT2Fpj
	 M95UD/VyiiRzvGKSskYcNPH4iLBOXt3rVUpp1Ti0rg5DWfgMYwt2pL9bDFcK4BxC02avK
	 g+5lHHwIwuT4loJrQNMIRRnr1M4L3QQIyvCYolO9xNx0xnrbZf7ira/jM8YzfhaKtmfTl
	 gm51JbgnseQWWkIc87pWiV6PcnekM61FK4UZZQURwVcDyf4dLeUhuVIsbMxkrOB8FWm55
	 LdZCoSIvq29Lqjs4kTyf7CLWktua255JSudWNj8tRNib7oZesA4arW6dPz14oEQQdlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2pqmeZjYrQvQVdkghSfQuiaxpA5CPi4dQ8Ow8vCzLmY=;
	b=hbXdvawMbusS60uHAzoLz3sVllQ4+ySv9npTYDJdfsRP4Y6KrCYtRO91tqzvcnBHX/qR
	 Im5HqabaubE94NXjpsiRSq92iEP3zD9F9VZVYRS5XBvmoiohD3ylmNd9tSN+lrLtRdyS+
	 IXRls0Htu7521mWsD77oiaoRM5OE0ANdMQSdFmxghzO9gSpFr53OXKOGtLhqG40XBoNhu
	 vzgCkR63jHDu7YWs+eGq1VW2iFS9UmiZDmys4Qi43eAE1cCl0cbDn47ao8Idm1cFI8zJZ
	 BACRdV2oyHOwMrLem/lxRqvv/ozJXjVq8JSd6DufrObhnwTCZ4Yr2o9BNm8XCUFLceg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSninDES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40336606A31A;
	Wed, 28 Oct 2026 19:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSninDES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2451F01825;
	Wed, 28 Oct 2026 19:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215538;
	bh=2pqmeZjYrQvQVdkghSfQuiaxpA5CPi4dQ8Ow8vCzLmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSninDESgv2a4Bof17POZO+/QmA+Eei/UxDNcdYv9A770MXfvLNxEacOX818nsKWu
	 zUPSfFNgUwX68I333S5WRqqei3zZAz/SceuK/GVz5NJD8/ljrSxD1dIgw2ySh5xf4R
	 4JM7Q0pH03/Qo44/mC1HWoyqzFmMp++IHKh1rvb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Baoli.Zhang" <baoli.zhang@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1245/1887] soundwire: fix bug in sdw_add_element_group_count found by syzkaller
Date: Wed, 28 Oct 2026 17:55:41 +0100
Message-ID: <20261028170527.755869523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoli.Zhang <baoli.zhang@linux.intel.com>

[ Upstream commit f772ff5a0e6758fd412803c09e03ba3bca5f5878 ]

The original implementation caused an out-of-bounds memory access
in the sdw_add_element_group_count for-loop when i == num.

for (i = 0; i <= num; i++) {
    if (rate == group->rates[i] && lane == group->lanes[i])
        ...

To fix this error, the function now checks for existing rate/lane
entries in the group(a function parameter) using a for-loop before
adding them.

No functional changes apart from this fix.

Fixes: 9026118f20e2 ("soundwire: Add generic bandwidth allocation algorithm")
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Baoli.Zhang <baoli.zhang@linux.intel.com>
Link: https://patch.msgid.link/20260506055039.3751028-2-baoli.zhang@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../soundwire/generic_bandwidth_allocation.c  | 31 +++++++++----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/soundwire/generic_bandwidth_allocation.c b/drivers/soundwire/generic_bandwidth_allocation.c
index f7c66083a4dd5..36bb3f8133aa9 100644
--- a/drivers/soundwire/generic_bandwidth_allocation.c
+++ b/drivers/soundwire/generic_bandwidth_allocation.c
@@ -210,28 +210,25 @@ static int sdw_add_element_group_count(struct sdw_group *group,
 	int num = group->count;
 	int i;
 
-	for (i = 0; i <= num; i++) {
+	for (i = 0; i < num; i++) {
 		if (rate == group->rates[i])
-			break;
-
-		if (i != num)
-			continue;
-
-		if (group->count >= group->max_size) {
-			unsigned int *rates;
+			return 0;
+	}
 
-			group->max_size += 1;
-			rates = krealloc(group->rates,
-					 (sizeof(int) * group->max_size),
-					 GFP_KERNEL);
-			if (!rates)
-				return -ENOMEM;
-			group->rates = rates;
-		}
+	if (group->count >= group->max_size) {
+		unsigned int *rates;
 
-		group->rates[group->count++] = rate;
+		group->max_size += 1;
+		rates = krealloc(group->rates,
+				 (sizeof(int) * group->max_size),
+				 GFP_KERNEL);
+		if (!rates)
+			return -ENOMEM;
+		group->rates = rates;
 	}
 
+	group->rates[group->count++] = rate;
+
 	return 0;
 }
 
-- 
2.53.0




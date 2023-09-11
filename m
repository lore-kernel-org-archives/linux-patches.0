Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B5C11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ACBC433C7;
	Mon, 11 Sep 2023 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443381;
	bh=llvRtMn+ER/VDPIqyY/WvV1RcZsYnDbU3x6uEeGmzXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqlsonIYx4c5wHI/KDrc21HObsTtr0lcLXwzAGK0OBN+HTsyPTo/DtUnYdn7DWUP6
	 xMAgC4IICo2LHOUXhnXkgdo2T5j/QV7eLwK8tpQDoNF41KakimC568Ow4264w7tqcy
	 EN2gTkAro1JYyAdOcxok488d5BLWM9K0YP+BrX0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Jiahao <chenjiahao16@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 357/737] soc: qcom: smem: Fix incompatible types in comparison
Date: Mon, 11 Sep 2023 15:43:36 +0200
Message-ID: <20230911134700.493568041@linuxfoundation.org>
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

From: Chen Jiahao <chenjiahao16@huawei.com>

[ Upstream commit 5f908786cf44fcb397cfe0f322ef2f41b0909e2a ]

This patch fixes the following sparse error:

drivers/soc/qcom/smem.c:738:30: error: incompatible types in comparison expression (different add        ress spaces):
drivers/soc/qcom/smem.c:738:30:    void *
drivers/soc/qcom/smem.c:738:30:    void [noderef] __iomem *

In addr_in_range(), "base" is of type void __iomem *, converting
void *addr to the same type to fix above sparse error.

Fixes: 20bb6c9de1b7 ("soc: qcom: smem: map only partitions used by local HOST")
Signed-off-by: Chen Jiahao <chenjiahao16@huawei.com>
Link: https://lore.kernel.org/r/20230801094807.4146779-1-chenjiahao16@huawei.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index 6be7ea93c78cf..1e08bb3b1679a 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -723,7 +723,7 @@ EXPORT_SYMBOL(qcom_smem_get_free_space);
 
 static bool addr_in_range(void __iomem *base, size_t size, void *addr)
 {
-	return base && (addr >= base && addr < base + size);
+	return base && ((void __iomem *)addr >= base && (void __iomem *)addr < base + size);
 }
 
 /**
-- 
2.40.1




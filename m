Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2681170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2029C433C7;
	Mon, 11 Sep 2023 14:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441138;
	bh=VvUOTrbQQPycn5pjl9ipF8pwAnqHRWW8D87Y27N6a1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpbPzbOaKcMNsK5x8tY9JHF86oy4flPXe0YoMAgwyXFK3N/AR8rBC7tD95SH2h6Fo
	 7px9wxXhQkFin4YM2Kn3UmxP/KZwGFfKKx+gSjmvD/Kn/7PZAVBglq0rE2kfYd9hHk
	 mUfitTf3SHWH9221T3DSvYTLSqSArdX8n6rQXdlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Jiahao <chenjiahao16@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 308/739] soc: qcom: smem: Fix incompatible types in comparison
Date: Mon, 11 Sep 2023 15:41:47 +0200
Message-ID: <20230911134659.722436957@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index b0d59e815c3b7..a516b8b5efac9 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -724,7 +724,7 @@ EXPORT_SYMBOL_GPL(qcom_smem_get_free_space);
 
 static bool addr_in_range(void __iomem *base, size_t size, void *addr)
 {
-	return base && (addr >= base && addr < base + size);
+	return base && ((void __iomem *)addr >= base && (void __iomem *)addr < base + size);
 }
 
 /**
-- 
2.40.1




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D061D0951;
	Wed,  2 Oct 2024 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880038; cv=none; b=sbN1yjTABpa+3/I+m7oUUhZd/GGalZe6LBk+LOXcTHnqs58H33NCxgBsJ4je15ktevojiXw0K6oFNQWx1+/D4YiJkVWS2xb5S3MtTGKZyCpgjOkHqxLrxlD92HXBa6NKF1wAOF9+bdpLS5+XS+xFZin9RO2hdprduzqp5pBXGvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880038; c=relaxed/simple;
	bh=voLNUUMz/9riGRLA6OVQ3qgxEhephDOLveRXuQCy5KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETNKT2yNd5GMseH+OAv86TrdwNHUw0fOPioINsSGT1zGlvP61q8R6W23Nsr+Zt+YbrChE0l3ahzELlLm3ea+YKUfq2g2HWodqM7xze6ZlPNp9gi9whbBHkmH/j2ae9/pHjewAmG8+Cma3pkFnYXNzYu0eu+ppa1LLEm2v4nkkMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHREtbFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHREtbFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FA1C4CECD;
	Wed,  2 Oct 2024 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880038;
	bh=voLNUUMz/9riGRLA6OVQ3qgxEhephDOLveRXuQCy5KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHREtbFO263/TkN7WWWRbQHqaC8TQj5bIkh3oST5Qp7r+f5a0fbVQFsoG8hzM0iDt
	 EDIyETyiOTkDNsPBQBmgtDYW6Gc0aZWN9gf4YPVpZZ0KIK6e5qmj/fAMnMOfg3Skwg
	 PlHTHB3m34IHoUSE+Fjgyi9ZEXnpWfZ1dglKq1xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 322/538] RDMA/hns: Fix restricted __le16 degrades to integer issue
Date: Wed,  2 Oct 2024 14:59:21 +0200
Message-ID: <20241002125805.138661718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit f4ccc0a2a0c5977540f519588636b5bc81aae2db ]

Fix sparse warnings: restricted __le16 degrades to integer.

Fixes: 5a87279591a1 ("RDMA/hns: Support hns HW stats")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409080508.g4mNSLwy-lkp@intel.com/
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240909065331.3950268-1-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d226081e1cc03..8066750afab90 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1653,8 +1653,8 @@ static int hns_roce_hw_v2_query_counter(struct hns_roce_dev *hr_dev,
 
 	for (i = 0; i < HNS_ROCE_HW_CNT_TOTAL && i < *num_counters; i++) {
 		bd_idx = i / CNT_PER_DESC;
-		if (!(desc[bd_idx].flag & HNS_ROCE_CMD_FLAG_NEXT) &&
-		    bd_idx != HNS_ROCE_HW_CNT_TOTAL / CNT_PER_DESC)
+		if (bd_idx != HNS_ROCE_HW_CNT_TOTAL / CNT_PER_DESC &&
+		    !(desc[bd_idx].flag & cpu_to_le16(HNS_ROCE_CMD_FLAG_NEXT)))
 			break;
 
 		cnt_data = (__le64 *)&desc[bd_idx].data[0];
-- 
2.43.0




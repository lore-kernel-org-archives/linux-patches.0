Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF46C2FE56B;
	Tue, 12 Aug 2025 17:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020361; cv=none; b=MLtvz2RW3C1iHBRGJN3R6quFSnQypNdJCKVjH6k/NjFXtY6W9MNavP5hwHZmUM2lrvtkWUrQxmriGccJ8DtQDBd9N2dBA9300PFN18kGiMRMdBmpshfJOIVXOv+5Z6qHIZspJ5h00puGtzo1oK1p32MlbSJYGb+101PPepWXZP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020361; c=relaxed/simple;
	bh=hYv0K4SyiQcJAwtmEWApWqq6SiqiyjF7CbBN5/wpydM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ymvpwg1AnkkpglfSY63v8ZsjC7CFGEYWtXCmPZYC3kRuoPAqHg/ONUNha2/eAhISLCmXyx8RGZ9kB/yq2L1QCOWi+XYl/GSy72V5xMKvPbMB9/lGzZvv2e4WUwmUDoiB8geXuKNsfpubRjywKIEp3jsM8FEK5CJ9Je7X/8RGa50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IROl29tR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IROl29tR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615AAC4CEF0;
	Tue, 12 Aug 2025 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020360;
	bh=hYv0K4SyiQcJAwtmEWApWqq6SiqiyjF7CbBN5/wpydM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IROl29tR+WmgRa0FSFChUZ+wsY5f1KylKEoAsEwN6JDVJnrbmV4bjT3qUjXmAstb2
	 ODuc1yY453RRALw2hvaFdWVdnvR+v04TOR7MCfKQeeCaXg0MRZGmyFJlGtFS29mBBc
	 Z+kw/FQzp/mY94BqGO2qnz+08NPFJ2ZGxJHgykdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/253] net: hns3: fixed vf get max channels bug
Date: Tue, 12 Aug 2025 19:26:53 +0200
Message-ID: <20250812172949.799979516@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit b3e75c0bcc53f647311960bc1b0970b9b480ca5a ]

Currently, the queried maximum of vf channels is the maximum of channels
supported by each TC. However, the actual maximum of channels is
the maximum of channels supported by the device.

Fixes: 849e46077689 ("net: hns3: add ethtool_ops.get_channels support for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250722125423.1270673-4-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b11d38a6093f8..cff8654354e6d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3086,11 +3086,7 @@ static void hclgevf_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 static u32 hclgevf_get_max_channels(struct hclgevf_dev *hdev)
 {
-	struct hnae3_handle *nic = &hdev->nic;
-	struct hnae3_knic_private_info *kinfo = &nic->kinfo;
-
-	return min_t(u32, hdev->rss_size_max,
-		     hdev->num_tqps / kinfo->tc_info.num_tc);
+	return min(hdev->rss_size_max, hdev->num_tqps);
 }
 
 /**
-- 
2.39.5




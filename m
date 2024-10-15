Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA7D1B2183;
	Tue, 15 Oct 2024 13:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998575; cv=none; b=mmuzUx2nVDJbLA7+1kzVAyky4uIQ1RVCwiTqf0fO0wSmsH5W6b9x0Lql7BIYLEL2m0J9Ps4MajSPMjvuYupcKY9GPt07KUUrFBK8ZpfKll79Inv7M1zpFwBDUVmen9mhJjvkdctz9C1iNHWgi6UQ1gEyXCwSCWbSS0+wMPOGIag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998575; c=relaxed/simple;
	bh=GHdBxmFj2zCmaXUpe85KseiVkhOZflZIa6KDnM85AfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaZMh3no76oVKfz0MA2KZMliZHonfjAYr6ysK7bHYn32VFwu7IdCVKcW5C0E7cEo1jQP4FiSCOhDzxTSHiSylHFISalXMpk930Sy7E5olZzgPxzUAM3ZMBkJ6qdMnUIlpQ5VPHHMWZvKiwhav8gJueNcDc+UWjadJyv/WUq3gsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jl1GmUAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jl1GmUAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98714C4CEC6;
	Tue, 15 Oct 2024 13:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998575;
	bh=GHdBxmFj2zCmaXUpe85KseiVkhOZflZIa6KDnM85AfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jl1GmUAMCOLZ7RKAnrFyZiPeQ6UiHKE+rgsew6oUWgou2X+OviB+uCMi3k9HTNfQj
	 SNUI+AyglZOB1nDipf5HNN4/pthRCWpgD09o8C4o54bE+YZHnUJZwJksYF25WO2hXG
	 paPQkgAoXNQ4p+LRnW+XL1sP3mv7OCKAugJDichU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yixing Liu <liuyixing1@huawei.com>,
	Weihang Li <liweihang@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 518/518] RDMA/hns: Fix uninitialized variable
Date: Tue, 15 Oct 2024 14:47:02 +0200
Message-ID: <20241015123936.980450794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixing Liu <liuyixing1@huawei.com>

commit 2a38c0f10e6d7d28e06ff1eb1f350804c4850275 upstream.

A random value will be returned if the condition below is not met, so it
needs to be initialized.

Fixes: 9ea9a53ea93b ("RDMA/hns: Add mapped page count checking for MTR")
Link: https://lore.kernel.org/r/1624011020-16992-3-git-send-email-liweihang@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -832,7 +832,7 @@ int hns_roce_mtr_map(struct hns_roce_dev
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_buf_region *r;
 	unsigned int i, mapped_cnt;
-	int ret;
+	int ret = 0;
 
 	/*
 	 * Only use the first page address as root ba when hopnum is 0, this



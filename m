Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017580;
	b=Lo12RA2R2XQBnV3ShU5dSYRAHJxiZ5gt0wS5aYR/teoLotx8AP+MhYN0A/RX9GyhIQZK
	 cAt7y0Bs/c8YPwPtO8Ppl+hMoe9N5vm8mlaEJNZy4knAH1rkDzsULT8OR9gpT5FVmIT4G
	 A81fW2h4N+/SJa6+6oWRU37vU44O4S13UsjQt/upEamFY3soJtk674iAwcn2aAkl4IoTc
	 W1yQlitJH48TlDrHKoUWOsV+qN8H1ncMJUiWiOXSWb3loJhjOpO1WfXwhgWiaxDa7ZEL5
	 0zsZTnLgdLRVn7Qr4Tp1r6qslYC/dXpiXHBQo9JPckSd3EJmCZKHY+fhJi960ot47lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJv/kkBQXpJTcpGi+K7KoFihw2/lfxZS0BT/yVfTTQg=;
	b=y5gv+eDSPKNT4SGhlpY7c3rgEEBAuzTTgq3zz393N7wNdw5XeTmWRGaunACEJrjuMx1O
	 iUo9XuxarFolUfGr6mCkF9Wce+Dnkrl8Nk9jRV+bIcgdTcmtqyg2UE9J0fy/C9F4UbaFv
	 /ouIFgpV8mjWBpKy2iq6JawolUQlZ4mj1ostdAXRLxWo1VfUC/TEA3+ZdPLWpkXeZ3qqr
	 zUawXKPL8HefXt3MvLmOTwuZCKuTeHNF8cDi8PnQB+qjrIySop7W/C908VgHgsylFQch3
	 rTmn8HQTMLsNdt3A18f+VmW3emVYjt9a460yDPo0JqXLcfEd8VqzpoK9lM4xJfR71sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0wh3cYr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD60F60A260C;
	Wed, 18 Nov 2026 15:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b0wh3cYr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2181F000C4;
	Wed, 18 Nov 2026 15:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017580;
	bh=TJv/kkBQXpJTcpGi+K7KoFihw2/lfxZS0BT/yVfTTQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0wh3cYr5jSf544tptlt9rfxyWsPQUfciw92sCiVxvbdzul5nDz1w/DTXGM8MMnmf
	 sfnsenymJq2LZwGgmBF9riL26dy6sd0y7ugrY+i8OD3XMwzM2PcXJoDScQrGpoqdZM
	 7Gb/ECMo7ZJOFDGGmSLos/dh3XXrz7HY9MRxdgt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0935/2651] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Wed, 18 Nov 2026 15:36:15 +0100
Message-ID: <20261118150321.543988984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit ce29f6e741844a78ad1977f2a550ede27ecf95f8 ]

alloc_cq_buf() leaves user_access zero-initialized, but the device
writes CQEs into the CQ buffer. Set IB_ACCESS_LOCAL_WRITE so the buffer
is pinned writable, matching the device's write access.

Fixes: 744b7bdfa79e ("RDMA/hns: Support 0 hop addressing for CQE buffer")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-3-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 1dd0efb5620de..ae314f1367328 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -261,6 +261,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	buf_attr.region[0].size = hr_cq->cq_depth * hr_cq->cqe_size;
 	buf_attr.region[0].hopnum = hr_dev->caps.cqe_hop_num;
 	buf_attr.region_count = 1;
+	buf_attr.user_access = IB_ACCESS_LOCAL_WRITE;
 
 	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + PAGE_SHIFT,
-- 
2.53.0




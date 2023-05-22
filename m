Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFCC171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78555C433D2;
	Mon, 22 May 2023 19:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783067;
	bh=Yux8nf1Du0qzBZe3abSH0wU1WPcxOHXYz3L4KpTe2T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqHnVRgPrzK3YITmMmcZyoU1HK8eoYupjovOmrKLQkBKDQFAdX0VaYoN/IU8lb575
	 8dL3t+wghgPrDgZUUudG4zShPqZmHOUQoqpLN46zN6mYxDcC4r3zgWV7gNL7XsuhM1
	 3RiwrCVvmClxdKKzYGoxGGV4Skl+5RcArU38ClDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/203] net: hns3: fix output information incomplete for dumping tx queue info with debugfs
Date: Mon, 22 May 2023 20:09:13 +0100
Message-Id: <20230522190358.543918239@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 89f6bfb071182f05d7188c255b0e7251c3806f16 ]

In function hns3_dump_tx_queue_info, The print buffer is not enough when
the tx BD number is configured to 32760. As a result several BD
information wouldn't be displayed.

So fix it by increasing the tx queue print buffer length.

Fixes: 630a6738da82 ("net: hns3: adjust string spaces of some parameters of tx bd info in debugfs")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 15ce1a33649ee..3158c08a3aa9c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -123,7 +123,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "tx_bd_queue",
 		.cmd = HNAE3_DBG_CMD_TX_BD,
 		.dentry = HNS3_DBG_DENTRY_TX_BD,
-		.buf_len = HNS3_DBG_READ_LEN_4MB,
+		.buf_len = HNS3_DBG_READ_LEN_5MB,
 		.init = hns3_dbg_bd_file_init,
 	},
 	{
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 814f7491ca08d..fb0c907cec852 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -8,6 +8,7 @@
 #define HNS3_DBG_READ_LEN_128KB	0x20000
 #define HNS3_DBG_READ_LEN_1MB	0x100000
 #define HNS3_DBG_READ_LEN_4MB	0x400000
+#define HNS3_DBG_READ_LEN_5MB	0x500000
 #define HNS3_DBG_WRITE_LEN	1024
 
 #define HNS3_DBG_DATA_STR_LEN	32
-- 
2.39.2




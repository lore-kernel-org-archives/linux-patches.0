Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9576E171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EF7C433EF;
	Mon, 22 May 2023 19:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784908;
	bh=kBIMZF4dfVJoq85E9/5DVhfsutNvOQw3JwFfqGU7ZMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwOj9yrUhhjo3n1uTamtDxWSTpW8TiCbRb7gY5FwbD3u778PipK+mFX8umva/vncc
	 RopRU3CuuENzF8Cc4DG2e62tOwKayneVayS12kv4jJK+SHZmHhrHE/oht0DKXLO/V0
	 EFygcC47OmkFdYE/8AG6xsNNQ+mrvrsAsTYH3wlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Hao Lan <lanhao@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 241/364] net: hns3: fix output information incomplete for dumping tx queue info with debugfs
Date: Mon, 22 May 2023 20:09:06 +0100
Message-Id: <20230522190418.727115238@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
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
index 66feb23f7b7b6..bcccd82a2620f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -130,7 +130,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "tx_bd_queue",
 		.cmd = HNAE3_DBG_CMD_TX_BD,
 		.dentry = HNS3_DBG_DENTRY_TX_BD,
-		.buf_len = HNS3_DBG_READ_LEN_4MB,
+		.buf_len = HNS3_DBG_READ_LEN_5MB,
 		.init = hns3_dbg_bd_file_init,
 	},
 	{
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 97578eabb7d8b..4a5ef8a90a104 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -10,6 +10,7 @@
 #define HNS3_DBG_READ_LEN_128KB	0x20000
 #define HNS3_DBG_READ_LEN_1MB	0x100000
 #define HNS3_DBG_READ_LEN_4MB	0x400000
+#define HNS3_DBG_READ_LEN_5MB	0x500000
 #define HNS3_DBG_WRITE_LEN	1024
 
 #define HNS3_DBG_DATA_STR_LEN	32
-- 
2.39.2




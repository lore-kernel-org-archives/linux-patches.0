Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B571A28DF1B;
	Wed,  7 May 2025 18:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643378; cv=none; b=ZX7Q5D3M9ObEUVVTA7IX0q0sNxIqOE83Mj/SFMJZpbh8vBFw2N31rFA48vkx5+8BhmbT3daQBR1JY8QkuJHrBXu1j98wyi4JOvlD2NH+OqR4xLIjEBx2oouZhc6aoZRUSODvFDiihsUw3mGLPp3z+/slzN08gfMFbX15WEKANAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643378; c=relaxed/simple;
	bh=puAUILlyKoWXSSQuTQM8FCMyI0z3b405GI9Vztxwg9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPpFuNMCHZYoOmR3MkzbvCx02PBxVT5o4VHbpktbRqBO8rLXBAsXMxR4QetBJmWa2ImnXiWyiIVPuiw9aYBXfC7HAjwz01cHnUUCRGJ+K144jDLqk421TcAYFr3imEpDI8/b77Nwv1VMqzSF/AFsDnsN5WewbKY47KolW2hwZLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7NBb9Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7NBb9Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB4DC4CEE2;
	Wed,  7 May 2025 18:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643378;
	bh=puAUILlyKoWXSSQuTQM8FCMyI0z3b405GI9Vztxwg9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7NBb9ZeIe4lrZQZ9tUhPII6HVfZw6csUVR2v1WpBkwurUkloglBaqLCCFQgNFmje
	 GS9vxnK+YGIbqdzkOgeQXs7MXvRCW3r/Ui5ll72VV3WZ5CgaLt5OQoy3PCWe+ruc6F
	 XHVfg6MO4Uytzc+id0xv30gpuev7YoGAgzyM4VPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Lan <lanhao@huawei.com>,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 40/55] net: hns3: fixed debugfs tm_qset size
Date: Wed,  7 May 2025 20:39:41 +0200
Message-ID: <20250507183800.661117915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Lan <lanhao@huawei.com>

[ Upstream commit e317aebeefcb3b0c71f2305af3c22871ca6b3833 ]

The size of the tm_qset file of debugfs is limited to 64 KB,
which is too small in the scenario with 1280 qsets.
The size needs to be expanded to 1 MB.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20250430093052.2400464-4-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index bd801e35d51ea..d6fe09ca03d27 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -60,7 +60,7 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.name = "tm_qset",
 		.cmd = HNAE3_DBG_CMD_TM_QSET,
 		.dentry = HNS3_DBG_DENTRY_TM,
-		.buf_len = HNS3_DBG_READ_LEN,
+		.buf_len = HNS3_DBG_READ_LEN_1MB,
 		.init = hns3_dbg_common_file_init,
 	},
 	{
-- 
2.39.5




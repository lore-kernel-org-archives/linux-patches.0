Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3CA7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3F0C433D6;
	Wed,  2 Nov 2022 03:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358316;
	bh=JubC/NCeGN7BWUjyz+hjFzIlPpNMZchq9CXkUWZCrek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjPRuGRZlEFmVVcu6yLJaCNDGWM3XnahhFR+9oS4DNPq1Drs8JPQDIdHREV3709x6
	 TXTyNYjh1dBaYDJj2z5cVWOCDzsx2HryW7VoIidPD5ZOvStyRHP/h6PW566jIZKSuC
	 oEh4JPhMJdLdICfOuDuM9l+IP5eXycn7ohQ6+0mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/132] net: hinic: fix incorrect assignment issue in hinic_set_interrupt_cfg()
Date: Wed,  2 Nov 2022 03:32:56 +0100
Message-Id: <20221102022101.441244682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit c0605cd6750f2db9890c43a91ea4d77be8fb4908 ]

The value of lli_credit_cnt is incorrectly assigned, fix it.

Fixes: a0337c0dee68 ("hinic: add support to set and get irq coalesce")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index ca76896d9f1c..8b04d133b3c4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -892,7 +892,7 @@ int hinic_set_interrupt_cfg(struct hinic_hwdev *hwdev,
 	if (err)
 		return -EINVAL;
 
-	interrupt_info->lli_credit_cnt = temp_info.lli_timer_cnt;
+	interrupt_info->lli_credit_cnt = temp_info.lli_credit_cnt;
 	interrupt_info->lli_timer_cnt = temp_info.lli_timer_cnt;
 
 	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
-- 
2.35.1




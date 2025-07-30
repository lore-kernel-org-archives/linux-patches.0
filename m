Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24A920E6;
	Wed, 30 Jul 2025 09:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868766; cv=none; b=lTtrU2o0ydyexT3xBec/Bbg7X0es6BJ5uTjwDN/uB9Gmv0eeax3675IX12CKndd4kAhPIUBkcKx1rcPpD7hk8qIRcceMANlanJFtixcUThGmjZlYWl+jtjQMOeoT2/EsLSjRIbobb1yvLzomagXhyDkTOhh7aI9+QDjJ6YOAOhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868766; c=relaxed/simple;
	bh=R6uWB95ux91lhjBHB9b/QXFDP2ybRERRLwPq50Cwv38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQGJgkjxAI/irXCn73GGnvwvYU3v7kaz5kb0NVf9GUjYAjqHqTn76UE3zBSRNCbmxVKJzLGbF36G955vO71+Ni89gZqHaqplczJEWTIYKQ11U6cfkEEzYAFavWQawoHpG/8sfI5wtiRS0VV3wCFFUJWGL55vKug1c+Y25F35az8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJQJDUem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJQJDUem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113D4C4CEF5;
	Wed, 30 Jul 2025 09:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868766;
	bh=R6uWB95ux91lhjBHB9b/QXFDP2ybRERRLwPq50Cwv38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJQJDUemIh6I8vHhixXfOpe9iB06zz00BNsHuitiv23kB2D5+OP6DhH7bcmghG6F2
	 6ZauFGqGjdYQKYQqYxGa+VaRlvgm7H0Dew16YAxfdoCpmUzkSZet1n1vY9IGsgn9TN
	 zP7QzKhl2u9NrJar16pXsOSBrAzU9EemyH9NKgRw=
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
Subject: [PATCH 6.12 037/117] net: hns3: fixed vf get max channels bug
Date: Wed, 30 Jul 2025 11:35:06 +0200
Message-ID: <20250730093235.015224434@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f5a85b97ac0c..e8573358309ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3096,11 +3096,7 @@ static void hclgevf_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 
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




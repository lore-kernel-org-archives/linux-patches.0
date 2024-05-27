Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71563168C4;
	Mon, 27 May 2024 19:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837357; cv=none; b=SUUHJgeIW00y26eizxUAXwf4RNMT3xtZ2xEW71Ljcl/AcDbs9yhm2aHXoAH6BiOohEyHxTTFm+lEAzg11rlmyTCahWzQCO1KckB8tYlB7R93p75wiTbVIC1n4rrTmsFcvL0RzE4vicWBKF3XCRAwfUZmORnKiXyS9Iaqy6qV17I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837357; c=relaxed/simple;
	bh=K5iXjIZNYeAJvBJ6Eontl67GmAI0eepfP5EcaFbn84Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED4edrfJRhqu9thiHdnRUUGDCZrzXHqe6C3Fg3ddU7ziJYkAvWY6DzfqqZ32LFdia2TuIhIoMdMTvAfAwqNEOAh7QK7QBPVqA2NHf0dXa83hcQZM96dgRozHv7AnCoakYICtqr5GbWhZTP1+WciePYrKBmgTotkAdlEthKtN7yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVqmqNqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVqmqNqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DCAC2BBFC;
	Mon, 27 May 2024 19:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837357;
	bh=K5iXjIZNYeAJvBJ6Eontl67GmAI0eepfP5EcaFbn84Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yVqmqNqVhKun4OzNKb5t4SFP5YYIXqZeOHL4p+VLKLsh0jMRRsmfNe7IUusAFJKRj
	 wvBEwh3pniCGoX4AdZEE49AV5V+DYoVpe0Q97tYI2rsLz+3hE/J52NOoZajIVBWUdx
	 M3X1QCOThg96tuaycgU+O4a5dZ7KmDumhVq2ACGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 360/427] RDMA/hns: Use complete parentheses in macros
Date: Mon, 27 May 2024 20:56:47 +0200
Message-ID: <20240527185633.854510497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 4125269bb9b22e1d8cdf4412c81be8074dbc61ca ]

Use complete parentheses to ensure that macro expansion does
not produce unexpected results.

Fixes: a25d13cbe816 ("RDMA/hns: Add the interfaces to support multi hop addressing for the contexts in hip08")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-10-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index 6fb51db9682b8..9c415b2541af8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -57,16 +57,16 @@ enum {
 };
 
 #define check_whether_bt_num_3(type, hop_num) \
-	(type < HEM_TYPE_MTT && hop_num == 2)
+	((type) < HEM_TYPE_MTT && (hop_num) == 2)
 
 #define check_whether_bt_num_2(type, hop_num) \
-	((type < HEM_TYPE_MTT && hop_num == 1) || \
-	(type >= HEM_TYPE_MTT && hop_num == 2))
+	(((type) < HEM_TYPE_MTT && (hop_num) == 1) || \
+	((type) >= HEM_TYPE_MTT && (hop_num) == 2))
 
 #define check_whether_bt_num_1(type, hop_num) \
-	((type < HEM_TYPE_MTT && hop_num == HNS_ROCE_HOP_NUM_0) || \
-	(type >= HEM_TYPE_MTT && hop_num == 1) || \
-	(type >= HEM_TYPE_MTT && hop_num == HNS_ROCE_HOP_NUM_0))
+	(((type) < HEM_TYPE_MTT && (hop_num) == HNS_ROCE_HOP_NUM_0) || \
+	((type) >= HEM_TYPE_MTT && (hop_num) == 1) || \
+	((type) >= HEM_TYPE_MTT && (hop_num) == HNS_ROCE_HOP_NUM_0))
 
 struct hns_roce_hem {
 	void *buf;
-- 
2.43.0




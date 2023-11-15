Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2573A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJqF6rQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11D2C433C7;
	Wed, 15 Nov 2023 19:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077568;
	bh=M21wLzRcbNe1h7pUedMUwTS19eNLNCACGonb6L1xJxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJqF6rQRu0sf9clSUgrxp9WozTwyDKAYboeom6iQSf+IlR014XJ9I551OB8TsCMlb
	 VNRYmoirIBkrfC4aCnhFyWbOmnUpjNtp5OYHWbz+lyen/XsfPzu2+iFyMdwjMUUukA
	 j+PW0tBLfdN2NB2/sfbJn/PWqtElaVNiUhpNFiXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 382/603] RDMA/hns: Fix unnecessary port_num transition in HW stats allocation
Date: Wed, 15 Nov 2023 14:15:27 -0500
Message-ID: <20231115191639.756749800@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

[ Upstream commit b4a797b894dc91a541ea230db6fa00cc74683bfd ]

The num_ports capability of devices should be compared with the
number of port(i.e. the input param "port_num") but not the port
index(i.e. port_num - 1).

Fixes: 5a87279591a1 ("RDMA/hns: Support hns HW stats")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231017125239.164455-7-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index d9d546cdef525..e1a88f2d51b6c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -547,9 +547,8 @@ static struct rdma_hw_stats *hns_roce_alloc_hw_port_stats(
 				struct ib_device *device, u32 port_num)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(device);
-	u32 port = port_num - 1;
 
-	if (port > hr_dev->caps.num_ports) {
+	if (port_num > hr_dev->caps.num_ports) {
 		ibdev_err(device, "invalid port num.\n");
 		return NULL;
 	}
-- 
2.42.0




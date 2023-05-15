Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B5AFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6186FC433D2;
	Mon, 15 May 2023 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171659;
	bh=JG4TQLvfe7NFX2BvTSorX9EVhbMmVXU0hjwRqQ7jCSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FK+rqtf1Bm2g1VbHe+tBvD8x5vkQsGGWk3GRowUKoxfd8JAj2C5K1GD7kRUtkAG/j
	 Hm500RgywLhrc0Db/yMHk/b+Bd2jCq/TqsSAXQhGhYhGSqsPzRGEH0TbmGvgqZfyNc
	 J4QuGr9s87ld2MR+KqTPzFUZcsmYfXrXzxPOta0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/134] octeontx2-vf: Detach LF resources on probe cleanup
Date: Mon, 15 May 2023 18:28:34 +0200
Message-Id: <20230515161704.363054250@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 99ae1260fdb5f15beab8a3adfb93a9041c87a2c1 ]

When a VF device probe fails due to error in MSIX vector allocation then
the resources NIX and NPA LFs were not detached. Fix this by detaching
the LFs when MSIX vector allocation fails.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 9822db362c88e..e69b0e2729cb2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -630,7 +630,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = otx2vf_realloc_msix_vectors(vf);
 	if (err)
-		goto err_mbox_destroy;
+		goto err_detach_rsrc;
 
 	err = otx2_set_real_num_queues(netdev, qcount, qcount);
 	if (err)
-- 
2.39.2




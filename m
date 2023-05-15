Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC82FBEC
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F46FC4339C;
	Mon, 15 May 2023 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173003;
	bh=ViVYu6hAlUJmSv0QDirXEDVuE5sWvWxD6CCabKZUl30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyS+KjSyYZ5eiFV9b8+M26/dh8MsFwoTtZRMt6fzNbOozAZYyE/yeqphmD02LvqHm
	 9QSCNiIZn6C85X2CexiYtNoGnJHwk4INidmiK3PW5FhfUJzc8lBVCVWLwfAE6NZ1E+
	 5I9gfr+0D2kdOO118FtjHgfX2WyIxX+ui3tTYYrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/381] octeontx2-vf: Detach LF resources on probe cleanup
Date: Mon, 15 May 2023 18:29:30 +0200
Message-Id: <20230515161751.207411124@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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
index 67fabf265fe6f..5310b71795ecd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -542,7 +542,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = otx2vf_realloc_msix_vectors(vf);
 	if (err)
-		goto err_mbox_destroy;
+		goto err_detach_rsrc;
 
 	err = otx2_set_real_num_queues(netdev, qcount, qcount);
 	if (err)
-- 
2.39.2




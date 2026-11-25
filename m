Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622667;
	b=kqHp0zKvCvWMJWO5Chvsp1ePYNEUabDqmj9yHLhPOJeh8Tz9pF5byJ1zfXWb7j3p2p47
	 4SOoHCMHUHsH38ucMlYoqpW52/Ej/qmKgfWkEI3X6graI4cq0Aq1Xe2qQ0/TwPKdQ7owW
	 atjKZp6BBkY6PmCFJxnz2ppyAxUmFGHaDBXitmgyYpDdMhORGxlB6+lPPl20J2SBxYTeE
	 ZaSvVeYztQwmaruxDGp8e0sXDQXUb/+TQVkNXPhD72DdKMOlU5yuFpkmzzuENZvtnlBvl
	 VhjbvnfVUORDtrQbw3+UBA6xu7Vf/N8G7VDijg6t5M4wNKJOhuBkEFu+BtKg8P4/7bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nwAHAzATcYAj5sIcZ4FrZcAgtmjV24yAb2+VBlM13U4=;
	b=KFo8zm4NEVL5HPu1y3lnVnPAHbmrdikQkXQi5w6sqCKnyhdMfnQMgK43jiJc+A/+ltri
	 M8YB9XpP4YSdvqckzvkZMQpZIiPaEkLqhFk0Qg1eiHk8Q5uJNn1cFUamkyk1Z+a9Ir8O3
	 6cJWmGkK3jaz3eqM14nrizXKLj3MeB6tkWFL1MgWFElsVWfg4pYvJIepCeWosBbKEFyGx
	 0MK1tPId5TWX/9pG1GRjrWhwu8uHq6Kt42j5ZVnKV6XHZcqe+J9uwOJwsYKpl7U5uht1d
	 VG/gXFqkWuBGzSw1Lf4axAAuI438j+CyoMcqeQNq4oGM6qd7aGDXm2a3KjEiORe1/WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=euvK0TaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DEE606A31E;
	Wed, 25 Nov 2026 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=euvK0TaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFC61F000C0;
	Wed, 25 Nov 2026 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622666;
	bh=nwAHAzATcYAj5sIcZ4FrZcAgtmjV24yAb2+VBlM13U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euvK0TaMvkG+PUQan3ct1oxMg3q8FaQlaB33TttJ01L9MP2Z4z+wldf0AMu2LQEr4
	 P6qvYdfaprbTDX/KkFPJ7xHj45lVEizu3ET34vp8B19AVEypzEY3hn3Wymcd5GKWcZ
	 /WIZc25jvFT7L3kh8RPhdEYVJ3noNFAgNp2hwKrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 593/990] RDMA/bnxt_re: Use kvzalloc for QP table allocation
Date: Wed, 25 Nov 2026 15:32:40 +0100
Message-ID: <20261125143835.982775527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>

[ Upstream commit 724a39b36af94787d32094da87729f24a28888b7 ]

The QP table size depends on the firmware reported max_qp, so it can
be large and a physically contiguous kzalloc may fail. Use kvzalloc_objs()
and free it with kvfree().

Fixes: 82f1f575aa13 ("RDMA/bnxt_re: Fix allocation of QP table")
Signed-off-by: Abhishek Mohapatra <abhishek.mohapatra@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20261013140427.256612-2-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
[ sashal: Replaced kzalloc_objs() with kvcalloc() for the QP table allocation, since the older kcalloc() form is what this branch had and kvzalloc_objs() doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index d92db77e7ed50..ad0ba952eb48d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -867,7 +867,7 @@ int bnxt_qplib_init_res(struct bnxt_qplib_res *res)
 
 void bnxt_qplib_free_res(struct bnxt_qplib_res *res)
 {
-	kfree(res->rcfw->qp_tbl);
+	kvfree(res->rcfw->qp_tbl);
 	bnxt_qplib_free_sgid_tbl(res, &res->sgid_tbl);
 	bnxt_qplib_free_pd_tbl(&res->pd_tbl);
 	bnxt_qplib_free_dpi_tbl(res, &res->dpi_tbl);
@@ -884,8 +884,8 @@ int bnxt_qplib_alloc_res(struct bnxt_qplib_res *res, struct net_device *netdev)
 
 	/* Allocate one extra to hold the QP1 entries */
 	rcfw->qp_tbl_size = max_t(u32, BNXT_RE_MAX_QPC_COUNT + 1, dev_attr->max_qp);
-	rcfw->qp_tbl = kcalloc(rcfw->qp_tbl_size, sizeof(struct bnxt_qplib_qp_node),
-			       GFP_KERNEL);
+	rcfw->qp_tbl = kvcalloc(rcfw->qp_tbl_size, sizeof(struct bnxt_qplib_qp_node),
+				GFP_KERNEL);
 	if (!rcfw->qp_tbl)
 		return -ENOMEM;
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11C18F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416B7C433C8;
	Sun, 16 Jul 2023 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540101;
	bh=cvSSfh4wwDHLiwUSoKZB0SHWM8ynB9l7FxRkPJC5pLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FG9X1aWr5ihDT0uQPk03dDLraKut9A9aMRMMHPF7URflHUhhYzP31/xqqi/NFfA/t
	 aQ4/Hvrv58H6yEz4fJPGVVADxoDr65JYTK7Wcg4RND5QvQrKcnTvD7W35xn11cOTBn
	 eINh+ZPJ8ACiCa2L9zABwz5LnIWmVIq+X6Qb5lFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/591] RDMA/rxe: Add ibdev_dbg macros for rxe
Date: Sun, 16 Jul 2023 21:46:22 +0200
Message-ID: <20230716194930.156731531@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 4554bac48a8c464ff00136a64efe8847e4da4ea8 ]

Add macros borrowed from siw to call dynamic debug macro ibdev_dbg.

Link: https://lore.kernel.org/r/20221103171013.20659-2-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 425e1c9018fd ("RDMA/rxe: Fix access checks in rxe_check_bind_mw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe.h b/drivers/infiniband/sw/rxe/rxe.h
index 30fbdf3bc76a3..ab334900fcc3d 100644
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -38,6 +38,25 @@
 
 #define RXE_ROCE_V2_SPORT		(0xc000)
 
+#define rxe_dbg(rxe, fmt, ...) ibdev_dbg(&(rxe)->ib_dev,		\
+		"%s: " fmt, __func__, ##__VA_ARGS__)
+#define rxe_dbg_uc(uc, fmt, ...) ibdev_dbg((uc)->ibuc.device,		\
+		"uc#%d %s: " fmt, (uc)->elem.index, __func__, ##__VA_ARGS__)
+#define rxe_dbg_pd(pd, fmt, ...) ibdev_dbg((pd)->ibpd.device,		\
+		"pd#%d %s: " fmt, (pd)->elem.index, __func__, ##__VA_ARGS__)
+#define rxe_dbg_ah(ah, fmt, ...) ibdev_dbg((ah)->ibah.device,		\
+		"ah#%d %s: " fmt, (ah)->elem.index, __func__, ##__VA_ARGS__)
+#define rxe_dbg_srq(srq, fmt, ...) ibdev_dbg((srq)->ibsrq.device,	\
+		"srq#%d %s: " fmt, (srq)->elem.index, __func__, ##__VA_ARGS__)
+#define rxe_dbg_qp(qp, fmt, ...) ibdev_dbg((qp)->ibqp.device,		\
+		"qp#%d %s: " fmt, (qp)->elem.index, __func__, ##__VA_ARGS__)
+#define rxe_dbg_cq(cq, fmt, ...) ibdev_dbg((cq)->ibcq.device,		\
+		"cq#%d %s: " fmt, (cq)->elem.index, __func__, ##__VA_ARGS__)
+#define rxe_dbg_mr(mr, fmt, ...) ibdev_dbg((mr)->ibmr.device,		\
+		"mr#%d %s:  " fmt, (mr)->elem.index, __func__, ##__VA_ARGS__)
+#define rxe_dbg_mw(mw, fmt, ...) ibdev_dbg((mw)->ibmw.device,		\
+		"mw#%d %s:  " fmt, (mw)->elem.index, __func__, ##__VA_ARGS__)
+
 void rxe_set_mtu(struct rxe_dev *rxe, unsigned int dev_mtu);
 
 int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name);
-- 
2.39.2




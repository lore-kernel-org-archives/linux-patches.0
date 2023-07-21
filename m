Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6429C20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BC9C433D9;
	Fri, 21 Jul 2023 19:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967061;
	bh=FikZU/UiE6Epn8Bq35ecz+4S6NsnxwlAwh6akol+NNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=majwEGLEU9KuWyDZ6c6985eWpLNPjpycUqverv9jiweCrccSC0APOSpsoDOyRjcdI
	 sOocVIGoGZao3tbhD4RqzCDhxTomBzcqIludy5EEnGqWWhRBJb9cu3E4D3V06a66yo
	 61UPwQ0wfDjVgUg/52R9wFYCJdSVFZZqhGdWunok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitya Sunkad <nitya.sunkad@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/223] ionic: remove WARN_ON to prevent panic_on_warn
Date: Fri, 21 Jul 2023 18:04:44 +0200
Message-ID: <20230721160522.195454190@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nitya Sunkad <nitya.sunkad@amd.com>

[ Upstream commit abfb2a58a5377ebab717d4362d6180f901b6e5c1 ]

Remove unnecessary early code development check and the WARN_ON
that it uses.  The irq alloc and free paths have long been
cleaned up and this check shouldn't have stuck around so long.

Fixes: 77ceb68e29cc ("ionic: Add notifyq support")
Signed-off-by: Nitya Sunkad <nitya.sunkad@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 159bfcc76498c..a89ab455af67d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -462,11 +462,6 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
 static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
 				      struct ionic_qcq *n_qcq)
 {
-	if (WARN_ON(n_qcq->flags & IONIC_QCQ_F_INTR)) {
-		ionic_intr_free(n_qcq->cq.lif->ionic, n_qcq->intr.index);
-		n_qcq->flags &= ~IONIC_QCQ_F_INTR;
-	}
-
 	n_qcq->intr.vector = src_qcq->intr.vector;
 	n_qcq->intr.index = src_qcq->intr.index;
 	n_qcq->napi_qcq = src_qcq->napi_qcq;
-- 
2.39.2




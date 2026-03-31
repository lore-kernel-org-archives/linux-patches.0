Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC79402BA9;
	Tue, 31 Mar 2026 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974665; cv=none; b=UYRNdolM1Y1v4f7tBoKxNjNevjQvf0CefWdb2GwmV5Mg8Y16j4nEhwfbq1M/4ZYjRBO99P0P8+18tNadYylLGX175V7K/+ZiHlhslNayswCArs+89OTNtwR7Fxsfobf7YNfrK5C1JNjH3lAgYj3WNY+vkbqxQ+74T6PQuOP3C8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974665; c=relaxed/simple;
	bh=BnG0EuO75DNDCimoY2cd/+a98ynpFP/QcUmi8W9ssyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u59JLboExWj6dUmzJCmC7YSSefNU8SM1wQR7VqHaMd4qqVzmMU6E+wLKLQKzq7wM4gzThTgPAMEP1sOH/aHjoy11aXfhE9s0E2vRVdcgpQIl+Ioe2ifWahF7qXZwON/gvTAC3BqHaSQ/z3rBErD56OR79vJvyQ6ty9JIqDydKmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/Eb/Cyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/Eb/Cyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A51C19424;
	Tue, 31 Mar 2026 16:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974664;
	bh=BnG0EuO75DNDCimoY2cd/+a98ynpFP/QcUmi8W9ssyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/Eb/CykrQnG1A5pc4uLNlz2vEwnByXuhJHyBDJzSELERHhC5DynmZYuVc1dBrd3L
	 bbPMZDSAnA0WnwwqVppqS5utx3FT2scmACOZpKjnHRk7k/gEdqp9P2O+o1fjIrU2ON
	 1QegqwoEKQrz7jeFqUFNelenJruUgMWuQKTMkjK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Lijun Pan <lijun.pan@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/175] dmaengine: idxd: Remove usage of the deprecated ida_simple_xx() API
Date: Tue, 31 Mar 2026 18:22:36 +0200
Message-ID: <20260331161736.113238565@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1075ee66a8c19bfa375b19c236fd6a22a867f138 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range() is inclusive. Sothis change allows one more device.

MINORMASK is ((1U << MINORBITS) - 1), so allowing MINORMASK as a maximum value
makes sense. It is also consistent with other "ida_.*MINORMASK" and
"ida_*MINOR()" usages.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Lijun Pan <lijun.pan@intel.com>
Link: https://lore.kernel.org/r/ac991f5f42112fa782a881d391d447529cbc4a23.1702967302.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c311f5e92484 ("dmaengine: idxd: Fix freeing the allocated ida too late")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index aa39fcd389a94..20d380524f4ee 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -165,7 +165,7 @@ static void idxd_cdev_dev_release(struct device *dev)
 	struct idxd_wq *wq = idxd_cdev->wq;
 
 	cdev_ctx = &ictx[wq->idxd->data->type];
-	ida_simple_remove(&cdev_ctx->minor_ida, idxd_cdev->minor);
+	ida_free(&cdev_ctx->minor_ida, idxd_cdev->minor);
 	kfree(idxd_cdev);
 }
 
@@ -550,7 +550,7 @@ int idxd_wq_add_cdev(struct idxd_wq *wq)
 	cdev = &idxd_cdev->cdev;
 	dev = cdev_dev(idxd_cdev);
 	cdev_ctx = &ictx[wq->idxd->data->type];
-	minor = ida_simple_get(&cdev_ctx->minor_ida, 0, MINORMASK, GFP_KERNEL);
+	minor = ida_alloc_max(&cdev_ctx->minor_ida, MINORMASK, GFP_KERNEL);
 	if (minor < 0) {
 		kfree(idxd_cdev);
 		return minor;
-- 
2.53.0




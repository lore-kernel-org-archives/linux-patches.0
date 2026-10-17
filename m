Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602A3388371;
	Sat, 17 Oct 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254681; cv=none; b=ZDxrVkcgpvQm0PDeSZWHunW8xgV7eeEa2V0UpQMKPtYiF+d7btyNGb22m7fFBx/a48iaYvo3DPIDRZkSpE14Lsju/0TrZbjSuskxIwjLvl7ntOWIYydLhHLXdZ2944qySJAYqb91rEBiyr6Xw/SaomUHNlvlt83O4m4kfVgW7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254681; c=relaxed/simple;
	bh=/WXXVBgyR8/lQTyd5TR/xKr5N31o7JMTQ2YwLmvHr8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnDO8A9A6gIQXNC4NNqm+UFdwNVNeo2pyrBtvOHn+CXrHhYxpHPGWkid+RxL2KwVkhUUdjPI4eweUOL/5dP6W8LDAGOhDEtfF7/g0tOHcQxaQCTxekzOrTK8LInBAeLhcZARHGkk+1yB/3xo3OmGJ+RZe3cp/GI+Pgh5N9V8Nks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4JnwBMV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4JnwBMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F111F000C4;
	Sat, 17 Oct 2026 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254679;
	bh=Gr8m6t4Vw5Z7bV/yshGAomIDrQrBj5YbikvGfU0Z87Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4JnwBMV9NywpOR5Ry2ELnmsfSU8iiUuzFdx3/gNTemyPDSgd5IUMd24IxtgsEl/o
	 ggNeU3/BCs2vNKISGBilgN05RScvBdNlIiPzZa/TQ7IXGJpJuvs2WqwI86X7IIC+n3
	 5FrAzXgBgICQutGMg1SzWCJ3ofOCB2WZ5aL2wvuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 527/869] net: ibm: emac: use devm_platform_ioremap_resource
Date: Sat, 17 Oct 2026 17:56:08 +0200
Message-ID: <20261017160050.623680311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit c9bf90863df5fc8bae9513ce9bfcc260fad2ea0e ]

No need to have a struct resource. Gets rid of the TODO.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: f623d38fe6c4 ("net: emac: Fix NULL pointer dereference in emac_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index a7aef2fb668d2..99be3cc32e915 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3049,12 +3049,10 @@ static int emac_probe(struct platform_device *ofdev)
 
 	ndev->irq = dev->emac_irq;
 
-	/* Map EMAC regs */
-	// TODO : platform_get_resource() and devm_ioremap_resource()
-	dev->emacp = devm_of_iomap(&ofdev->dev, np, 0, NULL);
-	if (!dev->emacp) {
+	dev->emacp = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(dev->emacp)) {
 		dev_err(&ofdev->dev, "can't map device registers");
-		err = -ENOMEM;
+		err = PTR_ERR(dev->emacp);
 		goto err_gone;
 	}
 
-- 
2.53.0




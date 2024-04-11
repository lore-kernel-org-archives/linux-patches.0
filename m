Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD75146D4E;
	Thu, 11 Apr 2024 10:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831278; cv=none; b=oFzFQgcBEDOAhAOqpO8412/OOtEIDeRuJfXkEfbBPbnp7mLCYO1KcDq/gBSQAh7O0Z6iH29cBVxV3VABjjLvjQ4GAodnMRiHc8GcgfggX2jYyLpsdxfUAPJ4oN3aNMIcnCpy21Ss048P0S4xR6g9zjtqSw371uVluKMClWYP37Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831278; c=relaxed/simple;
	bh=SRtx+joo3s2hd20EnTjEFjoPMjDuabv5XZK6NSK5DTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qt0QEOYPIGs8zfBLlHweXIPhMGENSGRKdpAEXgxOrNEpZeKn82+5tzAVBbnlfhs0nxkmK0l+K00bEd+yYPT0xGUdWuOxAzpet1yR0WPs7utBh1/dgrpejlPh7Pbe89h8N5/XQo66DmeZ5j50AOkoKshz3h2mzBR495lJ4YEGAXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHPACoaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHPACoaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B781FC433C7;
	Thu, 11 Apr 2024 10:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831278;
	bh=SRtx+joo3s2hd20EnTjEFjoPMjDuabv5XZK6NSK5DTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHPACoaUslDCk86UKqEfryJAUnJtMZrnjC5RmFxfxHA4bOfANQ/NTUuwLuukxlt8o
	 3pD9HqEwYvs+eudHqqiallp/HI4yFQDcN8L8LvwwblaMaaqVZMaQheEK6hV33pkjg1
	 LlAa4fLkccdmctp82ud8FDJcMq+6/zWCKJzg3Omc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/114] pmdomain: ti: Add a null pointer check to the omap_prm_domain_init
Date: Thu, 11 Apr 2024 11:55:46 +0200
Message-ID: <20240411095417.448265100@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 5d7f58ee08434a33340f75ac7ac5071eea9673b3 ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240118054257.200814-1-chentao@kylinos.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/ti/omap_prm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pmdomain/ti/omap_prm.c b/drivers/pmdomain/ti/omap_prm.c
index c2feae3a634ca..b8ceb3c2b81c2 100644
--- a/drivers/pmdomain/ti/omap_prm.c
+++ b/drivers/pmdomain/ti/omap_prm.c
@@ -695,6 +695,8 @@ static int omap_prm_domain_init(struct device *dev, struct omap_prm *prm)
 	data = prm->data;
 	name = devm_kasprintf(dev, GFP_KERNEL, "prm_%s",
 			      data->name);
+	if (!name)
+		return -ENOMEM;
 
 	prmd->dev = dev;
 	prmd->prm = prm;
-- 
2.43.0




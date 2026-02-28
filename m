Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAF4375AAA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301624; cv=none; b=caqA4ayKJcwEHoAXMVRvaIXT68nOcfZIHGYJzlfsdO0KnNYmguEIm1W1sOe1zRvWWuz7mySDL9LHUomspHwZB3JgwChq9Y1Wnq3Z4tCpel+/FeuNZoDhgZOYsft/l4W8R+Rt1P8YB3TBJVSxbe1qHWMY0Jo8l/+yNGKx56VO7J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301624; c=relaxed/simple;
	bh=WcVlHRUR8az+eBbLA96mECHgsR0JaLyeT8mPr/V1GQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dome+4sxTCt22RT3iWqfc8bcSxwcpfQ4+EvdT93UQs5auwNHQz4zsRaivkL9b6L1bLWEPFjy1tte9CUr5sj10NPKaI+rWFw5As9utqQST3/NUafVI9jPM+IqaGTLfO4jEw05aZ30vx6M3Nx2446oHAbSK9MKwo/vJi77i0fU3hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBp4ZNYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBp4ZNYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98EEC19424;
	Sat, 28 Feb 2026 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301624;
	bh=WcVlHRUR8az+eBbLA96mECHgsR0JaLyeT8mPr/V1GQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBp4ZNYJVzvTnXiSDXV33yfa8467Uhg4ycdEu9XB09SLa4tchEKMCPRfFc2KNuIak
	 /V1qb6j60aHytCbLZYviBDx/D2ak3QfEAlEapsEicJO2SaWAJQs+wTO1BnlyiFqYHd
	 YaC9zILg6I3/aKf8KGKB0LvM8pOEgIbZh3zAe2ISBfnE6jEqDU9M0HldRh64rKxTaf
	 v/esmxaJjZ1U1Ot6aj5HSRDK/CpZqOsVm64TmWsZGeDiEbaXxD3enKfYk/cJ77jDRD
	 9iziiac0Iw+pMXD2tcS60qT1okPKT1wbySzdYTiudID//TJ1cnuAWx1aqQgzquMwHR
	 RnYiUGx+h37fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fredrik Markstrom <fredrik.markstrom@est.tech>,
	Jani Nurminen <jani.nurminen@windriver.com>,
	Ivar Holmqvist <ivar.holmqvist@est.tech>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/385] i3c: dw: Initialize spinlock to avoid upsetting lockdep
Date: Sat, 28 Feb 2026 12:53:57 -0500
Message-ID: <20260228180011.1568201-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fredrik Markstrom <fredrik.markstrom@est.tech>

[ Upstream commit b58eaa4761ab02fc38c39d674a6bcdd55e00f388 ]

The devs_lock spinlock introduced when adding support for ibi:s was
never initialized.

Fixes: e389b1d72a624 ("i3c: dw: Add support for in-band interrupts")
Suggested-by: Jani Nurminen <jani.nurminen@windriver.com>
Signed-off-by: Fredrik Markstrom <fredrik.markstrom@est.tech>
Reviewed-by: Ivar Holmqvist <ivar.holmqvist@est.tech>
Link: https://patch.msgid.link/20260116-i3c_dw_initialize_spinlock-v3-1-cf707b6ed75f@est.tech
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index dbcd3984f2578..eca54cbc1c29a 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1575,6 +1575,8 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	spin_lock_init(&master->xferqueue.lock);
 	INIT_LIST_HEAD(&master->xferqueue.list);
 
+	spin_lock_init(&master->devs_lock);
+
 	writel(INTR_ALL, master->regs + INTR_STATUS);
 	irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(&pdev->dev, irq,
-- 
2.51.0


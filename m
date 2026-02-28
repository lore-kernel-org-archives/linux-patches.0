Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816433446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302044; cv=none; b=X9oCBJWItiu2o8F2k1hZXScTwseTM6Mjw2D+fPEirhNulfoSAIE62NHBx6Haf0EpKyzadLr2yEv3r9rs11Q+HWL/DImYisDw+Be13b2MFJkmKOTNBskbwoa52TrXM+YeIQ54W809rUj1LYw+edqB4WHoo6RBWLyY9NL0g1+KL6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302044; c=relaxed/simple;
	bh=F/zY5Q6IkuiNlN3zIeKnQBAq3iR2FM4a3Gz8ow/6szc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLCO1XyrY3QBxpev5APl8F0JwX2SluQpGObzPppSRS5PPmyIR4iVPkUwAEBvBDR1BXJ9AV0KfLoEuuJ9B1ShqKfHei318jVkPYBZUJ8G+twOz/KuvsyHAHHVwsBJKuYJJwl8oCtaIoPvEUAP1lGJxNToAXhq9gz3y2ll3Ddx0XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cmrm73Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cmrm73Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DEAC19424;
	Sat, 28 Feb 2026 18:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302044;
	bh=F/zY5Q6IkuiNlN3zIeKnQBAq3iR2FM4a3Gz8ow/6szc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cmrm73UrefIxXi4govv+E9WuOpgtrZlDw7pjnR/eIELFec2k55b5hQzT5qQiL1mdg
	 ZJTrLsSzOjcs6SJL8AOaLO0e8tcCEkgJDRo4avv/mMhrwPf86Fyzfx7XnFttsyp2c9
	 poRvMIXeBj+bXVOgOxDSj2gL3V496PhSFurb0X1xz0iWRh0iI6hXFFkj0YjMv04/J9
	 rM3dtYDrHdEjVvGr1xGSRJgabQEZHIKGus3JsPNnZ8owq40D4HUUh8+ZC5zbMBxpLi
	 yy1kWKZ6pkL6N1ZTabd+/1uJYMd87KfAa6f97NlF37EufYLRqUb1hTE5fMpx62W8BO
	 8aNZKSn8mBdRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fredrik Markstrom <fredrik.markstrom@est.tech>,
	Jani Nurminen <jani.nurminen@windriver.com>,
	Ivar Holmqvist <ivar.holmqvist@est.tech>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/283] i3c: dw: Initialize spinlock to avoid upsetting lockdep
Date: Sat, 28 Feb 2026 13:02:39 -0500
Message-ID: <20260228180709.1583486-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 030127525672e..cee2805fccd0f 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1483,6 +1483,8 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	spin_lock_init(&master->xferqueue.lock);
 	INIT_LIST_HEAD(&master->xferqueue.list);
 
+	spin_lock_init(&master->devs_lock);
+
 	writel(INTR_ALL, master->regs + INTR_STATUS);
 	irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(&pdev->dev, irq,
-- 
2.51.0


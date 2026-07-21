Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF3C3DDB03;
	Tue, 21 Jul 2026 22:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674018; cv=none; b=YW1sbYXHLjsJANjunregroWxd7DxSeZzaDV+UYJLhGBE7gxDoviQ+VcN15h1rMchsfJRuF17lDD37JFWnFwxGAooPXYeC6jahfuVuhWLAiLxWXTrDrdVt8zPCVW8FcQsIW81JWb+Erp/iRofH8IFRhtniitNBYvk8TgjdwA/He0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674018; c=relaxed/simple;
	bh=bNmv3tx4DfuUJsHd8oolVfFTkEYjUfXZfLRPeNXeDqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZu+F8tRmRt5Ths72sBz54/qfsUnlDNEGXdczn2+LlwiIgbTGe914XfwdjQQi4GzZ5q3pzt39eu0/TdbnsR+9V3hxN2NUfXXxMNa1D1PZ7/zbundKIQrOQdhXaxEyCkzKJFyMNaPsZiVm1W3m1JaPYs0gHQFa71U/jUiSsvAnEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j01xeZQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j01xeZQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918C01F000E9;
	Tue, 21 Jul 2026 22:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674017;
	bh=UsSFYbjc6D3s5ieKOSUOwVI923HhaA5eIb+vgbPrPhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j01xeZQzqg6gt0ZHhBAZhsA2iKNNsylhVBmjz61JTqCox2LYY5Ryvx1VraB22gaVY
	 m/PbidPsBRlnG5SVlGsymWCOaJZqALqV38yhpciDr+ultcFu4Nq83OF4jLUK+9WCsf
	 BQ0elu2sMHZKMvIVrqecz0V/ghzvliCwjeKc5Gfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/699] gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe
Date: Tue, 21 Jul 2026 17:22:21 +0200
Message-ID: <20260721152404.309910907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit 8d7e62d5e9b2d2ff146f472a9215d7e29c7e2307 ]

Out of memory situation on driver's probe is expected to be reported to
the driver's framework with a proper -ENOMEM error code.

Fixes: 35570ac6039e ("gpio: add GPIO driver for the Timberdale FPGA")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Link: https://patch.msgid.link/20260630145148.4081967-1-vz@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-timberdale.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
index 92c1f2baa4bff2..3a9cb305c13777 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -228,7 +228,7 @@ static int timbgpio_probe(struct platform_device *pdev)
 
 	tgpio = devm_kzalloc(dev, sizeof(*tgpio), GFP_KERNEL);
 	if (!tgpio)
-		return -EINVAL;
+		return -ENOMEM;
 
 	tgpio->irq_base = pdata->irq_base;
 
-- 
2.53.0




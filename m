Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579FC1F4283;
	Tue,  3 Dec 2024 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240408; cv=none; b=BdYpFPKfI90D2KAT0hdQ4iiRcd5NFx3IJbeLGeggrq8QnlStbYEtM+wxARjVkdVi7+fE3X0E6/QmGum+g318fYwXAhtDSILCfWAQbjm3JabUhiQoQoaC+BvOjGVfoIpX7w2d+7eAkBM+AS5j431jTflk0XjlwUWizJC5jkue738=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240408; c=relaxed/simple;
	bh=RAFywRKsEoIap7+zxIq9DrGAeX0iwGvVHSpGGLEBe9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNMySZXLtB+QLcKzPJ8E7oWhA3g46gD47wKXv+d6Kc8G6wrMgIBPVuT+oRD3AAmWQQlq9SSQEQz8pnTpsZbtqm8CkzyJQ9znTxLMU0FVfNNy5pN/nf3IMcok8YwnUf+mD2VrkLPsn5P4pGlTT5zwvB6ZfObjioT3Jas8LCCcST0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhNBIACM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhNBIACM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19F4C4CECF;
	Tue,  3 Dec 2024 15:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240408;
	bh=RAFywRKsEoIap7+zxIq9DrGAeX0iwGvVHSpGGLEBe9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhNBIACM++jiux28Lc6cB+jNHhXOX7CB5bKx0W1JtOG5abboIdSusRVcn/1AHaPGD
	 L07eOao3giCQvX4dNmXM4SGhGtijNsSihtwM4zrxUUcf1hWVsUb7LvSE0DMFL7p1HL
	 e+dm+FjXUq1LQoWY3afN59V2CQqMmu9aFuA1N63I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/826] media: i2c: ds90ub960: Fix missing return check on ub960_rxport_read call
Date: Tue,  3 Dec 2024 15:37:32 +0100
Message-ID: <20241203144748.618872304@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 24ad2d1f773a11f69eecec3ec37ea3d76f2e9e7d ]

The function ub960_rxport_read is being called and afterwards ret is
being checked for any failures, however ret is not being assigned to
the return of the function call. Fix this by assigning ret to the
return of the call which appears to be missing.

Fixes: afe267f2d368 ("media: i2c: add DS90UB960 driver")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ds90ub960.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ds90ub960.c b/drivers/media/i2c/ds90ub960.c
index ffe5f25f86476..58424d8f72af0 100644
--- a/drivers/media/i2c/ds90ub960.c
+++ b/drivers/media/i2c/ds90ub960.c
@@ -1286,7 +1286,7 @@ static int ub960_rxport_get_strobe_pos(struct ub960_data *priv,
 
 	clk_delay += v & UB960_IR_RX_ANA_STROBE_SET_CLK_DELAY_MASK;
 
-	ub960_rxport_read(priv, nport, UB960_RR_SFILTER_STS_1, &v);
+	ret = ub960_rxport_read(priv, nport, UB960_RR_SFILTER_STS_1, &v);
 	if (ret)
 		return ret;
 
-- 
2.43.0




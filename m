Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E01A471253;
	Tue, 21 Jul 2026 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657564; cv=none; b=f9Y9ku+eL8uGBM7ycUY0ficNg56TZPkQA0vY+R5PHgji7aEr9Uw4Jpm4N1rvKCAo0E+DRlOvk7etuk6UhhNZ3HC3W+PdlGA+i/qApdGKZ6746frdyXk4aZMo6ADzQKRrxeRxqufF1owlUbJdBjzc13enBX1t23o51e/k8kq32tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657564; c=relaxed/simple;
	bh=68gtpvKZa73xE1a+rVoTsHpj/8k0jLg0Cy0Mnfv30+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMGoISlxGr+B9AG5N1zVN0fHT20wgF7gYidS+dQ7Gvg+Zv5gO8NvtzFBRJtD03W7pZwHHaLKBRxN+7R4Jh1VSxO4vz3/G8rbwNs1VrdJAjbtr1RLh6aodroCoGEobchzwGJ4ufGGq/W6RP2dPD7fTn6gXhrF3p2WocL8gv6SKLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9KPFPoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9KPFPoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF6E1F00A3A;
	Tue, 21 Jul 2026 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657563;
	bh=TPpnNIG3YmzeECJ66rAc9v8VOQOtrvE8E8F1BRmRpQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9KPFPoKKgR2w/PgFye/jYGtzCGIj2DhCKXdHh1yFRTDEvBKn7Ku1LnDcduAhr/Rh
	 uKqwa7k0o+4l+jjvhJEofH6C5H3PKVq0Fo3wrZt0C2id5ey5e4q7jnIRUIH4aF3BA4
	 E2KCbOijOA8Rt6hYT0iuMIag7o5fW+hx7AknLqo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Nguyen <quang.nguyen.wx@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0812/1611] spi: rpc-if: Use correct device for hardware reinitialization on resume
Date: Tue, 21 Jul 2026 17:15:28 +0200
Message-ID: <20260721152533.654143726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quang Nguyen <quang.nguyen.wx@renesas.com>

[ Upstream commit 7b25dbafa2fce50b1a48c1d057adb35da3563f9b ]

rpcif_spi_resume() currently passes the SPI controller device to
rpcif_hw_init(), but the function should be called with the RPC
interface device.

Retrieve the rpcif private data from the SPI controller and pass
rpc->dev instead. Also propagate the return value of rpcif_hw_init() so
that a failure during resume is properly reported rather than silently
ignored.

Fixes: ad4728740bd6 ("spi: rpc-if: Add resume support for RZ/G3E")
Signed-off-by: Quang Nguyen <quang.nguyen.wx@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260618081932.172168-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index 6edc0c4db854db..c2f9c86c1d8d4f 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -206,8 +206,12 @@ static int rpcif_spi_suspend(struct device *dev)
 static int rpcif_spi_resume(struct device *dev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
+	struct rpcif *rpc = spi_controller_get_devdata(ctlr);
+	int ret;
 
-	rpcif_hw_init(dev, false);
+	ret = rpcif_hw_init(rpc->dev, false);
+	if (ret)
+		return ret;
 
 	return spi_controller_resume(ctlr);
 }
-- 
2.53.0




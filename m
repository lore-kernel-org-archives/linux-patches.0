Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F85A3FF88D;
	Tue, 21 Jul 2026 21:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669508; cv=none; b=pZU3yfDSlbNtAZWD0fKUTNuczBGhUrP5NtV2wzuwDOjHKgt6HVM2qAJK+bA9L1PLQWuioZp9TE/JW7vFzCxgSOZ5d4c0wCyTNk70htA8nF/BH0Z4KIYIVpYCqwo6B50bv49gtpYqf15lOyhSdX5pUt1LYfa3MABr43gRvtNuE2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669508; c=relaxed/simple;
	bh=y5W5C5/6J2MgU5o+BpXhzoj5DGq+C/s3uo8mIdi3jYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1gNdCnngTIzfRm1UqiVoW4PsPX5Zx1Kq1kbdTmFASK37OShRNFjMl10jvNU84W1Eul+Mjc4pBgZj1DHbpd9xO5UaCy0+RoAUmw+EnUJyH0Xzk+9VawSUVjBX+YMRCgCSp5PkM7cSD1+Q4df9MzfOlSGW8SmIfLHZgcxkG4rEYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6zrVriV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6zrVriV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57A11F000E9;
	Tue, 21 Jul 2026 21:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669507;
	bh=75x3eTx8qFuoQWduq+n+Ph/OfAgrMikhp6eSHwLMvKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6zrVriV2CbQw1C4qhrxr9r5gd37elJMBWwy+gZPIEqO+vIkwFXwYSl4kFhjXVcRl
	 reLWDV6DlioZ20bTSm1r0oZaPeNLvVPTeN3D54YQ1BDqdBXzoD0N92d0uhnsZoBpCg
	 S5jUw7iBfBIEn/+w+9RxgDHblzvpCqRwX7G968mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quang Nguyen <quang.nguyen.wx@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0581/1067] spi: rpc-if: Use correct device for hardware reinitialization on resume
Date: Tue, 21 Jul 2026 17:19:42 +0200
Message-ID: <20260721152437.602193872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b294ac56470a09..9dd4dfc8e74c68 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -194,8 +194,12 @@ static int __maybe_unused rpcif_spi_suspend(struct device *dev)
 static int __maybe_unused rpcif_spi_resume(struct device *dev)
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




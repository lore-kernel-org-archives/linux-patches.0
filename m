Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9770347BC9;
	Fri, 21 Nov 2025 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732467; cv=none; b=GN8X4VmsAOheukyjXwCsHMUPo9bnlicdZrojMrBb3ZHTvd7BcJGkJ8Ir/KPkP7YUL5ZTM4Zd6MnzwTfT/III24+7y61DbbHhr0bbq241eCe/lhyty6C3GyWGTGj3A4E6ulto5J9WjpM5G0lXqezkGLHwDkmYt8m0wZiq04uuI+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732467; c=relaxed/simple;
	bh=o4DiLuIigl1jRitcralaJyPfmH95Aox0dbOTPHkw8Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/ntqlGio/1BMvsUJpQrEz3VPF2Qk4W3CEmVRdzJrY0o1K0uR2oM+NlEt9a3psgJ+8WB6FogYOhrHnUSRgCiDJv/COdX784oWn9nG3DcBmSpNjcLNGiQezDsMZ0EhffcljjcFORmEfV2O4ROkx/XRlE60Odd0vuaB0OGkltW+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTILZdo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTILZdo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD126C4CEF1;
	Fri, 21 Nov 2025 13:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732467;
	bh=o4DiLuIigl1jRitcralaJyPfmH95Aox0dbOTPHkw8Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTILZdo2+/xBB1gi9txJzGhWcLROgwrXnUKWRwLg0OjbuDmK51Tq33KP4d/c592Wp
	 pnKFng6FTUcWjVnRF+YG5Tlq1QqfKzXNBbo3AczP58Q9TA9+6euKoxj943asyzzEOg
	 /qgWr/fACZbbZsIiBgBU8+ZL0AutprnybAvTOfio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/529] spi: rpc-if: Add resume support for RZ/G3E
Date: Fri, 21 Nov 2025 14:06:37 +0100
Message-ID: <20251121130234.513023085@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit ad4728740bd68d74365a43acc25a65339a9b2173 ]

On RZ/G3E using PSCI, s2ram powers down the SoC. After resume,
reinitialize the hardware for SPI operations.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20250921112649.104516-3-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index 7cce2d2ab9ca6..a1696672d12fe 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -193,6 +193,8 @@ static int __maybe_unused rpcif_spi_resume(struct device *dev)
 {
 	struct spi_controller *ctlr = dev_get_drvdata(dev);
 
+	rpcif_hw_init(dev, false);
+
 	return spi_controller_resume(ctlr);
 }
 
-- 
2.51.0




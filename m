Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4DB28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257D5C433D2;
	Mon, 30 Jan 2023 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086845;
	bh=/MnNoqcz1T2z69Lg6g7V2XP3DlxfH2snt+PaEGzmv6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOa7rk2hZBDIFYglBjs/wTJsP50mlFRse7+8Ht6YVEPNuITeE+yFOpp2UM680JAfv
	 FxvA1xGx8ra1qFA/JTzpW/vPzuM0H8fgQzz6qmNMqpgn2f7BbB4TCv/So+U/w30Q3x
	 4qXNo30JBHZUx9ftNymF9xINBZNuAJZ7z1nqig3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/313] soc: imx: imx8mp-blk-ctrl: dont set power device name
Date: Mon, 30 Jan 2023 14:47:32 +0100
Message-Id: <20230130134337.462745922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 21b84ebeee79d91e405f87f051e9489ef30ecad6 ]

Setting the device name after it has been registered confuses the sysfs
cleanup paths. This has already been fixed for the imx8m-blk-ctrl driver in
b64b46fbaa1d ("Revert "soc: imx: imx8m-blk-ctrl: set power device name""),
but the same problem exists in imx8mp-blk-ctrl.

Fixes: 556f5cf9568a ("soc: imx: add i.MX8MP HSIO blk-ctrl")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8mp-blk-ctrl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/soc/imx/imx8mp-blk-ctrl.c b/drivers/soc/imx/imx8mp-blk-ctrl.c
index 9852714eb2a4..0f13853901df 100644
--- a/drivers/soc/imx/imx8mp-blk-ctrl.c
+++ b/drivers/soc/imx/imx8mp-blk-ctrl.c
@@ -592,7 +592,6 @@ static int imx8mp_blk_ctrl_probe(struct platform_device *pdev)
 			ret = PTR_ERR(domain->power_dev);
 			goto cleanup_pds;
 		}
-		dev_set_name(domain->power_dev, "%s", data->name);
 
 		domain->genpd.name = data->name;
 		domain->genpd.power_on = imx8mp_blk_ctrl_power_on;
-- 
2.39.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F861F7060;
	Tue,  3 Dec 2024 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241230; cv=none; b=NpZQWdcc2RAvLrMH1t1WN8u5rRHAU2wNxKx04g/9ppE45JoU4l8yTi7SwQcVot8tOHrYivzhvou/XqAYI9lFerjDZcUrqgQewB0gOu76Cbam3Tg0HQm0TYoXGqdsXjxlXRmpFpl2Cp/sVIYUWLUy/XwYHSBRzbo4oJpREn4RqPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241230; c=relaxed/simple;
	bh=OXUa7JNHyp82ljoYbTixvQHcuo02f0nTZX12BYXhFRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkJP980doGQe94Htb1s/bwAYSKabQny6vu6uEL/YCyWjlp/zmZnsN46YtL5C2jylFmj6MO8ixZXom8FWaNYA6YClswgXDpKdlHbxKV3FwUvvLH2L7ldBsz6AZfu5LnDe4KUfrw5k+kKtZuuhDiKMDjsVPeg5pGsxWlRarWOoXMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2G8/XBL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2G8/XBL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDCDC4CED6;
	Tue,  3 Dec 2024 15:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241230;
	bh=OXUa7JNHyp82ljoYbTixvQHcuo02f0nTZX12BYXhFRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2G8/XBL5nWHHiyOOF/ANsHec8ey8DPseFo4M31a8NmQHuQdPxC9GqyJa1iL4GnXbO
	 tL8zg+EWc8+s6YE7+TDE6V0y5kviAQ9DtdyaldCI8MYR7o4OCPWb6Ig9VTDWJUEn5p
	 G41kZ7wuUV0nhVe6NBk1n3S8u/PRDnNFFK3jl68w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 361/826] pinctrl: renesas: rzg2l: Fix missing return in rzg2l_pinctrl_register()
Date: Tue,  3 Dec 2024 15:41:28 +0100
Message-ID: <20241203144757.843253176@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 1737715a4c2c08f207c94cc1f3af3c5945318d29 ]

Fix the missing return statement in the error path of
rzg2l_pinctrl_register().

Fixes: f73f63b24491fa43 ("pinctrl: renesas: rzg2l: Use dev_err_probe()")
Reported-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Closes: https://lore.kernel.org/all/OS0PR01MB638837327E5487B71D88A70392712@OS0PR01MB6388.jpnprd01.prod.outlook.com/
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20241003082550.33341-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index 5a403915fed2c..3a81837b5e623 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -2710,7 +2710,7 @@ static int rzg2l_pinctrl_register(struct rzg2l_pinctrl *pctrl)
 
 	ret = pinctrl_enable(pctrl->pctl);
 	if (ret)
-		dev_err_probe(pctrl->dev, ret, "pinctrl enable failed\n");
+		return dev_err_probe(pctrl->dev, ret, "pinctrl enable failed\n");
 
 	ret = rzg2l_gpio_register(pctrl);
 	if (ret)
-- 
2.43.0




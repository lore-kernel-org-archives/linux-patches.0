Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A5A3F1AD8;
	Wed, 20 May 2026 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296153; cv=none; b=dQ6m3JvKaLbv/wEbRaJGqCV9r7SV6T+xz2RUokub6EPPOmSYNOGY2FgdiFMmmw3elaloyrTRr5XOpkgZ4HJ37X5fVrdOjOTfTOLCxSUMnaz/rIdvmClXhr5pC4AmZBdr5zhDD2M/q259Rzlzh1dAYhlwklwAGL/zGzP2HOvBHCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296153; c=relaxed/simple;
	bh=bYk2tnizFqZO4DohF16w4C9BuEVW6cwgg6aHnVLRbPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaY122XiOFiUJVlBz2eyDysu11/yoVOXa1ol07XJ2oRckKfvO8ly/jtOigPHmSXAR4S/nMvrgFH98ID8UvCT8NNh5sUi48MC6jS+jXAqNWl60ySUKlGE3aNN+JOoXdvqESvqW5ID4Fkua/+35xuQ3eo0wq4PejlDG1G2VLxmAKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2hXhMXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2hXhMXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1370C1F000E9;
	Wed, 20 May 2026 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296152;
	bh=lFW1/aXUFiVcxslx9X1Me5BO45zkCmbiTF1F2c8N2lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2hXhMXZDygCMrDNe9nCnDP2rENc9Hq5h3EuNAjxJliVd9p0WErJ4exuBydQRSEME
	 sCFdJetTM4TMnrkvEWGaAs7zb2XN9XCmX8fkxoY8TlYta5l9cA5o08GM20Iv7hcYp2
	 E829wnvb5jvovUUg+7TjwEYlQQduJg/rHw5XiU6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0651/1146] pinctrl: sophgo: pinctrl-sg2042: Fix wrong module description
Date: Wed, 20 May 2026 18:15:01 +0200
Message-ID: <20260520162202.917437289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit ca1c2ddff00480c213903a1479b56203536e92de ]

Fix the SoC model in module description string, it should be
sg2042 instead of sg2002.

Fixes: 1e67465d3b74 ("pinctrl: sophgo: add support for SG2042 SoC")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sophgo/pinctrl-sg2042.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sophgo/pinctrl-sg2042.c b/drivers/pinctrl/sophgo/pinctrl-sg2042.c
index 185305ac897d9..8dba12e122a45 100644
--- a/drivers/pinctrl/sophgo/pinctrl-sg2042.c
+++ b/drivers/pinctrl/sophgo/pinctrl-sg2042.c
@@ -651,5 +651,5 @@ static struct platform_driver sg2042_pinctrl_driver = {
 };
 module_platform_driver(sg2042_pinctrl_driver);
 
-MODULE_DESCRIPTION("Pinctrl driver for the SG2002 series SoC");
+MODULE_DESCRIPTION("Pinctrl driver for the SG2042 series SoC");
 MODULE_LICENSE("GPL");
-- 
2.53.0




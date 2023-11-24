Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAE42E64F;
	Fri, 24 Nov 2023 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yD+AmtgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8E7C433C8;
	Fri, 24 Nov 2023 18:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851846;
	bh=DdEoPN+ovIgnLLMx1ifKa8+TowXPEZ08i14P3h2CBj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yD+AmtgQRetoia2tvV0G9QXUf0XC+XSGHpbQoeDbs2D95A1x43IxACKa2L4wQfjkd
	 T+Yk9XsAzPqx61Otzw8CFGqmRrjQ+VOXr07AZU4vi6Q42/rTKwikcwFAkxTxJsUCky
	 pSFiqsDW2OZ3KBFtIf73qhK/3/V8kyY6WGcupK+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/372] mtd: rawnand: meson: check return value of devm_kasprintf()
Date: Fri, 24 Nov 2023 17:48:26 +0000
Message-ID: <20231124172014.456121705@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 5a985960a4dd041c21dbe9956958c1633d2da706 ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful by
checking the pointer validity.

Fixes: 1e4d3ba66888 ("mtd: rawnand: meson: fix the clock")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231019065548.318443-1-yiyang13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index ac4947f720478..0aeac8ccbd0ee 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -1021,6 +1021,9 @@ static int meson_nfc_clk_init(struct meson_nfc *nfc)
 	init.name = devm_kasprintf(nfc->dev,
 				   GFP_KERNEL, "%s#div",
 				   dev_name(nfc->dev));
+	if (!init.name)
+		return -ENOMEM;
+
 	init.ops = &clk_divider_ops;
 	nfc_divider_parent_data[0].fw_name = "device";
 	init.parent_data = nfc_divider_parent_data;
-- 
2.42.0




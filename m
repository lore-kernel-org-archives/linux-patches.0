Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A2F15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A67DC433C1;
	Tue,  8 Nov 2022 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915763;
	bh=XNfvEsicZoKYolNSv7Q0eLp8TsdfrI59UdhkaPMFJeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hawGY2AigqM8tNYrtFE8yQHr8b42T3efWCLtB40lwQHPGNTq1AUK/DqaxLL5rBv02
	 zl8q3Cp6TaPmjd1AW4z+nyd0o6sHZ5lHXnCRp50BwDJD21dDXSO8q5jE/uDAqczMx2
	 qrtKb2AQzDfVXobBuz3XHrL02svoxa0iyvhqO3aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/118] mtd: parsers: bcm47xxpart: print correct offset on read error
Date: Tue,  8 Nov 2022 14:38:52 +0100
Message-Id: <20221108133343.045375531@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 4c38eded807043f40f4dc49da6df097f9dcac393 ]

mtd_read() gets called with offset + 0x8000 as argument so use the same
value in pr_err().

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220317114316.29827-1-zajec5@gmail.com
Stable-dep-of: 05e258c6ec66 ("mtd: parsers: bcm47xxpart: Fix halfblock reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/bcm47xxpart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/bcm47xxpart.c b/drivers/mtd/parsers/bcm47xxpart.c
index 6012a10f10c8..50fcf4c2174b 100644
--- a/drivers/mtd/parsers/bcm47xxpart.c
+++ b/drivers/mtd/parsers/bcm47xxpart.c
@@ -237,7 +237,7 @@ static int bcm47xxpart_parse(struct mtd_info *master,
 			       (uint8_t *)buf);
 		if (err && !mtd_is_bitflip(err)) {
 			pr_err("mtd_read error while parsing (offset: 0x%X): %d\n",
-			       offset, err);
+			       offset + 0x8000, err);
 			continue;
 		}
 
-- 
2.35.1




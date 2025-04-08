Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD96214205;
	Tue,  8 Apr 2025 11:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110714; cv=none; b=HdXojhBev7J37A8hXCyt11yM2h4R2ykCNEuIgT6UcjdeefFBtY4jSjoFWymGE1KXzeRFHyB19U2GnsCFxAF3HGu6V6IojKS8sCW5mqQnXs3wWo+rPSWFv5Cvf+kik31+PycWOXoBbKixj9l/HL+3pfwa3bqIj1yvbvaqplsg22c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110714; c=relaxed/simple;
	bh=nyPWrgfYQpiuJFFB/9aRWh97LzODLsuHI2vCfSeJbGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiV3B8hSITtaZ2gdVcSVsF0F0QNQWH4F7/NV/zyovehA7M5awWQKwK6SHuC2RcOB8qvrnC/hrC5ns82MY1klSpVds/xCfqgsHEr7s3T9Bh25JeBgpEiYp4WNgKjP9Gu0BW2dkdFi1YI8ogE+uvSZfW7FKYxNrJiG8zCkga03fqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTX2Maw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTX2Maw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B5DC4CEEB;
	Tue,  8 Apr 2025 11:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110713;
	bh=nyPWrgfYQpiuJFFB/9aRWh97LzODLsuHI2vCfSeJbGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTX2Maw9RfjlxEOKNTz84gxMOWZEAbJPh19dKB0Rn6nWOFteM5xZOsLVAMqki8zPO
	 yMXFP/ILeD0JUjHFKangIzS44dmJ3PF4K+N/u5an9SruB+37r9UmMZFM9QGgFCAzPq
	 cB5YcRJ/kaYrqhmQTxN4e+20ELHKx2nmcohK4cM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 164/731] net: airoha: Fix lan4 support in airoha_qdma_get_gdm_port()
Date: Tue,  8 Apr 2025 12:41:01 +0200
Message-ID: <20250408104918.089929034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 35ea4f06fd33fc32f556a0c26d1d8340497fa7f8 ]

EN7581 SoC supports lan{1,4} ports on MT7530 DSA switch. Fix lan4
reported value in airoha_qdma_get_gdm_port routine.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250304-airoha-eth-fix-lan4-v1-1-832417da4bb5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index 09f448f291240..c1c2ab82a08d8 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -1547,7 +1547,7 @@ static int airoha_qdma_get_gdm_port(struct airoha_eth *eth,
 
 	sport = FIELD_GET(QDMA_ETH_RXMSG_SPORT_MASK, msg1);
 	switch (sport) {
-	case 0x10 ... 0x13:
+	case 0x10 ... 0x14:
 		port = 0;
 		break;
 	case 0x2 ... 0x4:
-- 
2.39.5




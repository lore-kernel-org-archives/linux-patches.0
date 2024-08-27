Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174E41E520;
	Tue, 27 Aug 2024 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771156; cv=none; b=USHIJ4M35CFY+AdxEd/r4ZfesC9Va94dlPTNSV4rTehqBr5BCKs1bwJiq/G+C2JEGdMZe628DbZFa5ptyPwXRP68nm2nNWMOsjGRxqeiXFoQvQM/8e1bTZrDXeyA2ExFUuQpWmpqCRclmsa0bt9Zh7gh6zRvm84NHF2teJ10P5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771156; c=relaxed/simple;
	bh=osUHyiZU8Hf1iEaVmp3GsUTBJnbaHuTCHFqV8ABUqlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJkVYcET68ByURJo3E0jO8qm/hBCY817aghygFAeVw5/dP94bNV9R9TwpTOOZQmJZYzkPl35bNh9gwAfe8XAJxzwbpg6+Pgmx2MihX/cLuOLzN2MJs1Ticiev1dRq2l1KBV5QwwfqpC1xAZ3eAzP2HZQr07Rn485n9cYlwZGla8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMk6OgG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMk6OgG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD35C61073;
	Tue, 27 Aug 2024 15:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771156;
	bh=osUHyiZU8Hf1iEaVmp3GsUTBJnbaHuTCHFqV8ABUqlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMk6OgG2gi1pdGQ66X1Ht6Ttkj2xTswXkdhhX6FRCILjLF+Vx2IKYpvmKed2yY840
	 cp3LF2qKe0x1eHMgHK1zyCcC3Ib5F/Hpo8QThRdCL3OI2nTHR4i8R2WABEO8uQA7Ob
	 cEZ+F6SYL7/FHeZ7Bs/fIvcm+QRCJvtwTRRc+y0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 096/273] net: dsa: vsc73xx: pass value in phy_write operation
Date: Tue, 27 Aug 2024 16:37:00 +0200
Message-ID: <20240827143837.064543384@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit 5b9eebc2c7a5f0cc7950d918c1e8a4ad4bed5010 ]

In the 'vsc73xx_phy_write' function, the register value is missing,
and the phy write operation always sends zeros.

This commit passes the value variable into the proper register.

Fixes: 05bd97fc559d ("net: dsa: Add Vitesse VSC73xx DSA router driver")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index fc4030976bdce..2725541b3c36f 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -534,7 +534,7 @@ static int vsc73xx_phy_write(struct dsa_switch *ds, int phy, int regnum,
 		return 0;
 	}
 
-	cmd = (phy << 21) | (regnum << 16);
+	cmd = (phy << 21) | (regnum << 16) | val;
 	ret = vsc73xx_write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
 	if (ret)
 		return ret;
-- 
2.43.0




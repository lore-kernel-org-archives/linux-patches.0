Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923962C1B4;
	Sun,  1 Sep 2024 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207583; cv=none; b=u2dR+TPQs2+ZPMMcOon5HT2ah/lnXEBUpaw/bKHAXzwNbTpo1Zh7dW2Gcg9bQzvRzf9Z5Y5ZNvsaA+55QXhyumsy3OVDPzDuIYVbnSZDOr8XjgaXHYuF91AzLiCIQwjsXEaPeQHn7ROkUXUBncx1rcT4v5aV1Kd5B2XO03KfrR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207583; c=relaxed/simple;
	bh=k5fUwYpwv+LET4zfrN0iM4SmJHlBSbEdbIzD64HB9mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkjHK92QSn4/W10HLIp3u9Sy+S/0sl9vb/Ji/zBSTmEGiVnpO+RWGwMr2oTuDC/uulr0ceYB2MA+U6aAFunj8iGSc+WDtowOVYWoKRs2tDaD6iholNQPSIdVZ0/1hU+EPd8+7sS1I3CMpkdlmqwEI0lqiHgTBsxSzrqK7/flyW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seXtGDy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seXtGDy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F26CC4CEC3;
	Sun,  1 Sep 2024 16:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207583;
	bh=k5fUwYpwv+LET4zfrN0iM4SmJHlBSbEdbIzD64HB9mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seXtGDy3n6do2CM2Vg/wP1A6160TgTB2eWNgzb5HeNX1dQ5r5wohhrwt8LaWSkoda
	 0AvJkqGnz/wuSXEmy+9w6BFCV5LB7A4GYysDGj+xWpFPmLSb3rvmloa9YdhbxSkKig
	 Hp7ZNQHk90EJ8G8yXYaJq1Bw3kZ5tyglhyH7Edls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 16/98] net: dsa: vsc73xx: pass value in phy_write operation
Date: Sun,  1 Sep 2024 18:15:46 +0200
Message-ID: <20240901160804.301899240@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/dsa/vitesse-vsc73xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx.c b/drivers/net/dsa/vitesse-vsc73xx.c
index 34fefa015fd79..eaafb1c30c91c 100644
--- a/drivers/net/dsa/vitesse-vsc73xx.c
+++ b/drivers/net/dsa/vitesse-vsc73xx.c
@@ -649,7 +649,7 @@ static int vsc73xx_phy_write(struct dsa_switch *ds, int phy, int regnum,
 		return 0;
 	}
 
-	cmd = (phy << 21) | (regnum << 16);
+	cmd = (phy << 21) | (regnum << 16) | val;
 	ret = vsc73xx_write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
 	if (ret)
 		return ret;
-- 
2.43.0




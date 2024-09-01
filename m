Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC83143894;
	Sun,  1 Sep 2024 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209398; cv=none; b=TcFVhTvp56JiBzissprWfU6F0G4SxBEY93jZ/zsidTYSG74r0bvAagRS3Euydoyird5lhysiUoBzQr2I/CbTLvcIcYH3DKt9+rkIgdw3duncLBUdM/03ZTx3/H3a9nCIb+P8d8GOiZ/btfWEEIzOUt9crhMZ1gUX6idlvjkBK9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209398; c=relaxed/simple;
	bh=n3IJBxnsSDf497t+jb53oYcC+oI/q+HyXAD0Z07BAak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQkkWl/dzJGSZSCLFe7z7zVmh92DcibjqV+6erJqn9mLkxYQ18/yCKn0CQRLPd5kVWWw0fofrP2AQn5kqUmZxtavMwP+XcDpJjRFN2yoPDJ2seX2QS5I/waD8ZcD5R/grKGS00VpL3IiDReY0ZTHkRYxmllcim+Uux3nX+d+Zek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2IdOG+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2IdOG+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E50C4CEC3;
	Sun,  1 Sep 2024 16:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209398;
	bh=n3IJBxnsSDf497t+jb53oYcC+oI/q+HyXAD0Z07BAak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2IdOG+icmwBLcdGRZiTtKD7U/Tc2T7q5mGFkTBmq4waKW2C+pY9oeBjFyy5IMuCf
	 nsroYS2cHnfRnQIoKEijlhH/BabdGuHE2sA+FKo4jY4Jl55M1OMJbcki6IZ0/xtUSC
	 6t5cfHjNZ9aqnphvjAEhN7igNrU1XbefUF4WmDzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/151] net: dsa: vsc73xx: pass value in phy_write operation
Date: Sun,  1 Sep 2024 18:16:23 +0200
Message-ID: <20240901160814.970978280@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 018988b95035e..55c1063327a8f 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -531,7 +531,7 @@ static int vsc73xx_phy_write(struct dsa_switch *ds, int phy, int regnum,
 		return 0;
 	}
 
-	cmd = (phy << 21) | (regnum << 16);
+	cmd = (phy << 21) | (regnum << 16) | val;
 	ret = vsc73xx_write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
 	if (ret)
 		return ret;
-- 
2.43.0




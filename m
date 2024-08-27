Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55D617C96;
	Tue, 27 Aug 2024 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772020; cv=none; b=m9Q+c4ajM9KscKV2MGKaZ4iyCA16m0WGCKGr72Rzf8K3JyXnr/PeAzYcwFM5V1TMcSnv4PSVmDtiPXrA425+Tp1ouQ24V+aaUVYuksSr6a5bGDosDtLsOzrmvtId8IAw0EYT8AUMpaHlpvLwVN+GdhJ7heDJGNVN0Hcpx/5afa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772020; c=relaxed/simple;
	bh=Lt8tWWBDsN7/pPFpAvSYvpD8qmyWKWk6lzYMArX4XPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2qsdBNEc8RcZ9zfOO2Gs3kXM+++0Kf5NVmUisEyBFNBh6a8hGeE1xSUx1h5bvzswNvR+cK9vYgtMKyMxNUv7qRMUfUhROp0N8y3oitmFfIbNJ79IWQ/J9lcG4JLRwQFjXA3KM3KWa3sfpxdc7VWQJhUbTp+AAh86GrU9EaraCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTvLeGkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTvLeGkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446EBC4DDED;
	Tue, 27 Aug 2024 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772020;
	bh=Lt8tWWBDsN7/pPFpAvSYvpD8qmyWKWk6lzYMArX4XPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTvLeGkf+1gBqP0LNXzm994lpiPy05XHwT0FMJWiy6PyN0aZv/m7bIlVT8Urn2yk1
	 SSkx5fozPvH8HAkPxMAEzqoB5FH8zPAf3tD5kM9ORw3Bo610OMHgTrUtEtIzHlKP/Y
	 vV+5Txq70/SdY50bar55fQ1Imb4dEq9Ug/SLCHsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/321] net: dsa: vsc73xx: pass value in phy_write operation
Date: Tue, 27 Aug 2024 16:36:37 +0200
Message-ID: <20240827143841.627823003@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 3efd556690563..81d39dfe21f45 100644
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




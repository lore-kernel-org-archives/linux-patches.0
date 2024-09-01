Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67011822F8;
	Sun,  1 Sep 2024 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208748; cv=none; b=s91SNEAWyDq9qk2pX+20tVKr0yaQ/q+A+JXdvEO12BBycOrKgUhWMMo8I6lguW6nkX/FXO7PITdpKwI+jIUpgYBTYAV0IyLDRj8FOpYC2j7zuZ3y1GYDScla5sBZsRR/Ya04PQ2QFslwbHTXU1+wX2s66ArpbWbnOtATPZDucDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208748; c=relaxed/simple;
	bh=V8FHagceNYPJ9zTNlhnXv0DF8M25cw4l5vwbrGBENTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3GAAgXmHiinbNpdyy06uD/AoloaHuOgqnC9kKMlI+QKmxuTe9m1XwnL6x5ROfJS+RH+ov8kVOsqml3zq/Z6wgBh/dKqic+0S9OzVmLstZfWGeqrxecXoqm/h6H0/BW07NYpIWSGOJGTg8EORYX/dbfPmkU+RXxPNnYig03ZA5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j34vLRrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j34vLRrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B88C4CEC4;
	Sun,  1 Sep 2024 16:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208748;
	bh=V8FHagceNYPJ9zTNlhnXv0DF8M25cw4l5vwbrGBENTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j34vLRrGp4EtVp/VKALi6hjRogksZYYjxIXw34i9S0hRI9j8lrhEodIb/GUvScz7z
	 tOnjlOvBirID6spmIOwl2cbTKQZxTTFanW2E+V9fmlWZVNu0Naldcc9KjjuTEAeNQD
	 t8j8LBbuRDKUz03sEriDW5m3qia38f19Taass3hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/134] net: dsa: vsc73xx: pass value in phy_write operation
Date: Sun,  1 Sep 2024 18:16:14 +0200
Message-ID: <20240901160811.166816351@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c7ff98c26ee39..a1dd82d25ce3c 100644
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




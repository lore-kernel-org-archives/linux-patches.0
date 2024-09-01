Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DE11C68C;
	Sun,  1 Sep 2024 16:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209917; cv=none; b=kAJjQq+bejE5Q0WEcaSuR8LrUB6X07xP9FBotT1vHAhSj1frCjm/F1wHrrebCHCew/D+B07TahL9HZeUmqdRSw+VFtKl2mUcV/7WBjfq3uiXu+THdfE+o0mC1c0f939ZKRjXsrOVBw0d50Y1xzSDCq93wv+vy5b7C/GRWV0rRYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209917; c=relaxed/simple;
	bh=5W1/5SA9b7p2GJstFQIohNJlyN0rFoR7BIGlJxhE+do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDwk0D3pckjWTXFgxUUlbeFkfdouKSiGd6bLqzIhA3kq5fXGQN7JsH6/8CArcntZGfY0T6A6QzloKbGjO3MNDX14yIyWi4sCNpHo+h3v/NpDabL6IeuPmEfOvea9VoiqF7r82g5tKIftAiS7B1XTuN4TXL7ukrfMLYlFu9qV3lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L807KRd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L807KRd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47408C4CEC3;
	Sun,  1 Sep 2024 16:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209917;
	bh=5W1/5SA9b7p2GJstFQIohNJlyN0rFoR7BIGlJxhE+do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L807KRd7Yq98MOzoq0RpKKrHQIAc+DxfX5xLG71u4U8gGCb+OcIZJaEcEXUgyV/yA
	 L6UkHCCvrfboGc0j7mPlt6QSfZhtaB1ANlYt8mSL1kWN462EXy2UusFf6Rno1VmjXL
	 7qIZ/I/AiqBVDyrSKVPRrR+1EEL0cfvrA/9hkeCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/215] net: dsa: vsc73xx: pass value in phy_write operation
Date: Sun,  1 Sep 2024 18:15:43 +0200
Message-ID: <20240901160824.439870839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6b6470ef2ae93..15afb84155472 100644
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




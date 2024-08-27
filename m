Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5671BFE06;
	Tue, 27 Aug 2024 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769967; cv=none; b=WU8usFBPCrCSduloc2o7tbyBlVsXNcgiiFOO6hx5wRMGrVP7eyOBdSMNy78ymlwysAs6jSD3a5mK93kmNRaFruFRCIpTHlxGcXZHQWgb0rWvzpPActKohvNwr7SMF004T68B0DJ3INyzfydDwvo10580PHUoCY3dcoyVnQp3seA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769967; c=relaxed/simple;
	bh=zUmxRdS/4TKjaHaUOLID3P+1PsiYsteNQ+G3gz6W1mY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUQYrACHki8VqsckdVP5w35pWDmw+y61/oeB0w5YaT6bbsvb30OElix8/MomxvC1wjTlfHH8jMgLYbxpcsNc6gjXX/O5dvKNngImHvTdLrpDNw5HSYb44WfAxpZ2edalhPM9vgAQKT2NahaLMJKWHFiEiX7ACfUFHaGd966IwiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CekxAIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CekxAIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49369C61063;
	Tue, 27 Aug 2024 14:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769966;
	bh=zUmxRdS/4TKjaHaUOLID3P+1PsiYsteNQ+G3gz6W1mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CekxAIQyOGRbw5SLu5wqp9jugTFo8yh3H4LkQqEzyNGR8qNS/+xQo2WRar9hmeyL
	 /3DcDwi87oNsU4e+FloF7ipBtm7wQFFmfcHstYbRnBYNrpQVWjg2UkzlDUj6t4nUMU
	 lQGuavqFLtxt3XltYPyg5zkazqoTiMCaRQIEhTxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Pawel Dembicki <paweldembicki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/341] net: dsa: vsc73xx: pass value in phy_write operation
Date: Tue, 27 Aug 2024 16:34:47 +0200
Message-ID: <20240827143845.550435622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c99fb1bd4c25a..dedebb95ece6c 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -530,7 +530,7 @@ static int vsc73xx_phy_write(struct dsa_switch *ds, int phy, int regnum,
 		return 0;
 	}
 
-	cmd = (phy << 21) | (regnum << 16);
+	cmd = (phy << 21) | (regnum << 16) | val;
 	ret = vsc73xx_write(vsc, VSC73XX_BLOCK_MII, 0, 1, cmd);
 	if (ret)
 		return ret;
-- 
2.43.0




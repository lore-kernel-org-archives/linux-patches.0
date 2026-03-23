Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057123BD655;
	Mon, 23 Mar 2026 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282334; cv=none; b=bLMHZhc+pyxgcDo60v6dQ9UxWPRGEiegTQ5akYQlgFNRD8FlCRyZd1P8vfNnWbgezoauYCWxQSlyIGDe237X3oSSnBD+S3JYSDMqQjlx0uvPTtEoikRYA/gsZFS3X1048h4r6ypQuZSanp+SrBhHZMtSNBc/6Z2SdV0fRiD2OCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282334; c=relaxed/simple;
	bh=Sj69weSCJPLnw5ozyoJDoeSBoUceqdwKkxb0zhTYudA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx/pA3Ad3PNtiYWXOMHbPeoPAK0hYaKOkhgYgPH5h5aLlW/P7dQLF3mHiFArFU5KCoMvMudPY1ESxbAoMLtSHm5OjUV3QImuNB5R5G1TQbwrCb0FIMK7T44DIBNKjed1cqJ+btCDEdtHdgQ6O8eR3WLcuDLGH4dEJpGc8zyBqvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lltY1Uct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lltY1Uct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76974C4CEF7;
	Mon, 23 Mar 2026 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282333;
	bh=Sj69weSCJPLnw5ozyoJDoeSBoUceqdwKkxb0zhTYudA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lltY1Uctub4iijbfaRNiCd2/h5yBQbDC2F9RlEJaAKsuhrhTu61+CuEaOterqvMv9
	 1gqmBOVFeJn85c6iSvzn6kAxXvTlJR895s5WWShtX1/vvbUiNI3gAbrHRgXrp6Qehp
	 nOPGxilRcM2ofAnwEmi/YVeHC5Kfx8SoffQ8bMcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/481] net: dsa: realtek: rtl8365mb: fix rtl8365mb_phy_ocp_write return value
Date: Mon, 23 Mar 2026 14:41:40 +0100
Message-ID: <20260323134528.160275652@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mieczyslaw Nalewaj <namiltd@yahoo.com>

[ Upstream commit 7cbe98f7bef965241a5908d50d557008cf998aee ]

Function rtl8365mb_phy_ocp_write() always returns 0, even when an error
occurs during register access. This patch fixes the return value to
propagate the actual error code from regmap operations.

Link: https://lore.kernel.org/netdev/a2dfde3c-d46f-434b-9d16-1e251e449068@yahoo.com/
Fixes: 2796728460b8 ("net: dsa: realtek: rtl8365mb: serialize indirect PHY register access")
Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260301-realtek_namiltd_fix1-v1-1-43a6bb707f9c@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac6..abdff73aa9c32 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -764,7 +764,7 @@ static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
 out:
 	mutex_unlock(&priv->map_lock);
 
-	return 0;
+	return ret;
 }
 
 static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int regnum)
-- 
2.51.0




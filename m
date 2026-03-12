Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F33242AC;
	Thu, 12 Mar 2026 20:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347085; cv=none; b=juy4T4XHCIwVTJ6DoDWhp0ICQU8kCSHeMiA1FmxNHK/VekllZ5RsZiLYgFAGunw+NwNITYFTB4v/5TdQnjC12psyJrCJGsnFwVgblAUKpzFsMVe8FSCvLBVV4+xRgJ6cuyg7BbiYdpQRpqLuAESwb8OIrGd70uFfEzBTLYO8+Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347085; c=relaxed/simple;
	bh=7mOInpOwljevb3Bgb1Z31USuas0Pd44mq/I8tx9hzWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxK/wGTFabqZrE44Q+8n3+ThGCljM+KGfe+W1ag4IHH3EDm3XnFERoqlYgzAUdTt7CAFqofTsijDWRWW7NUOBWxKb5OZPm9D83uVKOiMgDcAQqqLyJHWYor2Xt4fWWhbhCArYSCux/gpG3YZK7Vk4KR22Or2L5mSIf5nT1YOzwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYlk8wyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYlk8wyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142B6C4CEF7;
	Thu, 12 Mar 2026 20:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347085;
	bh=7mOInpOwljevb3Bgb1Z31USuas0Pd44mq/I8tx9hzWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYlk8wyxY4Caotv/+XXfBse3LseSGuuMxbajpLfRQfOeHKDCF+ruz4g05ogHWByoG
	 +DaDe6K/rqBeYq3mw+AskrZ/VCi2zBJs3G/4XvzgHarxCs6BUFdglS/DCZ/WuZujf1
	 /SmpX8Eh8z0lq23EcqZ0hMfGiMZ7u1wyBsJ92v+M=
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
Subject: [PATCH 6.12 199/265] net: dsa: realtek: rtl8365mb: fix rtl8365mb_phy_ocp_write return value
Date: Thu, 12 Mar 2026 21:09:46 +0100
Message-ID: <20260312201025.506944827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ad7044b295ec1..74a8336174e50 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -769,7 +769,7 @@ static int rtl8365mb_phy_ocp_write(struct realtek_priv *priv, int phy,
 out:
 	rtl83xx_unlock(priv);
 
-	return 0;
+	return ret;
 }
 
 static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int regnum)
-- 
2.51.0




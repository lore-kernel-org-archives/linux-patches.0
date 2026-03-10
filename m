Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FBA352C4F;
	Tue, 10 Mar 2026 11:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141230; cv=none; b=FFYYG5zKkAwDMEO1WGzGBzpCtawX6diRNQM8Wai4w3raVPZ/AOr+AqmSctUhxedHROyesXsggJCoisTrqWZXfhz8UgBz8HkioOSJo8bJmUuQ3W7QNTOU1SRR2956s3NfgkAfKQ43KFj8WPz8INIWTM9WbADImfowqJy3nOofPDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141230; c=relaxed/simple;
	bh=1jm+wmBzWnBcffeSje0Sk42KTXRULunFYtJczS8ul+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAh1IprSckkwCqBvH0oZQbyBFDILgeScyOIovfFKydysY1cU08TKpbqti4XQ+6j5YNeyquE8QvnQ2T1HgumQ+r6z+GxfO2gbr/2fEcH3f91qDku474y8Hg7w9jIdap0bOIIIST2ZyvjbWqmmUAkDhnJoKzNpFWveI6Xl6+l8s+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lc+EFM2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lc+EFM2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDDBC2BC9E;
	Tue, 10 Mar 2026 11:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141230;
	bh=1jm+wmBzWnBcffeSje0Sk42KTXRULunFYtJczS8ul+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lc+EFM2QPTUTJ7Py3a8T2vL/rEKPFZEeJV1j8hJ8nyvvZNggyQRkFXyKYGEzHz5nr
	 UZxVdJ9skCGT2cbOFEnSFSh7hHbPp8b9c2XcmuwU4iJvuo4FxeWPs5HnGkMhQ3w/XS
	 7oLDC4dAPiq02DMDChiyzThDkAp1VsHKbz0TtsenzqZs+63a+IDc2T3EZgVbdVly6v
	 pe0OaWnlanGP9SWKAMDahlmr69ckfGgGdwhg7iF3zpkkCOszb+DJhTKYfYIDj2FTko
	 cKzqlq2ww3aJUSK0OKwttw61paS862385Ra5UPSzaHUvJnSziqgoMfyXs+68EerjIK
	 KnC45siQ+nLyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 232/311] net: dsa: realtek: rtl8365mb: fix rtl8365mb_phy_ocp_write return value
Date: Tue, 10 Mar 2026 07:04:39 -0400
Message-ID: <5b1609cc8bf4ca66d78a526d8e8e3376d3f214da.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index c575e164368c8..f938a3f701cc9 100644
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


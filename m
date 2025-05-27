Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14A7194A67;
	Tue, 27 May 2025 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364778; cv=none; b=mplPsdw1kkwn2XWTIo8G3B6HGWC5848gWMMAUZ2At5VMUqnjaVU7T3Axmg55BJX9MoHJd3xfUNaYQWvPSe21v6efvPd1lS0LqTE/3N51Y/SsEChgo9708RFM67TO/shtIc7/2d9yyISyXj9EfUJO7d1ho3OURCd/fxFa81/4tJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364778; c=relaxed/simple;
	bh=lZWlg0Yjee68k37ThbAaSxXNs0KGxWdhqTc2PUgI3Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjsXUwt+HlEGvMJZLwjuKHC77VhMYpcyERFbi/BSfg6xygS+5xxzr0jYxpgixSy8XtKUYNuN3sseb18zGQcCjDeRQezQkFchQo891YVxsFkR9JblW7sr2M52KXTV7olOJQ4ospURtsCYXZMxBadGSsvHKQdgzlubU7TriSWbVGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cc+wUP0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cc+wUP0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D249C4CEE9;
	Tue, 27 May 2025 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364778;
	bh=lZWlg0Yjee68k37ThbAaSxXNs0KGxWdhqTc2PUgI3Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cc+wUP0UPwStCGz5RtMM2TwAZ2xn+WAgye+f8o79YTRRb9BjcRjA54bKB+VmTvxGF
	 18XZbJKBSe5sc2CJapFWYD27l3Vydi1Dfrvwm31LWhcRytRKwfm/hZWz1+b+Kvm3u4
	 ODYHiDzEkhEkPEqg2K0Hu/4snQbqTFPUeIQtElJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Perez Gonzalez <sperezglz@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/626] spi: spi-mux: Fix coverity issue, unchecked return value
Date: Tue, 27 May 2025 18:20:39 +0200
Message-ID: <20250527162450.962830925@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sergio Perez Gonzalez <sperezglz@gmail.com>

[ Upstream commit 5a5fc308418aca275a898d638bc38c093d101855 ]

The return value of spi_setup() is not captured within
spi_mux_select() and it is assumed to be always success.

CID: 1638374

Signed-off-by: Sergio Perez Gonzalez <sperezglz@gmail.com>
Link: https://patch.msgid.link/20250316054651.13242-1-sperezglz@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mux.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-mux.c b/drivers/spi/spi-mux.c
index c02c4204442f5..0eb35c4e3987e 100644
--- a/drivers/spi/spi-mux.c
+++ b/drivers/spi/spi-mux.c
@@ -68,9 +68,7 @@ static int spi_mux_select(struct spi_device *spi)
 
 	priv->current_cs = spi_get_chipselect(spi, 0);
 
-	spi_setup(priv->spi);
-
-	return 0;
+	return spi_setup(priv->spi);
 }
 
 static int spi_mux_setup(struct spi_device *spi)
-- 
2.39.5




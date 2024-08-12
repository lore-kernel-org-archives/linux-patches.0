Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BAD134AC;
	Mon, 12 Aug 2024 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479910; cv=none; b=Ckb/fZBcAhAJRQJDmXqEO0YHM3pLL1+iNnbdjfT0MG6kTYqLYp1rpm4X4NxkDfI6W51UStTEqjWIJJYFEz00LFYlDdJ2SPMxq8CWa+ndMbMBsq+AMSS41l7j5J2P/EcQAMPC/2+h0Yq9zLU0wATZ/ej1wacnEcLDPSoHKiSVQno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479910; c=relaxed/simple;
	bh=KQ6zkvOPFKG45E0hEm9EFmdoUNfTlGsRWT7gQYY3ras=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEBs/o92ATFXWV3z2F9HZR7XRRukXeGpOnSNfU5HvYIlxrfO0V2C/UWtt6k4pz/Xbwd/yCmhDZa3s+CQiIqYTHz4S8Avita+qC4Af9v3wRVnP9Vf1qYiJ/qTGvgdSVsbUm1kT1GRe3SeeDewVOpDTnvTkb0L8OyAHkTqOFk0fg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAEjUlca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAEjUlca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FF7C4AF0C;
	Mon, 12 Aug 2024 16:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479910;
	bh=KQ6zkvOPFKG45E0hEm9EFmdoUNfTlGsRWT7gQYY3ras=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAEjUlca9Q8ikBXZb0/RKzWQ5lRIJKKMdbuFVUgaLhSRaDtAZCewny8c55jRClWS4
	 /ifJ95rqFAgzHCA0kZDQXlSCiCDQRphvHsyLUi623FsLb/jrISWaPhHddoNVUXgco6
	 wccyikWiJy7QuyNT1iUK9EQwg7VUlgsS7i3FU5+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 038/263] net: pse-pd: tps23881: include missing bitfield.h header
Date: Mon, 12 Aug 2024 18:00:39 +0200
Message-ID: <20240812160148.002360529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a70b637db15b4de25af3c5946c4399144b3bc241 ]

Using FIELD_GET() fails in configurations that don't already include
the header file indirectly:

drivers/net/pse-pd/tps23881.c: In function 'tps23881_i2c_probe':
drivers/net/pse-pd/tps23881.c:755:13: error: implicit declaration of function 'FIELD_GET' [-Wimplicit-function-declaration]
  755 |         if (FIELD_GET(TPS23881_REG_DEVID_MASK, ret) != TPS23881_DEVICE_ID) {
      |             ^~~~~~~~~

Fixes: 89108cb5c285 ("net: pse-pd: tps23881: Fix the device ID check")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20240807075455.2055224-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/tps23881.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/pse-pd/tps23881.c b/drivers/net/pse-pd/tps23881.c
index e95109c1130dc..2d1c2e5706f8b 100644
--- a/drivers/net/pse-pd/tps23881.c
+++ b/drivers/net/pse-pd/tps23881.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2023 Bootlin, Kory Maincent <kory.maincent@bootlin.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF6369317;
	Wed, 21 Feb 2024 14:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525398; cv=none; b=F1vEqY25K1g+fBH51zQ1gBQa/9mOnErqum6xruFkOQl+DgYMXfZNPifc2EilgpM+mewzRD2eVUf4J5lxALC3fntZciA4rbyW97OqPF6Pp0BCg1DBD4/5eeTAlDjsBJ3dgJlgJxRgdny5uLmzDvhZ2GMjs2lxeW11VVZxs4Z7Hpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525398; c=relaxed/simple;
	bh=G61n1Q3sXlhXZ+TlPthGJmlwDhbtG7vGZR+AHLb4aRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+79axwjvRDP2p3NRyBV7P0b+jmEqf9tmGiBZ2AjSvfSRFUSxw8sC063lYwa5YDWNDHYh+86/lejc51Ms19n5sgSL+hycsI50ZqJiAGRhi/9LCH+GuTkwAjbQjZa/qLuEnODQYOmcBM02U9Wi6F6Hm8D8cCU4EdXGicVemhxJrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6B+NxSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6B+NxSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D499CC433F1;
	Wed, 21 Feb 2024 14:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525398;
	bh=G61n1Q3sXlhXZ+TlPthGJmlwDhbtG7vGZR+AHLb4aRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6B+NxSn4XdgUzRqOkeFAHDhcVdRJyRsNP6perQIQRziBlV2OC+IocxtaTP6P2j3d
	 WawUqL3l7EG8Sp+1pl0PaXQOwlRTkJKzbIL12l5RnVeDMbARQ32A6h4QFuxsu829ZT
	 sLlwllOWPz60OhoF4KxXcggLPTiW0Y6QdDuuegZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Shah <harshitshah.opendev@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/267] i3c: master: cdns: Update maximum prescaler value for i2c clock
Date: Wed, 21 Feb 2024 14:08:05 +0100
Message-ID: <20240221125944.581703511@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Harshit Shah <harshitshah.opendev@gmail.com>

[ Upstream commit 374c13f9080a1b9835a5ed3e7bea93cf8e2dc262 ]

As per the Cadence IP document fixed the I2C clock divider value limit from
16 bits instead of 10 bits. Without this change setting up the I2C clock to
low frequencies will not work as the prescaler value might be greater than
10 bit number.

I3C clock divider value is 10 bits only. Updating the macro names for both.

Signed-off-by: Harshit Shah <harshitshah.opendev@gmail.com>
Link: https://lore.kernel.org/r/1703927483-28682-1-git-send-email-harshitshah.opendev@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/i3c-master-cdns.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master/i3c-master-cdns.c b/drivers/i3c/master/i3c-master-cdns.c
index cc0944e2d330..6e0621e730fa 100644
--- a/drivers/i3c/master/i3c-master-cdns.c
+++ b/drivers/i3c/master/i3c-master-cdns.c
@@ -74,7 +74,8 @@
 #define PRESCL_CTRL0			0x14
 #define PRESCL_CTRL0_I2C(x)		((x) << 16)
 #define PRESCL_CTRL0_I3C(x)		(x)
-#define PRESCL_CTRL0_MAX		GENMASK(9, 0)
+#define PRESCL_CTRL0_I3C_MAX		GENMASK(9, 0)
+#define PRESCL_CTRL0_I2C_MAX		GENMASK(15, 0)
 
 #define PRESCL_CTRL1			0x18
 #define PRESCL_CTRL1_PP_LOW_MASK	GENMASK(15, 8)
@@ -1212,7 +1213,7 @@ static int cdns_i3c_master_bus_init(struct i3c_master_controller *m)
 		return -EINVAL;
 
 	pres = DIV_ROUND_UP(sysclk_rate, (bus->scl_rate.i3c * 4)) - 1;
-	if (pres > PRESCL_CTRL0_MAX)
+	if (pres > PRESCL_CTRL0_I3C_MAX)
 		return -ERANGE;
 
 	bus->scl_rate.i3c = sysclk_rate / ((pres + 1) * 4);
@@ -1225,7 +1226,7 @@ static int cdns_i3c_master_bus_init(struct i3c_master_controller *m)
 	max_i2cfreq = bus->scl_rate.i2c;
 
 	pres = (sysclk_rate / (max_i2cfreq * 5)) - 1;
-	if (pres > PRESCL_CTRL0_MAX)
+	if (pres > PRESCL_CTRL0_I2C_MAX)
 		return -ERANGE;
 
 	bus->scl_rate.i2c = sysclk_rate / ((pres + 1) * 5);
-- 
2.43.0




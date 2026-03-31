Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555A440710B;
	Tue, 31 Mar 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974897; cv=none; b=Vkj/UPW2fjtH4x1GAco9xl25QZ8YJTOiOZU473cAAfi5rReI8bIITvOcZrDwaN2JXt/W9uAiPVt9XZxKmPNs80DNQTrMSFCJByTXPlfHvAi2AJxQnDGMiNSA09i0rjLQOL9ttKu0QjM8sRkIaFNSeEJRUf1hhmPLBjb+EJwM61w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974897; c=relaxed/simple;
	bh=NG1vemvHmBSETMml7JrL+jsaHVzw9QCT0Osc2YBLjGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEZ2q5hcce/a7MXUv/WcDYE8o87dvtYKb2nyzRPGewO8MvnPp/DBnLjNm5N2K/hs/6q5ZES3NSMpANeIU5mGzUAt/PYgLNBM48y+VDN07FQeLfGQWMXNH5nvG43FC7wJ9vzWG0fOm/tEzQYqtLvT4TvfKDXpqH/qWhvguuNAF8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzmsG4fu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzmsG4fu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE352C19423;
	Tue, 31 Mar 2026 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974897;
	bh=NG1vemvHmBSETMml7JrL+jsaHVzw9QCT0Osc2YBLjGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzmsG4fuY0e7JeQ8sQIEInhNjH90TgOf6uEgY9vvlUhEyTn0u8Srnb33qcD+Zzuny
	 MHMZEw57zf2O5lwXNMoDZD/Jmr9FM/dm0ekEy6ByM1RyI19WADdEx5sByXVSFLzF4X
	 twkn9jqGvzmjSkQe8glL+BpDvOToxD7FgrHsEDVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 085/342] pinctrl: renesas: rza1: Normalize return value of gpio_get()
Date: Tue, 31 Mar 2026 18:18:38 +0200
Message-ID: <20260331161802.150219997@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit fb22bb9701d48c4b0e81fe204c2f96a37a520568 ]

The GPIO .get() callback is expected to return 0 or 1 (or a negative
error code).  Ensure that the value returned by rza1_gpio_get() is
normalized to the [0, 1] range.

Fixes: 86ef402d805d606a ("gpiolib: sanitize the return value of gpio_chip::get()")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/aZYnyl-Nf4S1U2yj@google.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rza1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rza1.c b/drivers/pinctrl/renesas/pinctrl-rza1.c
index 3cfa4c8be80ea..d83c7d8ee82c4 100644
--- a/drivers/pinctrl/renesas/pinctrl-rza1.c
+++ b/drivers/pinctrl/renesas/pinctrl-rza1.c
@@ -589,7 +589,7 @@ static inline unsigned int rza1_get_bit(struct rza1_port *port,
 {
 	void __iomem *mem = RZA1_ADDR(port->base, reg, port->id);
 
-	return ioread16(mem) & BIT(bit);
+	return !!(ioread16(mem) & BIT(bit));
 }
 
 /**
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED69C646;
	Tue,  3 Dec 2024 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239071; cv=none; b=sQobwJ6fAYTWk9oZJIR53TvdtgwY6ySRS8pBr+KNUYkn/IWsE+F7bpf88hNKMqgljLllGoorV8ZllWidSWlZjJWdB4jOqKvfBKfcJm2ImoohMQryquXH574VW6Ce7yUdueVzfsd6qnl44Btvz7rEBSUzcc9QcY2Xr2R8sny0ofE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239071; c=relaxed/simple;
	bh=HoMXvchHR1pbqU5zX5ZsCV7luce+eteP4x+oRfCPiW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vi5q60xO2EjlYQq3qKmmVVSS0SJfb74iPzwHFauDaFyCXa+lFQkRso9Vk7OkbTd07hy+40Ij4pVPfJDTMPoucO9GY3BpE8zhQxOaqaqSR3AjbLIl1XfeujgTY8VJBuyM/3XRqgWB3Ykqvg0/U3exJuUYhptB7xTguUD84a9ThX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQVyGgg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQVyGgg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769B8C4CECF;
	Tue,  3 Dec 2024 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239070;
	bh=HoMXvchHR1pbqU5zX5ZsCV7luce+eteP4x+oRfCPiW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQVyGgg+Ac+XLuMoOmbM9eDuBJk4w0Ti8y8uEZdwCw8PNzEa1G5TYvAiU5BTFo9Mm
	 /jNrESbbfOJ1eyLZvo7Tp0Vm2wVdjDiNbX7iaRyxsIPe+qq3DwynpXuRXRV9x4KOHq
	 iX9rAeOcz8Rns6l3r5Chli9mO4W2O4cFFAqFxWLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 475/817] pinctrl: k210: Undef K210_PC_DEFAULT
Date: Tue,  3 Dec 2024 15:40:47 +0100
Message-ID: <20241203144014.411932387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 7e86490c5dee5c41a55f32d0dc34269e200e6909 ]

When the temporary macro K210_PC_DEFAULT is not needed anymore,
use its name in the #undef statement instead of
the incorrect "DEFAULT" name.

Fixes: d4c34d09ab03 ("pinctrl: Add RISC-V Canaan Kendryte K210 FPIOA driver")
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/20241113071201.5440-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-k210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-k210.c b/drivers/pinctrl/pinctrl-k210.c
index a898e40451fe4..9c1aa3246df7d 100644
--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -183,7 +183,7 @@ static const u32 k210_pinconf_mode_id_to_mode[] = {
 	[K210_PC_DEFAULT_INT13] = K210_PC_MODE_IN | K210_PC_PU,
 };
 
-#undef DEFAULT
+#undef K210_PC_DEFAULT
 
 /*
  * Pin functions configuration information.
-- 
2.43.0




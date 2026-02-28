Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B934BC03C;
	Sat, 28 Feb 2026 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301359; cv=none; b=o1dkgVr6kZqXs1w5pneStdB+q95n7yPkJWAb6FHtcfC2XbNTUAoJiJirjl5KoPZT7XqurUHhB+RWz/JJV4+qjq+Iokq9+AGU8EZCaqeCCl1C65rAYm61JeSyr+xQHfyDyYONq1a09uXe+F1vfhiSXyM1XWyZVaP0NaF3W8aGHng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301359; c=relaxed/simple;
	bh=SbaoKpE3pbDyulVoMQ3pfokUXL4xz+oDzz0gGkC4pTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwNDCbFwwYx7HPHd4WXQRdfbsrDaDRztcRWVJiLht3/bf3j8m4rxu9vJSVoIGIjgUd1WBCY/RMjsKvjm98UvM3m0K6vdEhzOw0c+PN96iIlzOhQTB3RYu9Wk6d1T7z+O/WOkICkiC3xhOdoc2JF+Jp0+eQJtnIWrsJtH+UFqn5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeKjBk5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeKjBk5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4521AC2BC9E;
	Sat, 28 Feb 2026 17:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301359;
	bh=SbaoKpE3pbDyulVoMQ3pfokUXL4xz+oDzz0gGkC4pTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeKjBk5JEur4QcuKR0h/YmqcNq6STURii+w79HyoHhUFHT+PYGXdPrj9Bcoa4S+ad
	 AYCjDMmol+jJihTI3Y14YKRmoQcQXixU9M9g8Kj/DyXQvaLSLxENuvzXbJGVRiLwOj
	 poxwTcsNLyb7AoHqsOFH6+I0xQPvVnCiFJ6i+RfcOhKpJzFjkyh9n8Q0z7Ki8xBGRs
	 hOsW53SryoXzFtkiFDwgw8rcMb6ZEbYU7BzEjgu1/PIT6N0i2EfcIbOKBBUQ3UYTzk
	 C8GqfFJIaC6+N5Km64QQi+ESxOu5sh+zr+Zoi10lRVGlrBlCA3DQhj4sxQQDqg8apq
	 NAN/dNElqvCaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
	stable@vger.kernel.org,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Chaoyi Chen <chaoyi.chen@rock-chips.com>,
	Marco Schirrmeister <mschirrmeister@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 547/752] soc: rockchip: grf: Fix wrong RK3576_IOCGRF_MISC_CON definition
Date: Sat, 28 Feb 2026 12:44:18 -0500
Message-ID: <20260228174750.1542406-547-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 3cdc30c42d4a87444f6c7afbefd6a9381c4caa27 ]

RK3576_IOCGRF_MISC_CON is IOC_GRF + 0x40F0, fix it.

Fixes: e1aaecacfa13 ("soc: rockchip: grf: Add rk3576 default GRF values")
Cc: stable@vger.kernel.org
Cc: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Chaoyi Chen <chaoyi.chen@rock-chips.com>
Tested-by: Marco Schirrmeister <mschirrmeister@gmail.com>
Link: https://patch.msgid.link/1768524932-163929-2-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/grf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/rockchip/grf.c b/drivers/soc/rockchip/grf.c
index 344870da7675f..9b96499fa1dfc 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -134,7 +134,7 @@ static const struct rockchip_grf_info rk3576_sysgrf __initconst = {
 	.num_values = ARRAY_SIZE(rk3576_defaults_sys_grf),
 };
 
-#define RK3576_IOCGRF_MISC_CON		0x04F0
+#define RK3576_IOCGRF_MISC_CON		0x40F0
 
 static const struct rockchip_grf_value rk3576_defaults_ioc_grf[] __initconst = {
 	{ "jtag switching", RK3576_IOCGRF_MISC_CON, FIELD_PREP_WM16_CONST(BIT(1), 0) },
-- 
2.51.0


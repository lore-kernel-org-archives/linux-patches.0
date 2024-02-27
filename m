Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D745313B2B4;
	Tue, 27 Feb 2024 14:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043779; cv=none; b=IV+FqBWf0rgfvKRbIGksPNm0OOy5ypHGaUnpi/OKvDvMLjvzxMe0CR7EkEAShimpnui4RdsbqKf2R6M34n5iI4iGuzE66twu5VyK1C1V7V9klewZGFYGUlWkRjyxacVmcWDfCpSeMflW9REi9PMDUV7KCtzozrllf1XTl8eu4X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043779; c=relaxed/simple;
	bh=0wF3+1Wime0n+ObfURHAXThfpjJlZ7qfxl9gQv2YJNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hhXlbJb7cYQngwrbp0KbS/yajCnpyJGD4MSv1wnCQCVgSN68Q31g5Wxvg9DFiuT8j4hfYysnW1YBAfW2P1KQdAN7sC/EfaO0vacMafdpHq3X9SoFXD1loHJfFfbpttRgTiq9tdtzrleeJvxO/Iegxg6PUsfEP0tCkvCFjFU/AIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyghAHOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyghAHOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6427DC433C7;
	Tue, 27 Feb 2024 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043779;
	bh=0wF3+1Wime0n+ObfURHAXThfpjJlZ7qfxl9gQv2YJNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyghAHOGf0rRV1S56gqTXwYD5s+owT7MutcZ5WHwvHjtPZDwsKJGDlI2rbRacB7Ew
	 nb21fHQ0nUoygbilXAhX5OJJsRd9/osg+bP52z0gbP9rXXfwGvmWSHMk/U9vFilJZt
	 6pIxEq7GZvk8p1ChDxVwIgsVwyyVUfP2I6IkJl54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/84] pmdomain: renesas: r8a77980-sysc: CR7 must be always on
Date: Tue, 27 Feb 2024 14:27:00 +0100
Message-ID: <20240227131553.947033738@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f0e4a1356466ec1858ae8e5c70bea2ce5e55008b ]

The power domain containing the Cortex-R7 CPU core on the R-Car V3H SoC
must always be in power-on state, unlike on other SoCs in the R-Car Gen3
family.  See Table 9.4 "Power domains" in the R-Car Series, 3rd
Generation Hardware User’s Manual Rev.1.00 and later.

Fix this by marking the domain as a CPU domain without control
registers, so the driver will not touch it.

Fixes: 41d6d8bd8ae9 ("soc: renesas: rcar-sysc: add R8A77980 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/fdad9a86132d53ecddf72b734dac406915c4edc0.1705076735.git.geert+renesas@glider.be
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r8a77980-sysc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/renesas/r8a77980-sysc.c b/drivers/soc/renesas/r8a77980-sysc.c
index a8dbe55e8ba82..3d1ea245681b0 100644
--- a/drivers/soc/renesas/r8a77980-sysc.c
+++ b/drivers/soc/renesas/r8a77980-sysc.c
@@ -25,7 +25,8 @@ static const struct rcar_sysc_area r8a77980_areas[] __initconst = {
 	  PD_CPU_NOCR },
 	{ "ca53-cpu3",	0x200, 3, R8A77980_PD_CA53_CPU3, R8A77980_PD_CA53_SCU,
 	  PD_CPU_NOCR },
-	{ "cr7",	0x240, 0, R8A77980_PD_CR7,	R8A77980_PD_ALWAYS_ON },
+	{ "cr7",	0x240, 0, R8A77980_PD_CR7,	R8A77980_PD_ALWAYS_ON,
+	  PD_CPU_NOCR },
 	{ "a3ir",	0x180, 0, R8A77980_PD_A3IR,	R8A77980_PD_ALWAYS_ON },
 	{ "a2ir0",	0x400, 0, R8A77980_PD_A2IR0,	R8A77980_PD_A3IR },
 	{ "a2ir1",	0x400, 1, R8A77980_PD_A2IR1,	R8A77980_PD_A3IR },
-- 
2.43.0




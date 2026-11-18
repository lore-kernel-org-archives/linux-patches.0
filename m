Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016466;
	b=NGMYYznJaFPP7bULxqKg+vLaTWcPVryL2y0cvmgnTvdrABHzBJHw2JuU/0HwyBeh0G3Z
	 FxL6AzFlN69mb7w9n5Xy25eyiAoQxPFKKpeX7FLuIYO8doric08nx1JBCIAe9bG727tKY
	 qAQR0YfEM93EvUo+KOSCBOeNIHC2fn+ablabFNqhCP2mOosUxnjI9bjf4FVlPfK/nygfA
	 34xjYzuTU83DbpMIcnscC45b00E6t9Uld/ddarTJCC9k4p5tDsrauSQUppF+lmZaKpE84
	 LC3RGvF2e4XPrvoxvy111GXKFyy0zr/oKFGkZn66neeGQCF7oSKtaLaejU9S16N0jpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BFN2QjK9lefh3NwgoAvje+e79DTs1E/gSsLCFtPKEMY=;
	b=IVeIGueLeNMo4HRGLOBAdb8WXzSv37e5G1qfsolePcWIY0aQvqsoOg3vKYElPOvjm1ZA
	 EZMTDTA+g0gJlSEW7UrR4I6fgWlr2CdoSllutebJ1vXYidRDKgnZj5EwaAju6syP60DCR
	 bhznWUJyyILua78am81vQZBwxwRODKeSlwFSzX4IwGs3hJl3HJPTBWgep91XrE/JCTQ6W
	 rWACvbvxGC+vb8RlLvt8+t0v8+NKpAMxiH3wZDP2bjqn4+cucMQH8AoXvI8keZfbncy/B
	 5RAIzPfJw7LnUGzgqpadfWcw52zUptQEyL9zusQyxYLqJTFJEqN3eR+VmiEZaQ9oucQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcowOkh+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74753606A31C;
	Wed, 18 Nov 2026 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcowOkh+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45351F000C4;
	Wed, 18 Nov 2026 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016466;
	bh=BFN2QjK9lefh3NwgoAvje+e79DTs1E/gSsLCFtPKEMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcowOkh+XLMbZQdWIBGMHcIL8XdUKlmaVTbGah4oFq0+bwhJGjbFtjd7SKLpcbeHY
	 S0bl1E30782Nosg3jwO0jk2//1AZTCWcHcjsEftuX3Q53b2oaG8GAVK5CvqECqlPOO
	 BU2fDW8rMzN/LfbOToWI8XOKP0N/vbPacs07ke9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0539/2651] clk: aspeed: ast2700: select AUXILIARY_BUS
Date: Wed, 18 Nov 2026 15:29:39 +0100
Message-ID: <20261118150307.160127860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4457ee2f99f7286d037ccde8c107481b6105fc15 ]

The AST2700 clock driver also exposes the SoC reset controller: it hands
its register base to a reset auxiliary device via
devm_auxiliary_device_create(), which the separate ASPEED reset driver
(RESET_ASPEED) then binds to. That create call needs the auxiliary bus
core (AUXILIARY_BUS), not the reset driver itself, but COMMON_CLK_AST2700
does not select AUXILIARY_BUS.

It builds today only because RESET_ASPEED selects AUXILIARY_BUS and is
normally enabled alongside the clock driver. On a randconfig with
COMMON_CLK_AST2700=y and RESET_ASPEED=n, nothing pulls the auxiliary bus
in and the kernel fails to link:

  ld: drivers/clk/aspeed/clk-ast2700.o: in function `ast2700_soc_clk_probe':
  clk-ast2700.c:(.text+0x147c): undefined reference to `__devm_auxiliary_device_create'

Select AUXILIARY_BUS directly, as other clock drivers that create
auxiliary devices do, so it builds regardless of the reset driver.

Fixes: fdc1eb624ddc ("clk: aspeed: add AST2700 clock driver")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/aspeed/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/aspeed/Kconfig b/drivers/clk/aspeed/Kconfig
index ef50481c31ff6..2f505eb3ca95f 100644
--- a/drivers/clk/aspeed/Kconfig
+++ b/drivers/clk/aspeed/Kconfig
@@ -15,6 +15,7 @@ config COMMON_CLK_ASPEED
 config COMMON_CLK_AST2700
         bool "Clock driver for AST2700 SoC"
         depends on ARCH_ASPEED || COMPILE_TEST
+        select AUXILIARY_BUS
         help
           This driver provides support for clock on AST2700 SoC.
           The driver is responsible for managing the various clocks required
-- 
2.53.0




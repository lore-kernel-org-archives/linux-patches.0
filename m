Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD8830504A;
	Sat, 25 Oct 2025 16:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408942; cv=none; b=dp4VCTMiqn1k0LYH+0RFXcWIs8umPB/IQ9jDUAtXbRdYMZx4FOQGkphYFI7MLBUNFUHPQLcuEwrEZTimLebVO4N6rMrPZH4SkaUopB4KMDLEY1EyxIchycK54oN5KuiY/zIO6Q9oxBM/q6NCWiFw1tVyk2zNQdSviWFhNYb6AzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408942; c=relaxed/simple;
	bh=6YDHDy3zvbGQC15CA863eua98CfrMNJDClBepXmEZ4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lAWbnmjyT3anytfw0u2q0h+4Wt7LbfIhXGcJe2XHSVLRxRbb6bFVcDxwKWPTOd0CRSBmnhoPlYyoKkwXEHOiaeRq6+eoEE6gLpLj1wDEFbLoeKO93KB4H8Jrtcgd1BrDF+sonqv0jNuTlRslA8Ke2JchFa7+OQUgqaS7VfoHh0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpeBaCXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpeBaCXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE8EC4CEFB;
	Sat, 25 Oct 2025 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408942;
	bh=6YDHDy3zvbGQC15CA863eua98CfrMNJDClBepXmEZ4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpeBaCXXwsVSCbL1jeQrvkvdqGwaVP0b6XY6HNW7Ed8nwaxEGvxIZJXxfLPyepb8f
	 5xI78p40Gu+86QvxXXOVmOndyGC63sYK4if9qn+ZMXsiqZnFeSwnnYZcUUq2zQZtuz
	 Xb/gxmjaA8q5WDXrXRckh5NpskqkdbLvr1Ms8eRpN5Cjl+3aW+gUu11GOS9+gyU8ns
	 hNa+vzZ9+m2P7aJRwWB4Z4QyZHoJaCMGnjWd/YmNZIOEu1of/fDXWHPgILsiTlBIzX
	 cQXFShup3DpAci7Ir7vyUJ6v/kfmdz9LWvAC7VonCfEkUk0Z0ZdopwVs9ZY+nMR6K3
	 +Gx2GEgFWvd5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robert Marko <robert.marko@sartura.hr>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Steen.Hegelund@microchip.com,
	UNGLinuxDriver@microchip.com,
	alexander.deucher@amd.com,
	davem@davemloft.net,
	alexandre.f.demers@gmail.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.15] net: ethernet: microchip: sparx5: make it selectable for ARCH_LAN969X
Date: Sat, 25 Oct 2025 11:56:13 -0400
Message-ID: <20251025160905.3857885-142-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 6287982aa54946449bccff3e6488d3a15e458392 ]

LAN969x switchdev support depends on the SparX-5 core,so make it selectable
for ARCH_LAN969X.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20250917110106.55219-1-robert.marko@sartura.hr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES. The change extends the `SPARX5_SWITCH` Kconfig dependency so the
switch core can be enabled when building for `ARCH_LAN969X`
(`drivers/net/ethernet/microchip/sparx5/Kconfig:6`). Without it, the
LAN969x-specific driver entry `config LAN969X_SWITCH`, which is compiled
into the same `sparx5-switch.ko`, cannot even be selected because it
depends on `SPARX5_SWITCH`
(`drivers/net/ethernet/microchip/sparx5/Kconfig:28-31` and
`drivers/net/ethernet/microchip/sparx5/Makefile:1-23`). That prevents
any LAN969x system—the SoC is defined under `ARCH_LAN969X`
(`arch/arm64/Kconfig.platforms:187-201`)—from instantiating the SparX-5
core that the LAN969x code relies on (for example the
`lan969x_fdma_init()` path in
`drivers/net/ethernet/microchip/sparx5/lan969x/lan969x_fdma.c:357-392`
or the LAN969x DT match wired into the SparX-5 platform driver in
`drivers/net/ethernet/microchip/sparx5/sparx5_main.c:1116-1136`). In
practice this means current stable kernels that already merged LAN969x
support ship a non-functional configuration knob—akin to a build
regression—because the required core can’t be enabled. The fix is a
single Kconfig dependency tweak with no runtime side effects and no
architectural churn, making it a low-risk, high-value backport that
unblocks hardware support.

 drivers/net/ethernet/microchip/sparx5/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
index 35e1c0cf345ea..a4d6706590d25 100644
--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -3,7 +3,7 @@ config SPARX5_SWITCH
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
 	depends on OF
-	depends on ARCH_SPARX5 || COMPILE_TEST
+	depends on ARCH_SPARX5 || ARCH_LAN969X || COMPILE_TEST
 	depends on PTP_1588_CLOCK_OPTIONAL
 	depends on BRIDGE || BRIDGE=n
 	select PHYLINK
-- 
2.51.0


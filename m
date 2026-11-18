Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015221;
	b=IouUS7trd5fz2wxV3HXPGwYSSih/jX2t7r5qNF4tBX1NFMutM2QVNDSIKpyvUrURsDWX
	 AlWrZQ74l4hGqqf6W+vbixZchEB2voLgLR2W9wCBNmSqS4RMBxNGM4uzYKDtdvfsBFnoM
	 lXKhooIdrw93MnhuP9XNSYQl0HCbom24tNUgLWNCbYFqMPMx10BxMo4971mWJ4OxspfqY
	 bbtnWT+Q6lQxLh4Fvs+MOsh6gmP+7MV0zCP/NmsPlW2SRIL+T8QyOfacmfYFiyV/VmMNb
	 VHvqFFzFZxL7IQlQ5XejjbUhY2hgSZdAw10opXJXXzLzm5tVtfB+AbOL+/ZMJnLgGyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kXYEPvh8DfA7cmYP+ZU1MWCcPSRrRlMCJ3TuwBl4zJQ=;
	b=VDzmZZYU60zTDcxcI07sTlxcabpv4DPXq299KujAVUpIvOdwgvdvsx79IbLHrsHd63Vs
	 liEGcPay8yALr8sKOdETytC406lnF/zgzGzR6gh/bnnSiTOgiDTwg/8J86PwAPxGIkqYQ
	 kLvH9Z/cc6oQvweowqLKqqPvppyEv/HvzK9eRHvyZRsm68lEfZxonfO9PrbS1K71sM9yc
	 m81Ubc+5N3cX87NuQ11Pptk4ODZkof9O9Be2FYbMb/0027BMtE/W70dbLhepwGk/vN1dD
	 ZrCnKlizCBtXnoHMDnHoXcenfv4Fg/wNzoKqvTddy37b2iGk0UsyaV+slULvzh75X+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HM4Gtied;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692D360A260F;
	Wed, 18 Nov 2026 15:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HM4Gtied
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836901F000D1;
	Wed, 18 Nov 2026 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015221;
	bh=kXYEPvh8DfA7cmYP+ZU1MWCcPSRrRlMCJ3TuwBl4zJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HM4GtiedtT1Nhe4VOdWOgCb+G9Mn6lebtfMenjXIrboEcQuQYeuSlhUCqu69sY9pU
	 kNKN+QYNfO2KkHVQQN32FsUv16YRXzIZlNxeGYpYLAu1U9XFuJAw3DgPy3yXeqeMFD
	 LGrar9xQiv5+IKL7WeLHDaDkGg2mr36h199oQgb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <tanure@linux.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0096/2651] clk: meson: t7: keep the memory fabric clocks running
Date: Wed, 18 Nov 2026 15:22:16 +0100
Message-ID: <20261118150251.356442756@linuxfoundation.org>
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

From: Lucas Tanure <tanure@linux.com>

[ Upstream commit 43e1705ecab981c66baee89041e6f728c0436f19 ]

Four clocks feed the bus that moves data between the peripherals and
memory. Nothing in Linux claims them, so they were switched off shortly
after boot, and any device that started a transfer after that point
simply stopped. The SD card, which comes up about two seconds in, never
finished reading its identification.

There is no device these clocks belong to, so mark them as always
needed.

Fixes: fab4d651b592 ("clk: meson: t7: add t7 clock peripherals controller driver")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lucas Tanure <tanure@linux.com>
Link: https://patch.msgid.link/20260829094758.23248-2-tanure@linux.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/meson/t7-peripherals.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/meson/t7-peripherals.c b/drivers/clk/meson/t7-peripherals.c
index 214db7850d865..55d09e78593b0 100644
--- a/drivers/clk/meson/t7-peripherals.c
+++ b/drivers/clk/meson/t7-peripherals.c
@@ -945,11 +945,16 @@ static T7_SYS_PCLK(sys_aucpu,		SYS_CLK_EN0_REG0, 14,	0);
 static T7_SYS_PCLK(sys_cec,		SYS_CLK_EN0_REG0, 16,	0);
 static T7_SYS_PCLK(sys_gdc,		SYS_CLK_EN0_REG0, 17,	0);
 static T7_SYS_PCLK(sys_deswarp,		SYS_CLK_EN0_REG0, 18,	0);
-static T7_SYS_PCLK(sys_ampipe_nand,	SYS_CLK_EN0_REG0, 19,	0);
+/*
+ * NOTE: sys_ampipe_nand and sys_am2axi0..2 provide the clock to the AXI bus
+ * used for DMA between the peripherals and the DRAM. After the clocks are
+ * disabled, a device that starts a transfer cannot complete it.
+ */
+static T7_SYS_PCLK(sys_ampipe_nand,	SYS_CLK_EN0_REG0, 19,	CLK_IS_CRITICAL);
 static T7_SYS_PCLK(sys_ampipe_eth,	SYS_CLK_EN0_REG0, 20,	0);
-static T7_SYS_PCLK(sys_am2axi0,		SYS_CLK_EN0_REG0, 21,	0);
-static T7_SYS_PCLK(sys_am2axi1,		SYS_CLK_EN0_REG0, 22,	0);
-static T7_SYS_PCLK(sys_am2axi2,		SYS_CLK_EN0_REG0, 23,	0);
+static T7_SYS_PCLK(sys_am2axi0,		SYS_CLK_EN0_REG0, 21,	CLK_IS_CRITICAL);
+static T7_SYS_PCLK(sys_am2axi1,		SYS_CLK_EN0_REG0, 22,	CLK_IS_CRITICAL);
+static T7_SYS_PCLK(sys_am2axi2,		SYS_CLK_EN0_REG0, 23,	CLK_IS_CRITICAL);
 static T7_SYS_PCLK(sys_sd_emmc_a,	SYS_CLK_EN0_REG0, 24,	0);
 static T7_SYS_PCLK(sys_sd_emmc_b,	SYS_CLK_EN0_REG0, 25,	0);
 static T7_SYS_PCLK(sys_sd_emmc_c,	SYS_CLK_EN0_REG0, 26,	0);
-- 
2.53.0




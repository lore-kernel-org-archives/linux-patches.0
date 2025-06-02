Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EE11401B;
	Mon,  2 Jun 2025 13:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872647; cv=none; b=nzr2RlphPbQMaKiVceLQajDEhvvD6JWJCbCNTBjBY6Lb07VXDvTgdjMiBLD05pNypAXFz3RcsEjD4LpXQqx2pw+OapaQq4CX4N//T88Jbsl1sk54S5oy5NP4QLuziI7GoP9WN6UHEpVRZrjSeyI1ed1Vo8lss/Yies5Iz6pRQ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872647; c=relaxed/simple;
	bh=8EdFSnW4jD4t8aZEsOG97p3J+CZja6QgM6QmXxnAjQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TE1XwQKbdkm6pBUUDxhpMfcQzbSChbeHIsUMuig9i+aj25902PLQj7OqLGwKCq7j0NFI0XKt10e6euViHvp1oD95SEoIHOlKkqEJb+ILqE1Et+TAs9aHeYfy0vM0wLYwaUqHJ0EgJPMjmCSNAfyuK1q3x69CaDFlugw9Lt9BJHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxOlheu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxOlheu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910D4C4CEEB;
	Mon,  2 Jun 2025 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872647;
	bh=8EdFSnW4jD4t8aZEsOG97p3J+CZja6QgM6QmXxnAjQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxOlheu3fv4z3bmBaQmhxxYijr7mRAu+gwX+FK61B3+a6l8eAI5g0zzCU9ULo1X43
	 1EFwakSpZBGvhVFxDMUXmdxVlR/QKn9B/UroF1jDaCqDtfcRsPhmwoB5me8NpD+IZC
	 PL6dNC8rWA9iPwkCKqD5IXGMofQHVumaznw2S9fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.14 27/73] arm64: dts: ti: k3-am62-main: Set eMMC clock parent to default
Date: Mon,  2 Jun 2025 15:47:13 +0200
Message-ID: <20250602134242.767820631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit 3a71cdfec94436079513d9adf4b1d4f7a7edd917 upstream.

Set eMMC clock parents to the defaults which is MAIN_PLL0_HSDIV5_CLKOUT
for eMMC. This change is necessary since DM is not implementing the
correct procedure to switch PLL clock source for eMMC and MMC CLK mux is
not glich-free. As a preventative action, lets switch back to the defaults.

Fixes: c37c58fdeb8a ("arm64: dts: ti: k3-am62: Add more peripheral nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Udit Kumar <u-kumar1@ti.com>
Acked-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20250429163337.15634-2-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -552,8 +552,6 @@
 		power-domains = <&k3_pds 57 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 57 5>, <&k3_clks 57 6>;
 		clock-names = "clk_ahb", "clk_xin";
-		assigned-clocks = <&k3_clks 57 6>;
-		assigned-clock-parents = <&k3_clks 57 8>;
 		bus-width = <8>;
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39753DB324;
	Mon, 17 Aug 2026 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973919; cv=none; b=oxIWci1XlBnu8LHWnAIM6efbOSDQtRwnpW2kR775OhrOzD52PmIpCaCic9w9mWsu/3M0DdpVcFkm/ICdmdKSibG0824ZZ5uuuNCL7MVvqpAnVqMiep+6GelAsr1MPhQxZWjj1jtgqm4TQSp3EOmYCKe5cxsP64+tHwIQzspB8Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973919; c=relaxed/simple;
	bh=wH1e16cY4yLi57KJs8VPylvA7Vsw6dJmtUvcFSBWNLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heiLnhkKpTqky/CylpCCRor28oy6F8ivYWjFPr23n93er399gv10u/wkC8AYtHvKSA9t1Ma4s4EUMahxfsDQZf2BT2CCQ5usLnflC9wbr0Ei7LPdFdFuqKZuHdUZDGxD8m3uKdbjsFt2E5+Qez9W+1CzqvWIl4amSJot0HFMwWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2hHizm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2hHizm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4548E1F000E9;
	Mon, 17 Aug 2026 13:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973917;
	bh=3orQNjqz6LxmAGDEgtXg5l1H2DynNoUAvVbw4UPJKj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J2hHizm4qyG9wNyrsi0wGajUwOKMT9sBUv5xxl1IsxX+MCgPtWaSa2nG3CeZFYA1n
	 Hrv2SMrMioG5qg0EfdirC7iG9icphedR/9qynsxUb3+pHcrNuXw2crPULzQ+8l2b+l
	 kEg89+9pm8Sa21y6/XqdvvycoHr84BpmfvpKgDiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 026/271] ARM: dts: BCM5301X: fix PCIe controller 2 second interrupt
Date: Mon, 17 Aug 2026 15:29:11 +0200
Message-ID: <20260817132537.827828065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit bab4d538f8485e0d48538fcb82b285df3779278e ]

PCIe controller 2 has interrupts 0-4 mapping to GIC SPI 138-142. The
mapping for interrupt 1 was incorrectly set to 138 due to a copy-paste
error. Fix it to 139.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/r/20260725215722.9323-1-rosenp@gmail.com
Fixes: 3b3e35b279be ("ARM: dts: BCM5301X: Relicense AXI interrupts code to the GPL 2.0+ / MIT")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm-ns.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm-ns.dtsi b/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
index 392a257136696..bd52de0faa3ea 100644
--- a/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
@@ -141,7 +141,7 @@ axi@18000000 {
 
 			/* PCIe Controller 2 */
 			<0x00014000 0 &gic GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
-			<0x00014000 1 &gic GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
+			<0x00014000 1 &gic GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 2 &gic GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 3 &gic GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 4 &gic GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.53.0




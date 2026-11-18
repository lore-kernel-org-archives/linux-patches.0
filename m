Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018230;
	b=rD/pNZu86hXaP/Mei47TiMSCu2qOa/YvFZhzPcSjDOvQfBMtNo6IqrS4ZqKPem4D0m9Q
	 w6LYKX0Xpp1XNmjPv63/rm80gR3/6FL7wJf4cOOFGlUutR4dlMiAJzVljsMWMpcIqhhVE
	 pA9nv199WWxcTVsIuRmj6VdqRya6NchG5fDo7/C8pKY1J3zvYFdJCUDPurd8S+4s8WFqi
	 mqc9BlFyNWke+7EP3H0sOyPbJPDGPC9aESMvoL5rrTQAhCqFPITo/ZviKJCA9K4nqUBbq
	 Dj0VeYIbCB8tc2I31uadU0uuK+ybQUSx05YCfhqlUSuNThaCwfLvWp+TZ+eTHcJGRmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0300EH9re/mAoINtAuJLdnoopHBlGbZMiBgG0IFWRg=;
	b=pSHuqcKEcQpV+OHh098o9pVqEZSiU9hwZ7yUCDPQI91t60QY8lTgxK13z26Geod4AdMn
	 wxMq1GuHpZW6iHtvpryUYkJdrICjzbR4xtBQktszOs0sUkeifLfbKjKLsWnW5FHhF7ZTD
	 1HfB4Cm+0B5LxyFnA1Ot5zCJRL5AI+q0zS7qFr36PW4KNBhOmADAgf8oRKIAEaEW9masz
	 F4wEhRDzg5wVtET62tB7bz6srObQMFe44luEEqIZqd/oetzu0eXONrMxLNQucOJjfffrg
	 b4D4mTjeJynMJZDDz2FTqFXcYt/NYEr3mA5lZ5LfT3cXBqcDOLu2ETaDslsTjAYik5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAXv3DFh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C8C606A32A;
	Wed, 18 Nov 2026 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAXv3DFh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDF71F000C4;
	Wed, 18 Nov 2026 16:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018230;
	bh=m0300EH9re/mAoINtAuJLdnoopHBlGbZMiBgG0IFWRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAXv3DFh/F6uQBdT/llXiL/M1sw9tNi8gXU/d/xekGymPrQTSL/9foS5QGU4e86oA
	 MPJf+cLNC0uSK+4wdGTWtvXAODx4/f0PZ1OdH409MOP/0LB1aGtapze4IyKJcj09h9
	 IFmMXcQBckiTfxYwbwpaCMLrRptXVxrTaO5PusjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morris <jmorris@namei.org>,
	Jennifer Berringer <jberring@redhat.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1165/2651] riscv: dts: spacemit: k3-com260: keep dldo4 enabled
Date: Wed, 18 Nov 2026 15:40:05 +0100
Message-ID: <20261118150329.951809744@linuxfoundation.org>
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

From: James Morris <jmorris@namei.org>

[ Upstream commit f314c98807c12272a1902aeda9c648d81b39bad2 ]

dldo4 on the P1 PMIC is marked regulator-boot-on, but has no consumer
described in the device tree. The regulator core can therefore disable
the firmware-enabled rail during unused-regulator cleanup.

Enabling pcie4_rc on a K3 CoM260 Dev Kit without this change while the
board's included RTL8852BE module is connected to the M.2 E-key slot
results in CPU hard-lock, as seen in kernel log:

[   32.521536] dldo4: disabling
[   48.125823] watchdog: CPU3: Watchdog detected hard LOCKUP on cpu 4
[   64.125829] watchdog: BUG: soft lockup - CPU#1 stuck for 26s!
[   64.125926] Hardware name: SpacemiT K3 CoM260 IFX (DT)
[   64.125928] epc : smp_call_function_many_cond+0x158/0x740
[   64.125938]  ra : smp_call_function_many_cond+0x11a/0x740

GitHub Copilot assisted with diagnosis and build and test automation, and
changelog drafting.

Fixes: cfe5c91cb73c ("riscv: dts: spacemit: k3: Initial support for CoM260-IFX board")
Assisted-by: GitHub-Copilot:gpt-sol-5.6
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Jennifer Berringer <jberring@redhat.com>
Link: https://patch.msgid.link/20260928231807.1757995-2-jberring@redhat.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
index 37627963a6492..8102b9847afd0 100644
--- a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
@@ -170,6 +170,7 @@ dldo3: dldo3 {
 			dldo4: dldo4 {
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 				regulator-boot-on;
 			};
 
-- 
2.53.0




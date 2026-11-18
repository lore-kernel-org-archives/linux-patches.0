Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028897;
	b=zzatUhhsbgNoNtXq+5w7xeHp9tImOgb7V6pVOjZ5YsJ56rdvChfPm9Or9/TkJkpejKPe
	 XQrEo4fk+XZTMCBD0whuXB3fgA2njUs/zhTYwCJDIkYtTQgZ8Qz/z/VM4QzZT7CFTYVke
	 FdTwl8Wl2dsbSlToEUfEWbAxZgT0wJR1drfRofhqh626ceTIK2KoayPUeTHPC/lEr0nta
	 oQuBsgECyxRU/MDuOqNKkRkIzgnrC4b3282Jmj+z/uZqsqp/iq4t6gv5QZD2MghvRGTzh
	 7z40USFCFLa6pzJUHq/adBpM/NyeV8k+ppLDjCH3lgOyq4tR2rcHn3ItXdwaRQoerbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pcq3/1Kqr8DkUWueVHCCdaP9T7H1WR2kFPO0bEJnBq4=;
	b=L6VVrhEN7WJFa6/0b/2P14Ha0/qGDoS/Hk3SV9ZjtgRL3x1J2FU40zDnlmBAOmK0h9cm
	 jNqm+uqr6wQb1uMxIf5sUydWqBEl//R/624h+MbfaQ9XgZ88cPFE5SUFSKoQoM8FEqJ1K
	 pHMDfW3YOX3iEF8zx5r4uam63Zflr31Ec56vpZJQnXN1ZkhZUHOZNvPFRi67R255hKd/S
	 lO/BUrglB/2zSlZfQ1Qpa6Pd294+3fVrRYMgsyvWVnZdNY6r8MB33RkMS6L1EZV6hQSYU
	 RaLq2SYQFCe6rI/VG/FiMudpor5RvC5OaHIw+mZL2mfVG/fk3XnyP+r7kqRIeKRRXkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0XSRS75x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D64606A333;
	Wed, 18 Nov 2026 19:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0XSRS75x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C124F1F000C4;
	Wed, 18 Nov 2026 19:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028897;
	bh=pcq3/1Kqr8DkUWueVHCCdaP9T7H1WR2kFPO0bEJnBq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XSRS75xprIOEY0PVn+zDD2KnGc5lU4/kA+AvqB5gF/ybRpN/32rSJ/+ZRYyBElSB
	 qbAUEx3FnLeeEozhGKw7d+ZZ4t389TYdEpOL5PMYOmhYk18QiqM4ntp9DNcCXYakmI
	 rtuOlPIzPgyEMecT/g147qTAVdH9AjunUwIjwpFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0156/1756] ARM: dts: armada-385-clearfog-gtr: fix vmmc property name
Date: Wed, 18 Nov 2026 15:38:03 +0100
Message-ID: <20261118150014.336606700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 337d10963f601d5a3dfb4b7aa273ca8c0b4d5172 ]

The SDHCI node references the 3.3V regulator through a bare "vmmc"
property, which is not part of the mmc controller DT binding; the
correct property is "vmmc-supply".

Fixes: aecc313490ae ("ARM: dts: mvebu: add support for SolidRun Clearfog GTR")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi b/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
index 8208c6a9627a8..4b4a1af514bcf 100644
--- a/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
+++ b/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
@@ -235,7 +235,7 @@ sdhci@d8000 {
 				pinctrl-0 = <&cf_gtr_sdhci_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0




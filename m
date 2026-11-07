Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064075;
	b=eZOqwd/oFqWlPRprP2JcaKMAiXLhqXukQnGmy/34qBlShPjfE8sMqUbWppO3I6cCQkPt
	 MJpPy1M/FlZ59LtC363qYpjZAfqhauwFl1i7uClpd5uzobfjSyyvOCKJjldjIXLZGGd3B
	 xc2QqgySDI98pHrnZYLU/EDU+o17kB9wLKcFqqXpLRB7tIg1g6W6zQbVJPpK7UgMIkCGx
	 OuUzE9/4jVqftSCl1fYQoMWLtxU2UQTEduALAtpFqWi1MNfjdiA85H9S8m0ZgJuQ5tksU
	 zL+yqQinbJ7Ro/cEK0n343J08LsTfb89irH0Kuk8Dmdz76RYWvCv9qfUH25PmK/DIUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EkALx03+DoLwEp6+ykx/gFhMgKH0cRvPYn4mzDl1/uE=;
	b=Dzb7aFSJw4xOvBGbeAFWYuVmPIpiOz0k4ZrhRhtQbrekJ5ug+KPBZ/3B0blge9RBtMlE
	 hybCOMXfZhqV+W285ijj7OyCX7qCRHLl5HscHgt2RWWqrSTY7snCJddWstzaC+dFVcAUm
	 7HyMEBHtA5pWxrvZtT8lqTgGoKfVAJIjFHrlpYnzqtn2uzD3k5TTEuWMBx2g1uBaJAYEw
	 Mglk2cHehfCd4XdSTYFMSIEwqUJXSbmpk/MoFW1oGr8+GJGaNWYTir30REwvsipFgZha7
	 8adzVLpmVP7x2L4/QTp7IvtqlnDvANQ98H2TfDu+fYflU2ZAPsbh/EZcnRUvfLjUcnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKdMmfV1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658F5606A9F9;
	Sat,  7 Nov 2026 15:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKdMmfV1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A361F0089F;
	Sat,  7 Nov 2026 15:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064075;
	bh=EkALx03+DoLwEp6+ykx/gFhMgKH0cRvPYn4mzDl1/uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKdMmfV1Vcb+gKeP+hz3wGWGvna62v48+sALhyfXRBV4Q718VOhRQEeeV4HH88NDt
	 H5EzpaCVU34wygJY1/XU5BpEEW06sJr8gyzlY1toGvb7//Y4JR6kwEXoCrgjUoAbPQ
	 TrR4uNmBZoniMSV5Y5iGdH+e7F352+D+R3B4ahmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0241/1257] arm64: dts: ti: k3-am625-tqma62xx: Set MMC clock pins as OUTPUT
Date: Sat,  7 Nov 2026 08:42:17 -0500
Message-ID: <20261107134946.174978766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit f9a93fe78d8737860a8fb786d17c9dff20782b7d ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: 5b36d8c72c91 ("arm64: dts: ti: Add TQ-Systems TQMa62xx SoM and MBa62xx carrier board Device Trees")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-13-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-tqma62xx-mba62xx.dts | 4 ++--
 arch/arm64/boot/dts/ti/k3-am625-tqma62xx.dtsi        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-tqma62xx-mba62xx.dts b/arch/arm64/boot/dts/ti/k3-am625-tqma62xx-mba62xx.dts
index efc00d2a860a7..3859512c42628 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-tqma62xx-mba62xx.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-tqma62xx-mba62xx.dts
@@ -735,7 +735,7 @@ main_mmc1_pins: main-mmc1-pins {
 			/* (A21) MMC1_CMD */
 			AM62X_IOPAD(0x23c, PIN_INPUT, 0)
 			/* (B22) MMC1_CLK */
-			AM62X_IOPAD(0x234, PIN_INPUT, 0)
+			AM62X_IOPAD(0x234, PIN_OUTPUT, 0)
 			/* (A22) MMC1_DAT0 */
 			AM62X_IOPAD(0x230, PIN_INPUT, 0)
 			/* (B21) MMC1_DAT1 */
@@ -755,7 +755,7 @@ main_mmc2_pins: main-mmc2-pins {
 			/* (C24) MMC2_CMD */
 			AM62X_IOPAD(0x120, PIN_INPUT, 0)
 			/* (D25) MMC2_CLK */
-			AM62X_IOPAD(0x118, PIN_INPUT, 0)
+			AM62X_IOPAD(0x118, PIN_OUTPUT, 0)
 			/* (B24) MMC2_DAT0 */
 			AM62X_IOPAD(0x114, PIN_INPUT, 0)
 			/* (C25) MMC2_DAT1 */
diff --git a/arch/arm64/boot/dts/ti/k3-am625-tqma62xx.dtsi b/arch/arm64/boot/dts/ti/k3-am625-tqma62xx.dtsi
index 72288678cd01f..a200a2afe16fa 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-tqma62xx.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am625-tqma62xx.dtsi
@@ -299,7 +299,7 @@ main_mmc0_pins: main-mmc0-pins {
 			/* (Y3) MMC0_CMD */
 			AM62X_IOPAD(0x220, PIN_INPUT, 0)
 			/* (AB1) MMC0_CLK */
-			AM62X_IOPAD(0x218, PIN_INPUT, 0)
+			AM62X_IOPAD(0x218, PIN_OUTPUT, 0)
 			/* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0)
 			/* (AA1) MMC0_DAT1 */
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156701BD9D0;
	Wed, 20 May 2026 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295604; cv=none; b=h9BQGqJyqgmAmfZfCEhNG4v8tt09kj66Ca6pzSUrlEdg7AT6svFweHo68hCy/Wi3VThH8iny1bBEZZB16QAvCQQTN0ww7G3bszRTyeVzt7/AvFUUn0a3uDQ2gebD0EpMjtW8MPAvR/YsXLAHbozB3QOADImCzzadx63iT+T48XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295604; c=relaxed/simple;
	bh=scMK+Lf5TpW9IV9lmqsgTBg/38MYqBnN2nyFCigTkEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qt+j4KGrCzQTP4zHn8O82g4fNIG81mraHmCC6xD08rKmk9/+mrn9QWd9O7HtZxzwO3jRIpNYXCLdPmiPUswYcO+bMed1anGorUL3Ks+Ff+sucJiZYu++I9xUbBFL1uguFwOK8s3OOwwf7GS0c8FcZUzLSR+5fJmS7Lf1mNT3vvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0ALc/c0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0ALc/c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3D61F000E9;
	Wed, 20 May 2026 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295603;
	bh=weJlc/0Y1ZlOjJnoGdSaer1FfXaKxlTgCylG7Cv7vXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0ALc/c0vczLRWeY9VrOcwJL75wdwxY0fQ8nYmYr0Heq/JHghPjW51iTSxv95f6go
	 TxZv1iaXbgVdEEEZBHBO4+gdic5QJDRRdOcJnAxD7r/r1sSxzai+m0fsBAxIeG3Wj6
	 T2v006ssytXw1db+eBvJTrz71pGHRQbs0c085PBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0483/1146] arm64: dts: ti: k3-am62l: include WKUP_UART0 in wakeup peripheral window
Date: Wed, 20 May 2026 18:12:13 +0200
Message-ID: <20260520162159.122827722@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kendall Willis <k-willis@ti.com>

[ Upstream commit e5452968a4b04f93bf9b778ccfd00f79e4d4f529 ]

WKUP_UART0 is apart of the wakeup peripherals and has a range from
0x002B300000 to 0x002B3001FF. Expand the wakeup peripheral window to
include WKUP_UART0.

Fixes: 5f016758b0ab ("arm64: dts: ti: k3-am62l: add initial infrastructure")
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Kendall Willis <k-willis@ti.com>
Link: https://patch.msgid.link/20260219-v6-19-wkup-uart-wakeup-v4-1-eda09dce5623@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62l.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62l.dtsi b/arch/arm64/boot/dts/ti/k3-am62l.dtsi
index 23acdbb301fe3..e01e342c26daa 100644
--- a/arch/arm64/boot/dts/ti/k3-am62l.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62l.dtsi
@@ -92,7 +92,7 @@ cbass_main: bus@f0000 {
 			 <0x00 0x00b00000 0x00 0x00b00000 0x00 0x00001400>, /* VTM */
 			 <0x00 0x04080000 0x00 0x04080000 0x00 0x00008000>, /* PDCFG */
 			 <0x00 0x04201000 0x00 0x04201000 0x00 0x00000100>, /* GPIO */
-			 <0x00 0x2b100000 0x00 0x2b100000 0x00 0x00100100>, /* Wakeup Peripheral Window */
+			 <0x00 0x2b100000 0x00 0x2b100000 0x00 0x00200200>, /* Wakeup Peripheral Window */
 			 <0x00 0x40800000 0x00 0x40800000 0x00 0x00014000>, /* DMA */
 			 <0x00 0x43000000 0x00 0x43000000 0x00 0x00080000>; /* CTRL MMRs */
 		#address-cells = <2>;
@@ -104,7 +104,7 @@ cbass_wakeup: bus@a80000 {
 				 <0x00 0x00b00000 0x00 0x00b00000 0x00 0x00001400>, /* VTM */
 				 <0x00 0x04080000 0x00 0x04080000 0x00 0x00008000>, /* PDCFG */
 				 <0x00 0x04201000 0x00 0x04201000 0x00 0x00000100>, /* GPIO */
-				 <0x00 0x2b100000 0x00 0x2b100000 0x00 0x00100100>, /* Wakeup Peripheral Window */
+				 <0x00 0x2b100000 0x00 0x2b100000 0x00 0x00200200>, /* Wakeup Peripheral Window */
 				 <0x00 0x40800000 0x00 0x40800000 0x00 0x00014000>, /* DMA */
 				 <0x00 0x43000000 0x00 0x43000000 0x00 0x00080000>; /* CTRL MMRs */
 			#address-cells = <2>;
-- 
2.53.0




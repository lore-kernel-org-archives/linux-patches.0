Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016823;
	b=wP/RN2AYx+90XdOslZG9xtxTWBRTA13Sh6kFPoYC1Gd5rAcE50Hrm2vF/cSDJo3pIIlR
	 dIJm1cqC1GWzktAlwQXz+sTcP/KbU3Iphd1RmLBR9OTIFcmoG88PsOFAFe7+GNoTDXbk0
	 wbMhLXZh138HnrVmYOFsH4gkPGpe+QLdNnXlS21wHWtQjbwzHimWFOVgxHLSyj04GCwHS
	 Z1EUotTLyXoU5DlePD+4rThn5QxWTmwKLnYoVWxltuqePzFJxFe4CIxf4sa75nBKeHxy4
	 BfiMPxPwuBG29OV1tBd4n0AKobuiotNbwCUvhzV92TcQufiwZ/72685DvyCGvSyyIhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lSkpeWHD3hBgPgKPxi4oG5haESkFCI5HIbexsgmkRLE=;
	b=BoEMSfokUQev1koj+XFnPxBvW6OKhLffTux0pHEcSiaR3E0Hks66dbpEl8NadDpZaGH1
	 xgkgi3ytp92EWP8sz5uFqoZNyXQW6MTKWlTJA0LhnFkcjIGD3947Plln45tm7NWV1JlRk
	 hF0uKDeM5VV0svEcqbvknTKNrQS55bo5nMNsyS2Ci0yEv1walTRG3wkVscFuHrw4vArXj
	 BMB5BD0oFgs/X7dmV7L9e6XCszNhZJrSTMW47BBpV1Fpb41zhbIK+S4hCjJ0JmgLQ+5Rt
	 XCZtqJa7gOh7p2Jv8jOyAHCbIzGdypddpwwNmHwCWqoYTG9eoauEZSgNWVsanifMGmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0H8SSzmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB2606A330;
	Wed, 18 Nov 2026 15:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0H8SSzmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8D01F000C9;
	Wed, 18 Nov 2026 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016822;
	bh=lSkpeWHD3hBgPgKPxi4oG5haESkFCI5HIbexsgmkRLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0H8SSzmb6TWISPFyiiMIqZWtKPdoBJBwyZ0FBcMuFohrSKncNENEcx2CNeOM8SQCq
	 mcy001HZ/0yLttJacBmFMiHGyq25mWdyJsCUkPKZlz8oBaCHPgdvOt6ZDZkZ45wreF
	 vQ2CwzQgEEoRQP69huYLpZKNKTI5OLe4LGlMflIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0666/2651] arm64: dts: ti: k3-am62-verdin: fix main_gpio0/main_gpio1 line names size
Date: Wed, 18 Nov 2026 15:31:46 +0100
Message-ID: <20261118150311.852448545@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 11a51e82e1f997975a28358a1dcffec190ea7282 ]

gpio-line-names sized main_gpio0/main_gpio1 for 87/88 lines, the SoC's
ti,ngpio values before they were corrected to 92/52 in commit
28c8f2189d80 ("arm64: dts: ti: k3-am62-main: Fix GPIO numbers in DT"),
four months before this file was written. Resize both arrays to match,
keeping every existing label at its original index.

Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260914190943.50843-1-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi | 41 +++-------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
index 895b1b7dcac71..0421248280951 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -1012,6 +1012,11 @@ &main_gpio0 {
 		"",
 		"",
 		"",
+		"",
+		"",
+		"",
+		"",
+		"", /* 90 */
 		"";
 };
 
@@ -1068,42 +1073,6 @@ &main_gpio1 {
 		"",
 		"SODIMM_17",
 		"SODIMM_155", /* 50 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 60 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 70 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 80 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
 		"";
 };
 
-- 
2.53.0




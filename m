Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333106FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99428C433C8;
	Sun, 17 Sep 2023 19:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980008;
	bh=FaQjAb2zYMO1YjQrxeUxtBKrLv8dMDEeyg9XfYol9Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uL8NkwnEkYEu3vHHrlOi+q9lqTC1IQCFrtOWdwj4Ewl2uL1NbXPqpMXyWvWk3izUe
	 SVFYrMfmfMyvyHjBhcbstgB+/W0k2T7B5tK8DFRKM2AF4QHaLlxnbc+j8FPVr1EvZC
	 b4dqfr7hmWOS+D0Hb1Hpl5xmts6N9G29GrHyTZG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomohiro Komagata <tomohiro.komagata.aj@renesas.com>,
	Chris Paterson <chris.paterson2@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.5 032/285] arm64: dts: renesas: rzg2l: Fix txdv-skew-psec typos
Date: Sun, 17 Sep 2023 21:10:32 +0200
Message-ID: <20230917191052.781761234@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Paterson <chris.paterson2@renesas.com>

commit db67345716a52abb750ec8f76d6a5675218715f9 upstream.

It looks like txdv-skew-psec is a typo from a copy+paste. txdv-skew-psec
is not present in the PHY bindings nor is it in the driver.

Correct to txen-skew-psec which is clearly what it was meant to be.

Given that the default for txen-skew-psec is 0, and the device tree is
only trying to set it to 0 anyway, there should not be any functional
change from this fix.

Fixes: 361b0dcbd7f9 ("arm64: dts: renesas: rzg2l-smarc-som: Enable Ethernet")
Fixes: 6494e4f90503 ("arm64: dts: renesas: rzg2ul-smarc-som: Enable Ethernet on SMARC platform")
Fixes: ce0c63b6a5ef ("arm64: dts: renesas: Add initial device tree for RZ/G2LC SMARC EVK")
Cc: stable@vger.kernel.org # 6.1.y
Reported-by: Tomohiro Komagata <tomohiro.komagata.aj@renesas.com>
Signed-off-by: Chris Paterson <chris.paterson2@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230609221136.7431-1-chris.paterson2@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/renesas/rzg2l-smarc-som.dtsi  |    4 ++--
 arch/arm64/boot/dts/renesas/rzg2lc-smarc-som.dtsi |    2 +-
 arch/arm64/boot/dts/renesas/rzg2ul-smarc-som.dtsi |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/boot/dts/renesas/rzg2l-smarc-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzg2l-smarc-som.dtsi
@@ -100,7 +100,7 @@
 		rxc-skew-psec = <2400>;
 		txc-skew-psec = <2400>;
 		rxdv-skew-psec = <0>;
-		txdv-skew-psec = <0>;
+		txen-skew-psec = <0>;
 		rxd0-skew-psec = <0>;
 		rxd1-skew-psec = <0>;
 		rxd2-skew-psec = <0>;
@@ -128,7 +128,7 @@
 		rxc-skew-psec = <2400>;
 		txc-skew-psec = <2400>;
 		rxdv-skew-psec = <0>;
-		txdv-skew-psec = <0>;
+		txen-skew-psec = <0>;
 		rxd0-skew-psec = <0>;
 		rxd1-skew-psec = <0>;
 		rxd2-skew-psec = <0>;
--- a/arch/arm64/boot/dts/renesas/rzg2lc-smarc-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzg2lc-smarc-som.dtsi
@@ -77,7 +77,7 @@
 		rxc-skew-psec = <2400>;
 		txc-skew-psec = <2400>;
 		rxdv-skew-psec = <0>;
-		txdv-skew-psec = <0>;
+		txen-skew-psec = <0>;
 		rxd0-skew-psec = <0>;
 		rxd1-skew-psec = <0>;
 		rxd2-skew-psec = <0>;
--- a/arch/arm64/boot/dts/renesas/rzg2ul-smarc-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzg2ul-smarc-som.dtsi
@@ -83,7 +83,7 @@
 		rxc-skew-psec = <2400>;
 		txc-skew-psec = <2400>;
 		rxdv-skew-psec = <0>;
-		txdv-skew-psec = <0>;
+		txen-skew-psec = <0>;
 		rxd0-skew-psec = <0>;
 		rxd1-skew-psec = <0>;
 		rxd2-skew-psec = <0>;
@@ -112,7 +112,7 @@
 		rxc-skew-psec = <2400>;
 		txc-skew-psec = <2400>;
 		rxdv-skew-psec = <0>;
-		txdv-skew-psec = <0>;
+		txen-skew-psec = <0>;
 		rxd0-skew-psec = <0>;
 		rxd1-skew-psec = <0>;
 		rxd2-skew-psec = <0>;



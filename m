Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D0246D563;
	Tue, 21 Jul 2026 15:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648612; cv=none; b=qsHOSFx2FTFH6C5NbLYyN+h9UzBLpncUe/3507cZZd7XqHWuumQKUHd9KnbMuuHZMsWHiqrPdKekzraHyjq6WSi6PZPTiVe3lsRAph4Urd2Wy5J2hHsRGuM/ivZKoGUefLlIyQEkvRie3cFhbO/IrvmYvNzFrnV474ZguVSi+nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648612; c=relaxed/simple;
	bh=+ydt/5YnOZjfJLnoBFOJbZI0c/KD5wMBg/6xd1IaqpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPJ2rl4ambri/03FYKwizJTFKg/GmoXeEfIZlLwiK2dktgcP9SXbbzstNjJgP4Ud7G9DHkk2LYLhQ9w48WFbbFl0R2wiYZ5LInslCXYuu5Fbm9xR3NmoyVjZnUctQwJLaXxjsEQziBR+T8h/3nS/heE55mGE6mOs+b3DLftwdUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eahx77aE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eahx77aE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3F31F000E9;
	Tue, 21 Jul 2026 15:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648611;
	bh=cntMBgvM9iItH+w8B/sndAgKye3Jm5PiHiUX3DtF6yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eahx77aEIBK7clRk0Lf5gy88N6hw7BCUvMZ+KNhG8k9DBB+gLp0WJ0rwiiheFADoP
	 jnoyyv4cx21gMJIrTkob6g9jGXnldIkey/cSAJMCCtt3jP/egaqYl3tgOug2A+aRNY
	 V/qpjC7GjUSvzpckRk3mH69lmpACHnz6utUBBiTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0263/2077] arm64: dts: qcom: eliza-mtp: Fix the debug UART index
Date: Tue, 21 Jul 2026 16:58:56 +0200
Message-ID: <20260721152558.882501139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 179d11c1c0cfaddcfc984edc3c1863ab600f679f ]

The Eliza MTP debug UART is QUPv3 WRAP2 SE5. The existing DTS labels it
as uart14, but the serial-engine index for this block is actually 13.

Rename the SoC UART label and pinctrl state to uart13 and update the MTP
alias and node reference accordingly.

Fixes: af20af39fc09 ("arm64: dts: qcom: Introduce Eliza Soc base dtsi")
Fixes: 2a5d4fc6f3f7 ("arm64: dts: qcom: eliza: Enable Eliza MTP board support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260515-eliza-dts-fix-debug-uart-and-more-support-v2-1-5ad3da81b9d3@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/eliza-mtp.dts | 4 ++--
 arch/arm64/boot/dts/qcom/eliza.dtsi    | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/eliza-mtp.dts b/arch/arm64/boot/dts/qcom/eliza-mtp.dts
index 90f629800cb02f..4708df8eb4a409 100644
--- a/arch/arm64/boot/dts/qcom/eliza-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/eliza-mtp.dts
@@ -15,7 +15,7 @@ / {
 	chassis-type = "handset";
 
 	aliases {
-		serial0 = &uart14;
+		serial0 = &uart13;
 	};
 
 	chosen {
@@ -382,7 +382,7 @@ &tlmm {
 			       <118 1>;  /* NFC Secure I/O */
 };
 
-&uart14 {
+&uart13 {
 	compatible = "qcom,geni-debug-uart";
 
 	status = "okay";
diff --git a/arch/arm64/boot/dts/qcom/eliza.dtsi b/arch/arm64/boot/dts/qcom/eliza.dtsi
index 7e97361a5dc58c..9edfee5e1dde53 100644
--- a/arch/arm64/boot/dts/qcom/eliza.dtsi
+++ b/arch/arm64/boot/dts/qcom/eliza.dtsi
@@ -639,7 +639,7 @@ qupv3_2: geniqup@8c0000 {
 			#size-cells = <2>;
 			ranges;
 
-			uart14: serial@894000 {
+			uart13: serial@894000 {
 				compatible = "qcom,geni-uart";
 				reg = <0x0 0x00894000 0x0 0x4000>;
 
@@ -655,7 +655,7 @@ &clk_virt SLAVE_QUP_CORE_2 QCOM_ICC_TAG_ALWAYS>,
 				interconnect-names = "qup-core",
 						     "qup-config";
 
-				pinctrl-0 = <&qup_uart14_default>;
+				pinctrl-0 = <&qup_uart13_default>;
 				pinctrl-names = "default";
 
 				status = "disabled";
@@ -1338,7 +1338,7 @@ tlmm: pinctrl@f100000 {
 			gpio-ranges = <&tlmm 0 0 184>;
 			wakeup-parent = <&pdc>;
 
-			qup_uart14_default: qup-uart14-default-state {
+			qup_uart13_default: qup-uart13-default-state {
 				/* TX, RX */
 				pins = "gpio18", "gpio19";
 				function = "qup2_se5";
-- 
2.53.0




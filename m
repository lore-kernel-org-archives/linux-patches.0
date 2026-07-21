Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C0B46AA88;
	Tue, 21 Jul 2026 15:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648255; cv=none; b=V3RiemvhsznuZCY64fdACZ9Cdl6uLrXuZprFWVTqv25qfPmZ2cvNEbchpZrglnxebuT1k2jEyaC6N2djaljPct3IE0AEzfApo32Xvbt+McRFPag0tPEG5CEbx78pGGbjKtaSNhmse749lxPdE5qtrrgga5dW7GKKd12jaWVHtE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648255; c=relaxed/simple;
	bh=ivoqsw4OKhOfou6IxA0WrCrgKIQY6G/Es460HdolTMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es2x70xbpD1kwo6X/Nfm6qEkhJqWP7SLrTTAcxo5etcd65MUpcvM4wjmsm8bPSpS0OsPE7L84WkPlxT2+3hPlns9S1T5NtCrL3GgxoTQutyX8NwG1QRD2zmjpWTlFDF0ZQsM+/hxVMXasAYCsvfjkn2qvzyYk6yahiXiOsZOT78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ip5QLIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ip5QLIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35AD1F000E9;
	Tue, 21 Jul 2026 15:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648254;
	bh=KP1SZ9C5i3fa1pK3Ta9LS9OsTYK9UeJOSod2VnCPr3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Ip5QLIay7rXHInqIluDvuw/AkpOvIoo+CE3Qy5QoMZzQAmUNwUCOSz8Ql9DX8jyW
	 cKnJMcGRTEsdD1cifIk9kPrfGgTR1O6RN9K4AwEeAUBtnjmZFv5JkemypNJl0altcR
	 31L11Ko5EjoxZsYe1CdjNf9f+lCtQz+7J3bycxas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0087/2077] arm64: dts: qcom: sc8180x: Fix phy simple_bus_reg warning
Date: Tue, 21 Jul 2026 16:56:00 +0200
Message-ID: <20260721152554.744542737@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit f319a5fc998e29699d325af0e461721b3768eeec ]

Correct the unit address of phy node in Qualcomm SC8180x SoC DTSI to fix
W=1 DTC warning:

  sc8180x.dtsi:2650.31-2695.5: Warning (simple_bus_reg): /soc@0/phy@88ee000: simple-bus unit address format error, expected "88ed000"

Fixes: 35e3a9c1afce ("arm64: dts: qcom: sc8180x: switch USB+DP QMP PHYs to new bindings")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260405-dts-qcom-w-1-fixes-v2-4-1f2c7b74a93f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index f45deb188c6c09..e87e82fa73e9c3 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2647,7 +2647,7 @@ usb_mp_qmpphy1: phy@88ec000 {
 			status = "disabled";
 		};
 
-		usb_sec_qmpphy: phy@88ee000 {
+		usb_sec_qmpphy: phy@88ed000 {
 			compatible = "qcom,sc8180x-qmp-usb3-dp-phy";
 			reg = <0 0x088ed000 0 0x3000>;
 
-- 
2.53.0




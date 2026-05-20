Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E23352016;
	Wed, 20 May 2026 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295704; cv=none; b=Sxlx15NzAH63wTGOYQ19zSc1TsGotoOMtjushEfuV9YO1Ib7xt60sJj8dbW933H0U9FxucnEZVC3Iyi8WTQnB5lUnKcqBmOA1An3/hbOHKmZgp7SVrs4+aH8njxCgMsLAWIoJRhks/mwkF18BTOevVZ9uoKcDWY9S4m3JkJmyhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295704; c=relaxed/simple;
	bh=GfNH7UhBOxbJ1I2pSgKa+pF7BxiuioLBBF5ZSIyckPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N6gXESRDQ+Sz1NEi2BjGVjH2S/Yj9UFIeSdgisdj13+138mlQUMwnd9cNeW4AXEipzZNaQPbEVnYZlFwkD5GvaEqAqV5StDzZlR0eTFxE8WY7yWeTtlYNcNvwxagPkr7FcpGTj3zIKPJBv1GCc2MwpcbwK0s/pyqtwxcRT0OzJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkMQheC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkMQheC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFB61F000E9;
	Wed, 20 May 2026 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295703;
	bh=RCZo1D7kbaIhlsBJxSjxc+BoftmH2/MFLavRm5FvdsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkMQheC56NUCUKZuHvhGRWTrUWpbe8+QoNmWfo5q/uS7XZ2sXj0fxKN2B9QpYrZ+K
	 tjSMdttrwEcYaYo8682+nVfhWU+tifL5RPlieHxNCQwskcyPl6GO9lOk6AP8XnMtXI
	 mdEiI3ioIbW+/nZBNHxga7zXZUFj8WudN80jkoY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0479/1146] arm64: dts: qcom: sm6125-xiaomi-ginkgo: Remove extcon
Date: Wed, 20 May 2026 18:12:09 +0200
Message-ID: <20260520162159.031366932@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 79664600fd3ed3972ad9321e13d1f80267730447 ]

GPIO pin 102 is related to DisplayPort what is not supported
by this device and it is also disabled at downstream,
remove the unnecessary extcon-usb node.

Fixes: 9b1a6c925c88 ("arm64: dts: qcom: sm6125: Initial support for xiaomi-ginkgo")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20260126-xiaomi-willow-v3-4-aad7b106c311@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
index d5e5abdb3b2ff..418cfe67a2da8 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
@@ -77,11 +77,6 @@ ramoops@61600000 {
 		};
 	};
 
-	extcon_usb: extcon-usb {
-		compatible = "linux,extcon-usb-gpio";
-		id-gpios = <&tlmm 102 GPIO_ACTIVE_HIGH>;
-	};
-
 	gpio-keys {
 		compatible = "gpio-keys";
 
@@ -304,7 +299,3 @@ &tlmm {
 &usb3 {
 	status = "okay";
 };
-
-&usb3_dwc3 {
-	extcon = <&extcon_usb>;
-};
-- 
2.53.0




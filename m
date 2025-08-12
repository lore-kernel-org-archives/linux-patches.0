Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666DD1EBFE0;
	Tue, 12 Aug 2025 18:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023362; cv=none; b=WWj6PUrxPMQArHzz5fu19ZFbnvJ38AJLztowt07McpFsnJyVked/7d4L1TI6/qOar0wx3K2i4jadn/F/d4y2yovz+wcQOa5/KE5GISqydq4lm1tmKnvB1IwDmiV3tIf07u8lr/JBozZGz5RbSijVPi0UhQER+/4cNbclQvdwSyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023362; c=relaxed/simple;
	bh=6A7A+jVckRwY6AsZL5yUqYVQTmPq3BKk2R4ZS0Rp19g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aheUlC41UjZp2Wvc2pTWX3aCUAy0GyK0yeJJyl9ZU9b3162ovp48a40HM5Qa3akiRdBLNS2GcaSoE/Vgmz5UrfBZP05It9L0jOzzp9QpL/vVO1Qx4Or9Qih7xzTmF93TjXSr7rxF4t5POnikAzgdxpNuR1gBD2F3B57IINpTcwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJPzbzw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJPzbzw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F4CC4CEF0;
	Tue, 12 Aug 2025 18:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023362;
	bh=6A7A+jVckRwY6AsZL5yUqYVQTmPq3BKk2R4ZS0Rp19g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJPzbzw9qXRgzmSL82BRPX7RO2GeG2URAruEpTokNMFA+s9SMEUYk+GBd3IC+26Ir
	 3a/Y0xPKvKKuhYS7MoNlVVVrcfpe3ChQ+biNr/CjK/czThWY2LEDpmjcg4whsB/SJk
	 AFxO/VXbpT6HsAs49aBk94EQsDNZoQWrs7wCC5RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 056/627] arm64: dts: ti: k3-am62p-j722s: fix pinctrl-single size
Date: Tue, 12 Aug 2025 19:25:51 +0200
Message-ID: <20250812173421.462422435@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit fdc8ad019ab9a2308b8cef54fbc366f482fb746f ]

Pinmux registers ends at 0x000f42ac (including). Thus, the size argument
of the pinctrl-single node has to be 0x2b0. Fix it.

This will fix the following error:
pinctrl-single f4000.pinctrl: mux offset out of range: 0x2ac (0x2ac)

Fixes: 29075cc09f43 ("arm64: dts: ti: Introduce AM62P5 family of SoCs")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20250618065239.1904953-1-mwalle@kernel.org
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi
index fa55c43ca28d..2e5e25a8ca86 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi
@@ -259,7 +259,7 @@ secure_proxy_sa3: mailbox@43600000 {
 
 	main_pmx0: pinctrl@f4000 {
 		compatible = "pinctrl-single";
-		reg = <0x00 0xf4000 0x00 0x2ac>;
+		reg = <0x00 0xf4000 0x00 0x2b0>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
-- 
2.39.5




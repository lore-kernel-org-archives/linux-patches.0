Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C5A127B70;
	Tue, 30 Apr 2024 10:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473791; cv=none; b=YXIxwTDp4JJTbuP4b5Q2MVDcH6+UiTLbSA+bTUwCv35aFCSo4rNCfoIWV5neYrtX2BxJIAdDQbnzgimZbN+p0tE2wmZXHF1PX+Mx0LGdtZV2e3spUBgZ8+b2j+yXfi2KwVxWZNi9hw58MZp/9UKUBDpX6bMl24KniOw4L3bjfVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473791; c=relaxed/simple;
	bh=7mflOkeJ1i6OTTfXPXrDo7Te1Wryu5tZm5rA6FZiOgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOVMykqPfiHgFKXJFUDb4m+BCo7StvhZE6PT/SlOSYdXT1XrXl1QqSGqLV20qb4fbqAJU2ZiRC1+3rXPz/bgDTg1Nrkll5/aoey1MoFxWVjm+ZDlsrP5IObGixt/UdGas9EkNpu/EHnunFsuAQoMCCPudemlK195thIw2+SCu2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxVVV6MP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxVVV6MP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2F4C2BBFC;
	Tue, 30 Apr 2024 10:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473790;
	bh=7mflOkeJ1i6OTTfXPXrDo7Te1Wryu5tZm5rA6FZiOgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxVVV6MPwLWigrBodrQilvl6h6cbh6AhxXTkTKj3CbHF4BdIZAva0Xa3aDncY53xM
	 Ruc+aA1BbKjHO4uNxGP4C7LrStdRr5ZHCXA3G0fn/a8fZGSmcWgRLszS26daviPrYF
	 nerCmMffhMnGX3HgYf8nkCdYNUbfkhV91JC0HNgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/77] arm64: dts: rockchip: enable internal pull-up on PCIE_WAKE# for RK3399 Puma
Date: Tue, 30 Apr 2024 12:39:18 +0200
Message-ID: <20240430103042.287796040@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit 945a7c8570916650a415757d15d83e0fa856a686 ]

The PCIE_WAKE# has a diode used as a level-shifter, and is used as an
input pin. While the SoC default is to enable the pull-up, the core
rk3399 pinconf for this pin opted for pull-none. So as to not disturb
the behaviour of other boards which may rely on pull-none instead of
pull-up, set the needed pull-up only for RK3399 Puma.

Fixes: 60fd9f72ce8a ("arm64: dts: rockchip: add Haikou baseboard with RK3399-Q7 SoM")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308-puma-diode-pu-v2-2-309f83da110a@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index b79017c41ce56..1c9b4a9557082 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -426,6 +426,11 @@
 	gpio1830-supply = <&vcc_1v8>;
 };
 
+&pcie_clkreqn_cpm {
+	rockchip,pins =
+		<2 RK_PD2 RK_FUNC_GPIO &pcfg_pull_up>;
+};
+
 &pinctrl {
 	i2c8 {
 		i2c8_xfer_a: i2c8-xfer {
-- 
2.43.0




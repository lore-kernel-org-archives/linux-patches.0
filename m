Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487444315A;
	Sun,  7 Sep 2025 20:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277617; cv=none; b=tZHJ6rp3cvJ4kEwe8TOt7J8NKVOuYotsnNekcOyMiqdNa1lOhfICwSxSvm1jmVeIEsGixUbxJ58oduVD6DxnQ7tre5nuK56IOI0Z7GWVfAtJuEulm7CF/s1lzUviYApwd5Tuvw6nkBrNlw7eBYW3uuy5w8R6bq3dSEGQrbYEfeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277617; c=relaxed/simple;
	bh=1TC0VV3InH/1kpi5l3N67Zrq5CChJ7EZDHCgv9a8V8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koVXO8oqU/LVxgMxSYn9PIcq7KcmKjZ+kjxTNK23LZz0uBQIzUGP/SMlu85M5cppC987apk7tud085cuOX8BZCOcAYonMi3YoCTlymlmVmyGuEOExTSq3Hr/15fnMJl60fYNVATyY+RExqW9wUBsZeRkDXq1iMnU7HF3lxCdiP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuZAaXDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuZAaXDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67527C4CEF0;
	Sun,  7 Sep 2025 20:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277615;
	bh=1TC0VV3InH/1kpi5l3N67Zrq5CChJ7EZDHCgv9a8V8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuZAaXDa1ZnI68MHr7O0HFo0Ji9KaVoLEP2aFlnYbJgwyuLTHleJWR5iCa6N6sKkX
	 znRdz/MM7FjfTmfGxsZv3p4u3/c3CpcLDRa9w2CKt9kkNMrRfZz2jYkOGzzIXrSBzj
	 e6v0TULYEe2898yMr2UOolirwVRN7rc+B7X9sIHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 025/183] arm64: dts: imx8mp: Fix missing microSD slot vqmmc on DH electronics i.MX8M Plus DHCOM
Date: Sun,  7 Sep 2025 21:57:32 +0200
Message-ID: <20250907195616.375542011@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit c53cf8ce3bfe1309cb4fd4d74c5be27c26a86e52 ]

Add missing microSD slot vqmmc-supply property, otherwise the kernel
might shut down LDO5 regulator and that would power off the microSD
card slot, possibly while it is in use. Add the property to make sure
the kernel is aware of the LDO5 regulator which supplies the microSD
slot and keeps the LDO5 enabled.

Fixes: 8d6712695bc8 ("arm64: dts: imx8mp: Add support for DH electronics i.MX8M Plus DHCOM and PDK2")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index 7f754e0a5d693..68c2e0156a5c8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -609,6 +609,7 @@ &usdhc2 {
 	pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
 	cd-gpios = <&gpio2 12 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
+	vqmmc-supply = <&ldo5>;
 	bus-width = <4>;
 	status = "okay";
 };
-- 
2.50.1




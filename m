Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE125B0AA;
	Sat, 12 Sep 2026 10:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207766; cv=none; b=e+DNRhBYg4JvcbPddayD61kAevMp+JM6S1anxDrF4erDz4PomqC7lCScv/wt/aSeEDYBGzWmdS8l3c9oQeHIO4hf1QKpHWfvif/hWpRBHF6ID6a8RfTNRCP7kM4T8R+zcp5KFff2MwnkiROD9kkJO2iaw6BkiSyZYYOPbKcJ4Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207766; c=relaxed/simple;
	bh=gXFR1opC0HDEu5jlad0gkwwzbs/V+ntolqV85ST4gIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4uK8HwT+6kLZl1ZF9y3YmA6iZsYWHBkDzmzyWym8gypinwywZlGYtwQDf0kMbSI4RswWo2RsgRQrBuJO/VLOVrJFpi4czVhHZL0t+KSmj8/a5ji48aeZ+gmNWZtPxCJd5PyU0AAK4wQ5h/77H1g53aAVZfV18EwKfxXyX/zbQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUy1pPdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUy1pPdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641571F000FF;
	Sat, 12 Sep 2026 10:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207765;
	bh=BN/zeIgLNDB5PK1sN2+Hlx6xBNv1oDUSr8BGorhvZoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUy1pPdXIueG/9hEp4W3dJL2OXRGpkuoaRskm7zJ2ffDzuuPs3S+3daVD4jKd86YC
	 bvzLvwy0e8n0w75WIAhkAn9zVV4sP0ypWI7Qwv+2BZYbTJyzabHS5lrTlgE+bjNFvN
	 U2bui7/3UECuOJwYy53yRzK7wxaYnTopY9BOpTR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0480/1518] arm64: dts: amlogic: meson-axg-s400: enable mipi_pcie_analog_dphy for PCIe
Date: Sat, 12 Sep 2026 08:44:09 +0200
Message-ID: <20260912065634.305428816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yan <jerrysteve1101@gmail.com>

[ Upstream commit 7f1d0cc86cb70fa550163b6f70fd1d484c03218e ]

The PCIe PHY node references mipi_pcie_analog_dphy via its phys property.
Enable this analog PHY node to make PCIe functionally viable.

Fixes: 9715b01da6cf ("arm64: dts: meson-axg-s400: enable PCIe M.2 Key E slots")
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20260624135650.727077-5-jerrysteve1101@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg-s400.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
index 9611775b81eee..7c8a8529dbc5f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
@@ -432,6 +432,10 @@ gpio_speaker: gpio-controller@1f {
 	};
 };
 
+&mipi_pcie_analog_dphy {
+	status = "okay";
+};
+
 &pdm {
 	pinctrl-0 = <&pdm_dclk_a14_pins>, <&pdm_din0_pins>,
 		    <&pdm_din1_pins>, <&pdm_din2_pins>, <&pdm_din3_pins>;
-- 
2.53.0




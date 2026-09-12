Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BBC2D0C94;
	Sat, 12 Sep 2026 07:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199220; cv=none; b=QJ84DJp7QvBx8wt5lJvMqMirAsXMFHOkYI27M6taBKW/xZcKxvLaifSnRvUPUT82FxkY47sgpAjxy75jnIgEN16Ql3rKBe8UBrQzcmVnMHZND0nF8LNT94QC36ycw7KDE2rtaT7hnBiSArZnVLQTL9LHC8FapZTX2oUXFpTKyTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199220; c=relaxed/simple;
	bh=DifD/25ROnH3ngVfLybkMb8kXrG7ZuI5QGjhiNfxqDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HK/Re+xNuDFQDNIEPY6RyzYNXsp0Bm27DsnPuXUl/IgKPkGcdZZWQpo2ynd6u+D8uqGohLOTN6u0eziH+BA195TZAcoZChWZD2eJO7LcOJriLpWkpnEpcedoC35DNrdaPKdatoEXUojFJL6kVyDO/OdTgiud7HsTCzOgCyrdUGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFROeEPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFROeEPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75EF1F000FF;
	Sat, 12 Sep 2026 07:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199219;
	bh=Ko/ewWzK8Jix9yXSh83JBvPA3IebwRHrtc9PqDLRJrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFROeEPnZkzcZ8sNfe0w/D8RH2DN+bQWyfOGnKGFf5CVwBXoMAJpH3wyvm0/n5aLQ
	 gaKnNv+V+RkiIoTN2r54Bb8BgVO4xqlRTcqZhrUlB843rlueuaBv3rtwUVAtHlwZ4c
	 MNeLg7rU32FToCpCaSimJalijTioMuuZog3Ll8gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0539/1815] arm64: dts: amlogic: meson-axg-s400: enable mipi_pcie_analog_dphy for PCIe
Date: Sat, 12 Sep 2026 08:38:09 +0200
Message-ID: <20260912065701.535297939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 285c6ac1dd613..2baf210a2a40e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
@@ -431,6 +431,10 @@ gpio_speaker: gpio-controller@1f {
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




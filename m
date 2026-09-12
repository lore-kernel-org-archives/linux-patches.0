Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D06D1DB13A;
	Sat, 12 Sep 2026 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223791; cv=none; b=EYEz019iWMGatgcI9gdGtkoxvqvR+T3NYRA9ip0iDkwxJ5e/qN1WtxqBRYOLxJCCTG0ATEOk1+jQZU4asGyZPAQqBOd2PeScE9TX8SzGjpiOnTpgnoidB3hkWF0C0YcpL80tJGQN4MFvLe0Sn1KUoPz8yK9L/aBTmIA9Q6XfUDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223791; c=relaxed/simple;
	bh=GfcTkDAMRgeNnA/FpzD5hYoU+FsbDmMggG3RgWsHGto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOvsPuVLXBS6oHksAVIMiadetUPlsuqyKdgDJyhlIUTmgnHGOvU8PQ4pbz+U0M5vGYLDNT4Jm+58WefRflY2zFxumNtrXp+/ldHYLGLpwrMFm0gSfKr+c+mapWUuoGdWdc0AiiiTWTYEZieNfoygnjTeYXlHgxxGg/WqRXzQQMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaVlttTx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaVlttTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE021F000FF;
	Sat, 12 Sep 2026 14:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223790;
	bh=OMAtg6l7LmaWHjkAhphVS+EEzhlrjOGjDEQ4tlEYT+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaVlttTxCOwppSV+V67YXLffL+6JQqsJCBDPC7erncwKIzxTqxI763A2UoNTiQcwB
	 P1uihzquNwxIwihYOAlbrmqiosQKHdZZ9+iM5BBotG2Es9MMYdnmIWVHBn63JbHhQH
	 Ya0bHM8tz4bbMJy+T4+3g2htfFOAa7vJfs0z4lJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0818/1424] arm64: dts: amlogic: meson-axg-s400: enable mipi_pcie_analog_dphy for PCIe
Date: Sat, 12 Sep 2026 08:54:10 +0200
Message-ID: <20260912065625.621971348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index df16eead2c803..50efa48e85a9d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
@@ -433,6 +433,10 @@ gpio_speaker: gpio-controller@1f {
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




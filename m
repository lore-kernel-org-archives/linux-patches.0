Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B58A42C514;
	Sat, 12 Sep 2026 12:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215884; cv=none; b=TrSSKegSn8EZ3rdba7aZVjbIN/i55UQMSHzwDRt1G+hdVd4k9eA4FQcF0NsezECVJWEpGMi/10FGniHVJVTqtWeQUpEVnJDXLtlEelEEXfwsX1jwITWZDcA3zWVHx9MrWsdGULSVmA+mlFNyUk8CBw7SbzNEHEUraerNDg6DKW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215884; c=relaxed/simple;
	bh=2Y3ybPz/sKio5DC5hYpDC9DF3ehB8UbKNEvtp4PtTIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkzTTBhCPSsMCGsi2lFC13gcmUTGNAMRH9krGAytmA75mo+w7sSct2veY0m20Rbn4zC3LTMTRG1nhFi3n7Z5ftQDwYAkWFQJOF8FeL+IyqTM7/gcnEsfodD+tvToARY1rUj64QY8dgo0S13hnBLrlaeo/Ol/K3iv2kMuRgKQl9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zv9rxuNq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zv9rxuNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922751F000FF;
	Sat, 12 Sep 2026 12:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215882;
	bh=T3t1M887+lkHwR5xssXGp7dUBCfPBvRoDdsqou6yNnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zv9rxuNqxJcMnFpAcg5oMfPl/kz0CuGkztrbA7FVo8bciNaL6j14wQQ6HZ7LxrYuM
	 LzfybZwxrZFBpwUS5R60JxF4D06FxTH5jIT/wi9BqAxVqPDA5a3rLIUrKAp16Mn+lr
	 6/dldg4zUNw3pCr6Sy68sPkqsBkTWHImSxQHl1DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0606/1376] arm64: dts: amlogic: meson-axg-s400: enable mipi_pcie_analog_dphy for PCIe
Date: Sat, 12 Sep 2026 08:50:32 +0200
Message-ID: <20260912065621.042723741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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




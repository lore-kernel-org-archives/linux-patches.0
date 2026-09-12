Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B7A331EAE;
	Sat, 12 Sep 2026 16:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229818; cv=none; b=GxLxcFbuqHkAjAZoMAf+q1AYTyqDMhPjrKJxgtq6JHzXtoHJ4aTaqeCwW2VXkCuDIynbOuYwKYm7lSx36jzoIuAFmQqzOcv1yvmdfoH3iUbp8EcvYWrypZWyDQs6VjG+jcmYrA1mQVj0+ITr8rs4q5uox+ZOgbrx3CDZ3U77gJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229818; c=relaxed/simple;
	bh=qP+cpD7eZyF2Y7Q4B248bGM3c2OP8Y23x0lelgrZBVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/Y6qPsv3LFTj1xBE3LqhxULmne4VS3sgoWhgicCjTQRTSPkts+bsl00qazUsARs9AJBBFoDnRXvPcGeaeka/0OI9m6+emFHaIxH8KaNHJR7OSb7nsPaeOWxCib65x9XRs2ZceAbBkD+75bezvp5J8LChGL+X9Sg/qdU6yXZz+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFcyO9Xg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFcyO9Xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67B51F000FF;
	Sat, 12 Sep 2026 16:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229816;
	bh=kT/WbuejICfM7ud6GFKGD+L7GZPYi+wgCBiD+rXqJLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFcyO9XgWzNAM6G6ld09YpygHDXBJK0CG8zaGohOyCto/gEOTFsMS1l3Kxuub1grc
	 ASi6jiQkdy3UZczxjDw0GOuT3crCrmoLeAC6yuF674tBKYVHMFgetxGavQtB0ojW0R
	 E/gF8l9CWr3ywidfvb95aeasM1uCaprRMDGfN53M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Yan <jerrysteve1101@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0667/1191] arm64: dts: amlogic: meson-axg-s400: enable mipi_pcie_analog_dphy for PCIe
Date: Sat, 12 Sep 2026 08:56:35 +0200
Message-ID: <20260912065603.237533803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 359589d1dfa93..8343dc3061e7c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
@@ -434,6 +434,10 @@ gpio_speaker: gpio-controller@1f {
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




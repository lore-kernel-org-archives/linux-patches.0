Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C87C2DFF08;
	Tue, 17 Jun 2025 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176637; cv=none; b=I1dULl3qc+ugAyBs4m86dpCYgl0wsuPxschDUfUiuEZhR7+LVqplpkAPuWP7EP+iXuIpRWsN2e0rJdiuGgMkZGJXWM9bxxVlSdtqgDV736vzY6oYh4Q+odIFrMoi/aBDGGFgzpIkdqkipUdWExdhtMu+YMGPjZO2m0Dtwmlt8AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176637; c=relaxed/simple;
	bh=PTtefIEL/2+CReQuHVVS5UpSe8K0zvVYC51wWL5pvo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvgDeVL5lEI5NWTZX0nKKc7iqStLGIWKP4WcABuOfX7hXG/5rWlGFbB3c6tVLOnxqCWkhXpKHr/QVuf9sr9AhzSLAsn/2qQMj/fLCu/JMeBFy2WgxYdvpRRh9+WnTnUtoZstduYWyZxlyUlofQZtTOHJ5xXajqdXp1+SZaDfq0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D52knHdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D52knHdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12B3C4CEE3;
	Tue, 17 Jun 2025 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176637;
	bh=PTtefIEL/2+CReQuHVVS5UpSe8K0zvVYC51wWL5pvo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D52knHdWa/4EHmhdwTmN/IYrFHhP9sU62KTinzrzbnp/xpadnxnkqL9ACpIJo/Noz
	 9XRxXjIR/YTFdjzcl1w1sndN2GhKss89mFlua3YA+3Ndgeivcg+6+1VmKgq8c03cTh
	 eSfoGRhx4LKheyEIKI6yhO7DeBmbxtv1CUgjmWZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanth Babu Mantena <p-mantena@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/512] arm64: dts: ti: k3-j721e-common-proc-board: Enable OSPI1 on J721E
Date: Tue, 17 Jun 2025 17:23:35 +0200
Message-ID: <20250617152429.694606916@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasanth Babu Mantena <p-mantena@ti.com>

[ Upstream commit 6b8deb2ff0d31848c43a73f6044e69ba9276b3ec ]

J721E SoM has MT25QU512AB Serial NOR flash connected to
OSPI1 controller. Enable ospi1 node in device tree.

Fixes: 73676c480b72 ("arm64: dts: ti: k3-j721e: Enable OSPI nodes at the board level")
Signed-off-by: Prasanth Babu Mantena <p-mantena@ti.com>
Link: https://lore.kernel.org/r/20250507050701.3007209-1-p-mantena@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index 8230d53cd6960..f7a557e6af547 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -557,6 +557,7 @@
 &ospi1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mcu_fss0_ospi1_pins_default>;
+	status = "okay";
 
 	flash@0 {
 		compatible = "jedec,spi-nor";
-- 
2.39.5




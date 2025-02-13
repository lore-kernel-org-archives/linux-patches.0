Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDB116D4E6;
	Thu, 13 Feb 2025 14:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458512; cv=none; b=utC0Vcr8Owk81sajwcrKKf9HdHPzy0IbO3w4w7eYjD6E1IgW/BkZMDhMSDX2R7u692PT1y7dU5s+9gLOTDzEyXoF7xlE8942VsKVa/TjWBjscqLbWYMwdbG8wQbIyrkbECXzMwmXW2eTuRmceo1d0MraijDPx9i6oKvV/JnQu7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458512; c=relaxed/simple;
	bh=NTnmCWSCdE7g/kT92VqmPlrUePiQYVlY8zaSJcEW5MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrdjqQ8LdYf+0vCZIMZAPvf3gLsKZj0VGS24f/HWYbn9lVqsl9XXeOSCJrx8N9HVpiK7LZBHyqrOCEPoxgc2iWrKgkcKzDUujL6XcJki3lyme3zweDEL4ICPO3Vqj52PSlasMDNcBFUsebTFH+DwZ7UUP5oZn9Bnjznk/55sRXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpWyrPXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpWyrPXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEC2C4CED1;
	Thu, 13 Feb 2025 14:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458512;
	bh=NTnmCWSCdE7g/kT92VqmPlrUePiQYVlY8zaSJcEW5MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpWyrPXNM54ZGRJDPbju5Gz6nqBFyVxcRs4/+fpF9awAUkzWvLGncA6kYqSbKSJoF
	 qftx3dfpXU8maXj+ZOpKq6JGzs/3jGm/Lq2qLoU6kf+OyRchPOdgI1te3xk9SUhHJg
	 Az7tzzdKARaZQOhOkz0DGu3Eknja/akLHU3XRgYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Aurelien Jarno <aurelien@aurel32.net>
Subject: [PATCH 6.12 421/422] arm64: dts: rockchip: add reset-names for combphy on rk3568
Date: Thu, 13 Feb 2025 15:29:30 +0100
Message-ID: <20250213142452.812955663@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Chukun Pan <amadeus@jmu.edu.cn>

commit 8b9c12757f919157752646faf3821abf2b7d2a64 upstream.

The reset-names of combphy are missing, add it.

Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Fixes: fd3ac6e80497 ("dt-bindings: phy: rockchip: rk3588 has two reset lines")
Link: https://lore.kernel.org/r/20241122073006.99309-1-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi |    1 +
 arch/arm64/boot/dts/rockchip/rk356x.dtsi |    2 ++
 2 files changed, 3 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -262,6 +262,7 @@
 		assigned-clocks = <&pmucru CLK_PCIEPHY0_REF>;
 		assigned-clock-rates = <100000000>;
 		resets = <&cru SRST_PIPEPHY0>;
+		reset-names = "phy";
 		rockchip,pipe-grf = <&pipegrf>;
 		rockchip,pipe-phy-grf = <&pipe_phy_grf0>;
 		#phy-cells = <1>;
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -1762,6 +1762,7 @@
 		assigned-clocks = <&pmucru CLK_PCIEPHY1_REF>;
 		assigned-clock-rates = <100000000>;
 		resets = <&cru SRST_PIPEPHY1>;
+		reset-names = "phy";
 		rockchip,pipe-grf = <&pipegrf>;
 		rockchip,pipe-phy-grf = <&pipe_phy_grf1>;
 		#phy-cells = <1>;
@@ -1778,6 +1779,7 @@
 		assigned-clocks = <&pmucru CLK_PCIEPHY2_REF>;
 		assigned-clock-rates = <100000000>;
 		resets = <&cru SRST_PIPEPHY2>;
+		reset-names = "phy";
 		rockchip,pipe-grf = <&pipegrf>;
 		rockchip,pipe-phy-grf = <&pipe_phy_grf2>;
 		#phy-cells = <1>;



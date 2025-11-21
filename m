Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7AC26CE33;
	Fri, 21 Nov 2025 13:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731259; cv=none; b=sgNGQFGC0D/fO+SF9i63GUZEONl0IpRJjZlbTvUzgc10wu9bybNaXGpV22Z2W3Ft1uWqA0Ki/1dqhIM6vpvUTtIKPg+If4NlTbdWCx6JSXQWO+gKqDkHdhEqxqxcz6NmyVDPwPRgj5Ma/7SksTvefxewiXOdO8e1Yl+Sci7RMNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731259; c=relaxed/simple;
	bh=1SnpEB3RqQG44QGH2FnB7wJWUJtXrAMwUjLNAUrxIXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQQY4mJobK280yEQ6ryTwHLI3yGN5Cu6MSoYJncGlsMSmGBgsx42JbsZq3L31gDxDBfqqb+OSA+lk3nhaOwGmpHb817wF0V+wObzd/mz/8sr8WnstDVwryqWiF+UwQqUvSmd1oWKKb1qGa8S1lj4yMHjhPcBpU5+hpauEL6aB5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlwM9q/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlwM9q/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42020C4CEF1;
	Fri, 21 Nov 2025 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731258;
	bh=1SnpEB3RqQG44QGH2FnB7wJWUJtXrAMwUjLNAUrxIXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlwM9q/DIpkL8eaj1lUIXhRDPMlglrZwP8UnKRnGkU5H2vqiyKHeucS/QJZu4ajEi
	 u+RfioBmvjFIcvLkEM4Jr9BkqSOXjbL3CvIUxSy83nYOUxtYbZ1cW75SkrS6gAVCoS
	 i1GckePshcDPD2umKKBIW1/Sh39K4LTBDpUNdtKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 145/247] arm64: dts: rockchip: drop reset from rk3576 i2c9 node
Date: Fri, 21 Nov 2025 14:11:32 +0100
Message-ID: <20251121130159.928164722@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 264152a97edf9f1b7ed5372e4033e46108e41422 ]

The reset property is not part of the binding, so drop it.
It is also not used by the driver, so it was likely copied
from some vendor-kernel node.

Fixes: 57b1ce903966 ("arm64: dts: rockchip: Add rk3576 SoC base DT")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://patch.msgid.link/20251101140101.302229-1-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index c3cdae8a54941..f236edcac3767 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -2311,8 +2311,6 @@
 			interrupts = <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&i2c9m0_xfer>;
-			resets = <&cru SRST_I2C9>, <&cru SRST_P_I2C9>;
-			reset-names = "i2c", "apb";
 			#address-cells = <1>;
 			#size-cells = <0>;
 			status = "disabled";
-- 
2.51.0




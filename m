Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37D024888A;
	Tue, 20 May 2025 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750439; cv=none; b=pq+tSD07Ch9wZVDo2iCsIHtBtpbkWd6ukD0XszkGbQ4/+TO94PUD8rcB6XMdyqGXoB2qT0nwqo68SbNjBgW+3DknSPmyIX6N8Ez4yVb+lXBk54rULi9LCS5VceO/O0B3QiGuqKUN9jPO7j75uEnyZZlgvAuVNmksxluTPb71nrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750439; c=relaxed/simple;
	bh=xEzw+xGbp6EQ9N21IhdS7V2AKlGUl6KvyYIqyw41gVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZp+au+SIRE27SQjL+3zLPqjmZw/PpoPafKZbI/nPbHSQh9OwLnW4Z1D79Dd3VOoIbIIcmvTwaVOWGwysJsdsomwYl1BPju8XO/CfFGzaHVwVT47rG5ZFS3WQvup2z9R9iBoFrqFBzEHu0SWVyWtq089ngu/DMiDKXRuUxmq8lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odBAS5Xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odBAS5Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF95FC4CEE9;
	Tue, 20 May 2025 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750439;
	bh=xEzw+xGbp6EQ9N21IhdS7V2AKlGUl6KvyYIqyw41gVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odBAS5XxYs8Pe5E3dX8HiB1dhwPbxqW3sDWfzC9irF8lcmWU+WlF1YmqBF9OWzHg+
	 CRlW8IkoHTiahQgQNXbpm3WJA5d4snDKRaZOSZ8h/vHeRWn9MtTPr4ShWcGcfbG2cm
	 fzKpQTu5ZxrPFWKx3uBrkR1BW/C2muwK49W+juP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Vincent <linux@tlvince.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 001/145] arm64: dts: rockchip: Assign RT5616 MCLK rate on rk3588-friendlyelec-cm3588
Date: Tue, 20 May 2025 15:49:31 +0200
Message-ID: <20250520125810.598200447@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Vincent <linux@tlvince.com>

[ Upstream commit 5e6a4ee9799b202fefa8c6264647971f892f0264 ]

The Realtek RT5616 audio codec on the FriendlyElec CM3588 module fails
to probe correctly due to the missing clock properties. This results
in distorted analogue audio output.

Assign MCLK to 12.288 MHz, which allows the codec to advertise most of
the standard sample rates per other RK3588 devices.

Fixes: e23819cf273c ("arm64: dts: rockchip: Add FriendlyElec CM3588 NAS board")
Signed-off-by: Tom Vincent <linux@tlvince.com>
Link: https://lore.kernel.org/r/20250417081753.644950-1-linux@tlvince.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588-friendlyelec-cm3588.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588-friendlyelec-cm3588.dtsi b/arch/arm64/boot/dts/rockchip/rk3588-friendlyelec-cm3588.dtsi
index e3a9598b99fca..cacffc851584f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-friendlyelec-cm3588.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588-friendlyelec-cm3588.dtsi
@@ -222,6 +222,10 @@
 		compatible = "realtek,rt5616";
 		reg = <0x1b>;
 		#sound-dai-cells = <0>;
+		assigned-clocks = <&cru I2S0_8CH_MCLKOUT>;
+		assigned-clock-rates = <12288000>;
+		clocks = <&cru I2S0_8CH_MCLKOUT>;
+		clock-names = "mclk";
 	};
 };
 
-- 
2.39.5




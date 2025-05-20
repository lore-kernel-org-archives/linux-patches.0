Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2464722D7A8;
	Tue, 20 May 2025 14:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749996; cv=none; b=RnGNZXiQHEmgoFPBGcTr0ReLFuJ9SSr1KXnvT36RX/xbHV2ng0y5j+gu/vOLIQIJjTPYIPG5gb8SOKqZ/0pqbuNshNalb5sFfNZcwIB/7qyNvaaAsNN725W4dZD3ycoLEom7GAydaBmPd26ccGy2rHHxkFH77bJltxvH7/dQk+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749996; c=relaxed/simple;
	bh=sB+yhKnkHFWXrjFkGOmWx+Rca0jJG8iFNYib6CwQqhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNVb826lErKMIVajWha9omjynQwdzmlsekbHFGT51C5TKE4AzyycWCesTzHSVyFXKf+/xlyoA3Lyw7K2kMb6fYpbdGLzM+FwbimU8i4Xj42cymWEfmjwg94m+3O7f37JGeaMLDz4mdPOgUOBhHNsrWsBVgAwEeVk9HCKYidUUvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6SeXdy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6SeXdy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA32C4CEE9;
	Tue, 20 May 2025 14:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749996;
	bh=sB+yhKnkHFWXrjFkGOmWx+Rca0jJG8iFNYib6CwQqhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6SeXdy5VrhhSF2YND9xL4o0zIhCQW0Em4Cjdy9851YouQo6OwyfbA6IiQSCwHct4
	 otF2p9vjpXCXaALfnEvn8Bs4AyfFkC7EtUSNaPkFIQurJ92OUVd0cPJPCmcleStLms
	 x0N5FH1v2+Lp8Gih0RLIqJCta+zZXAmzYbSOEM7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Vincent <linux@tlvince.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/143] arm64: dts: rockchip: Assign RT5616 MCLK rate on rk3588-friendlyelec-cm3588
Date: Tue, 20 May 2025 15:49:16 +0200
Message-ID: <20250520125810.096947473@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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




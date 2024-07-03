Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482C017DA12;
	Wed,  3 Jul 2024 11:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006285; cv=none; b=JVp2W6O7GIAnRdJvl7/FW2CVosagtsXaOCLDSe55dzhzOWvcAIuCCJivEJeO7Fa86AXz4taiTC2gykJSAGXb1oFUTHKuHmSVp0DoSl7OAL3KjopHxNw6MA03V3xOl3IjHgvVr94/iZjp5AYrNKUJOqhTPSz/Gpewib1xEED4UX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006285; c=relaxed/simple;
	bh=RrUXuXdeQ4dyq9pwpAjUoOpULd0jQkdmm2aR9b5/6Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyBbpNbtDgNTJOKIfaO7uYecdX81KGI/T9H2ckyd7YMGGM/HSAEt9PwmG43FZOKKuUGqQFdxN/6QQDuMvSBB5HGLwvBpBm45sJYhf7JOqISFgYpHdvNuWPbmpY79q+ZeLKXYS+7LVnb7AFhw94f6cKoPlzL55rHeVLb1E068bzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDgY7zBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDgY7zBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D4FC2BD10;
	Wed,  3 Jul 2024 11:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006285;
	bh=RrUXuXdeQ4dyq9pwpAjUoOpULd0jQkdmm2aR9b5/6Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDgY7zBrU3iG3T0mi44ebKc9GLEiOXPcVN6GVzd74Mcp8y/8t989Tcy1u1mr2MTNP
	 ZVjfHwyZzZpRv2/WcnlAvGsnqc0EHJqPfmG5nAPftNSFDUgEoCyUeEaOmzaqyrhXs9
	 /Uqt94wv7QLndZsAwHJBvWDuwbSN9oSMVU9oB498=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/356] ARM: dts: rockchip: rk3066a: add #sound-dai-cells to hdmi node
Date: Wed,  3 Jul 2024 12:41:30 +0200
Message-ID: <20240703102926.500360208@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit cca46f811d0000c1522a5e18ea48c27a15e45c05 ]

'#sound-dai-cells' is required to properly interpret
the list of DAI specified in the 'sound-dai' property,
so add them to the 'hdmi' node for 'rk3066a.dtsi'.

Fixes: fadc78062477 ("ARM: dts: rockchip: add rk3066 hdmi nodes")
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/8b229dcc-94e4-4bbc-9efc-9d5ddd694532@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3066a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3066a.dtsi b/arch/arm/boot/dts/rk3066a.dtsi
index ae4055428c5e1..85b5c506662eb 100644
--- a/arch/arm/boot/dts/rk3066a.dtsi
+++ b/arch/arm/boot/dts/rk3066a.dtsi
@@ -124,6 +124,7 @@
 		pinctrl-0 = <&hdmii2c_xfer>, <&hdmi_hpd>;
 		power-domains = <&power RK3066_PD_VIO>;
 		rockchip,grf = <&grf>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 
 		ports {
-- 
2.43.0




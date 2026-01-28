Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D384D2DC77F;
	Wed, 28 Jan 2026 15:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614750; cv=none; b=OnqCX+liCO2mc8n9CevgpF6saixr5/XftmiaWCpr/106/rXjc15EaH1KCWdUnI6pEcgHRNF0J58w8FoRgqof3VtAn8YKziyqZGNp0WNE1Wpll2bONhNPHfok18aGWtvvIra1QW/i2xB2FhyGvB7KXJQGjL5Jc8N5gAaDDoblN7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614750; c=relaxed/simple;
	bh=vvvvG2OrNLbJr+8ap6/GqiuID6Jwi16Tpkpn39Ho5Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCBNojLFBkQsZiUfnvAJRIHDtd8zVy2bIe4Rnd+nKUz+7gwPprzFVr/8aeZDTq8a+H4JFel8R5muFBX/0QeVU/YdM3pqnDk4zxr5xcs7NdTcMl6rTmcgXt/+8t/nUkImmBQl9e+qryw2y1ocgD3flVVQNTIcdFmfjirSjHTIMLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXiyJpGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXiyJpGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031B3C4CEF1;
	Wed, 28 Jan 2026 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614750;
	bh=vvvvG2OrNLbJr+8ap6/GqiuID6Jwi16Tpkpn39Ho5Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXiyJpGHqnJIXjmdqxxSXHognmDU7CXgxQj0Q+BCVzNAM2P5WooklHHkkHGh9YdZK
	 W//47v1lFmprRaFHPgSAQIgmGWw4rslLfyrvY3XV8dw5MYGe1IOzNe1PcLO1UV8KKI
	 H98iB5VYQ+Z2XnHLchjawH/8IMA7hVACHgVtmxnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/254] arm64: dts: rockchip: remove redundant max-link-speed from nanopi-r4s
Date: Wed, 28 Jan 2026 16:23:26 +0100
Message-ID: <20260128145353.064647992@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit ce652c98a7bfa0b7c675ef5cd85c44c186db96af ]

This is already the default in rk3399-base.dtsi, remove redundant
declaration from rk3399-nanopi-r4s.dtsi.

Fixes: db792e9adbf8 ("rockchip: rk3399: Add support for FriendlyARM NanoPi R4S")
Cc: stable@vger.kernel.org
Reported-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/6694456a735844177c897581f785cc00c064c7d1.1763415706.git.geraldogabriel@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
[ adapted file path from rk3399-nanopi-r4s.dtsi to rk3399-nanopi-r4s.dts ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
@@ -73,7 +73,6 @@
 };
 
 &pcie0 {
-	max-link-speed = <1>;
 	num-lanes = <1>;
 	vpcie3v3-supply = <&vcc3v3_sys>;
 };



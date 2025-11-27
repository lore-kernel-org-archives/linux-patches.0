Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569F528C84D;
	Thu, 27 Nov 2025 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255155; cv=none; b=JhUZdvjPkAz+9twKuGJg7h0kMFkYNXvxPjl6zWTDQRUvNnXkzR3GX5SwMPTYRsg7/Wv32bjJ7aJDQUpsv5L6rNtEklXttZt9UOOMLia+CFpD1U2tNuUPdrKO5FHswhRFYjt3GM+xkKY77cEToDJcyRZBESoaMu29uhTtZz+Qa/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255155; c=relaxed/simple;
	bh=dLTtjFAAtg2oeaK6fIVsmM19OTQEmqvN6m3QeUku7Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex0DH9tafirn/ACbMLCzrdF2qk5O1sCQEu8uQxbr9HCP96iUBNUJhEzFwV4RBxQXd9rCokQqZuQGQPFa/GsndEDxbJLI9AYzJyEZGy67TBR2P3MwvUb4vxJwtf3Xwe/6NxhTNq7ApJrvRXjWsYry2/cLXKt+uTR4caUFDmGocD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBlaKb43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBlaKb43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E3CC4CEF8;
	Thu, 27 Nov 2025 14:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255155;
	bh=dLTtjFAAtg2oeaK6fIVsmM19OTQEmqvN6m3QeUku7Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBlaKb43QVXyOjHjk4pOL906FLQ4LC9P3g7/jiewooziK2a4obUNyvUVV69GHWWM0
	 KdB9OlnjoKYrwlY4niPWVqdeLGEGn/W+0JTII/USyFfPJAEIJW48ZZnPEiDsIQUO58
	 NGpWUmKmiA0eLaTQreR0TNnz2LUy/wFe7tS4iXpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykola Kvach <xakep.amatop@gmail.com>,
	Michael Riesch <michael.riesch@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 006/112] arm64: dts: rockchip: fix PCIe 3.3V regulator voltage on orangepi-5
Date: Thu, 27 Nov 2025 15:45:08 +0100
Message-ID: <20251127144032.948457947@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Mykola Kvach <xakep.amatop@gmail.com>

commit b5414520793e68d266fdd97a84989d9831156aad upstream.

The vcc3v3_pcie20 fixed regulator powers the PCIe device-side 3.3V rail
for pcie2x1l2 via vpcie3v3-supply. The DTS mistakenly set its
regulator-min/max-microvolt to 1800000 (1.8 V). Correct both to 3300000
(3.3 V) to match the rail name, the PCIe/M.2 power requirement, and the
actual hardware wiring on Orange Pi 5.

Fixes: b6bc755d806e ("arm64: dts: rockchip: Add Orange Pi 5")
Cc: stable@vger.kernel.org
Signed-off-by: Mykola Kvach <xakep.amatop@gmail.com>
Reviewed-by: Michael Riesch <michael.riesch@collabora.com>
Link: https://patch.msgid.link/cf6e08dfdfbf1c540685d12388baab1326f95d2c.1762165324.git.xakep.amatop@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
@@ -85,8 +85,8 @@
 		gpios = <&gpio0 RK_PC5 GPIO_ACTIVE_HIGH>;
 		regulator-name = "vcc3v3_pcie20";
 		regulator-boot-on;
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
 		startup-delay-us = <50000>;
 		vin-supply = <&vcc5v0_sys>;
 	};



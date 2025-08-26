Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F369435A299;
	Tue, 26 Aug 2025 14:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218757; cv=none; b=m1JpVHdC7Y1+vGtZzkx2gX0cEwruSQx3SCw1pyzIul4hvIwG3AP2jei7aNu6ZBhqCvsQhBXddKesUZjkRmMK/sWC6BifRl5ZkxVsExQoBowLWjyUEBrH2Na7VNnZzo4+eTQkglJVw120Ueb8BouU+U/gOEHJdccv5+9rtXInUao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218757; c=relaxed/simple;
	bh=VbpUXZF1LZ9yGeh4PJWMHgL8n1QEUGSD3551q/HjqyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/2uJ4ueNdbe6BYP3AfrXRd/SCWbgadToCh5IBftd/5WpyWRDvYz8//4z2UUm5Rbs2+PHhhhgD/HOYJHqRGIQ+fMSwMlz0voPupq1FZZWMEvIJm33z+QA7Xcaj/e5vNTUcCcu7fM5yK7HpDARLs50Kh3D/8tgu3TvTsYVobUhww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igc2RYNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igc2RYNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8481FC4CEF1;
	Tue, 26 Aug 2025 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218756;
	bh=VbpUXZF1LZ9yGeh4PJWMHgL8n1QEUGSD3551q/HjqyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igc2RYNWJ9rekJIgameIm9T593vo3EKkuhmKV4NYSxX4r1ZRoq7H7Vrz4LtAjKmzl
	 fsjuX55PkYdaIjtbLnM1yz3H22QrNMvepMn1jOoWICfwXoRK/U5Xb604HWevjO9sqB
	 E2Z4cBf0nowNesXj+icv6nyoHK0oUyBqCaPz3dfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Annette Kobou <annette.kobou@kontron.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/403] ARM: dts: imx6ul-kontron-bl-common: Fix RTS polarity for RS485 interface
Date: Tue, 26 Aug 2025 13:06:46 +0200
Message-ID: <20250826110908.691117094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Annette Kobou <annette.kobou@kontron.de>

[ Upstream commit 47ef5256124fb939d8157b13ca048c902435cf23 ]

The polarity of the DE signal of the transceiver is active-high for
sending. Therefore rs485-rts-active-low is wrong and needs to be
removed to make RS485 transmissions work.

Signed-off-by: Annette Kobou <annette.kobou@kontron.de>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Fixes: 1ea4b76cdfde ("ARM: dts: imx6ul-kontron-n6310: Add Kontron i.MX6UL N6310 SoM and boards")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-kontron-n6310-s.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul-kontron-n6310-s.dts b/arch/arm/boot/dts/imx6ul-kontron-n6310-s.dts
index 4e99e6c79a68..9b347029c2f6 100644
--- a/arch/arm/boot/dts/imx6ul-kontron-n6310-s.dts
+++ b/arch/arm/boot/dts/imx6ul-kontron-n6310-s.dts
@@ -168,7 +168,6 @@ &uart2 {
 	pinctrl-0 = <&pinctrl_uart2>;
 	linux,rs485-enabled-at-boot-time;
 	rs485-rx-during-tx;
-	rs485-rts-active-low;
 	uart-has-rtscts;
 	status = "okay";
 };
-- 
2.39.5




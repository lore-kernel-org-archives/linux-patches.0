Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D2A334C1D;
	Wed, 20 May 2026 16:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295667; cv=none; b=eli6HwsJS8JQUJqK6Q+ezA7g8xKEWjoIlYsY2/xfs3u28P7xaF/uUVGnFBQqZQfZiVh33caMvW6oIHZf0ImcbFB386cTkuwFagrtmxhd4m4lYnuIqa09kczIST2PkoisZwUvMXNTrM5n8FjFepjRfMsd+iiWTK3a7783ZjcmvCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295667; c=relaxed/simple;
	bh=RP2ccKYokauqL/Y2fTsxisIl+jsO62VBOfVqMcdPKuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaEfHGI0BYVWnQv0DkI9SJ94iERcIS+JqZqcYdTmYPMJwrpYtJ3PEJV65+XBm8A45DOlGDVmALC3mTvkQby8Ia38fi4oweVqCRO9JIdqxUU+lFblraOL6fYONDYdITMzk/A/MiVk0untJmbp1M+CEoTrj+Q/VOqPRh4s6koSvrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idaYMhUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idaYMhUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBCC1F000E9;
	Wed, 20 May 2026 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295666;
	bh=dEl5hT9sYsz4hMO9vdvY1oxg9rNsgfyi2zZ33XrI7k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idaYMhUDxyGTK+2jWsllhrqE1EeD3dd11XUgqAcBi/ycO/KD9zdHkrO0COF3+mnZ/
	 S1LOEZ8jDjNE4p9aEUN6dODOdngPl5YSmRR92vI+OJ2aFDKSTcN3ejbLYCtrCVO72z
	 PG34Cx+kbwuCgDbGM/fVnO0IEhJE5oKLVMWLstHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0505/1146] riscv: dts: spacemit: drop incorrect pinctrl for combo PHY
Date: Wed, 20 May 2026 18:12:35 +0200
Message-ID: <20260520162159.618426226@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit c68360c0d636dae71f766b7b296ddfcf2827ccc7 ]

The combo PHY on the Banana Pi F3 is used for the USB 3.0 port. The high
speed differential lanes are always configured as such, and do not
require a pinctrl entry.

The existing pinctrl entry only configures PCIe secondary pins, which
are unused for USB and instead routed to the MIPI CSI1 connector.

Remove this incorrect pinctrl entry.

Fixes: 0be016a4b5d1b9 ("riscv: dts: spacemit: PCIe and PHY-related updates")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://lore.kernel.org/r/20260322202502.2205755-1-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
index 51f6c6a774b0d..48c034736aa5a 100644
--- a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
@@ -81,8 +81,6 @@ usb3_hub_5v: usb3-hub-5v {
 };
 
 &combo_phy {
-	pinctrl-names = "default";
-	pinctrl-0 = <&pcie0_3_cfg>;
 	status = "okay";
 };
 
-- 
2.53.0




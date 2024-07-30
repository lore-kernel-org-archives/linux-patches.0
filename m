Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29950183CCD;
	Tue, 30 Jul 2024 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355670; cv=none; b=Bt33kMl+yyfmdNzTiakUkK3nDzeSeNsWUH4Cls50CwHY9kYOlDebaLeLXEpg8jO+kHeJ91jgm9a6qcYn4tKh9YT2jirUDVUcMvBabMnfHH8uCrJli7RzW5UWsTFfVP5eVngH4lGnwCe58j7nlJ+pALtRU9DSSVTueIPD17qCcOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355670; c=relaxed/simple;
	bh=hW+XVcRNR6gpVVUbK1a0mQioRwtSND7oe87caI8MAIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYzMZb8i03q8DFnF7ZQZ+mgYJ+bKq91Tf/jwALBYGuYFCj3GR0TRaqpsMNacKQiIFqUiAHp5l7Blm++s6flbs7tt3JU/3pM7dlB9bUjhvCKNcdZqs7WIhaRJ858ucYe8PB6UUySCgvI63T299sCUiqqHQscsiJ23pVA8V1Z+CJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cE4zgV02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE4zgV02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94234C32782;
	Tue, 30 Jul 2024 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355670;
	bh=hW+XVcRNR6gpVVUbK1a0mQioRwtSND7oe87caI8MAIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE4zgV02zla7qW/dst/lyRyaVkhfzh6WOyDDbS8We9llHfaafo06p4FHQApTmPEaO
	 1illgOrq8G1ygDV0rxGiSBhcoLZdUdtxC1MRffhiiMHDK6YTRwyngiowdNByVyLa2v
	 0eVsIqYFTwB7KX8ZC2YHbaxBuRfdA49Bf4kWCUxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 078/809] arm64: dts: ti: k3-am642-hummingboard-t: correct rs485 rts polarity
Date: Tue, 30 Jul 2024 17:39:14 +0200
Message-ID: <20240730151727.721129000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 9dcc0e1065f3c40d0b2ad79a858bb4ebaba33167 ]

The RS485 transceiver RE (Receiver enable) and DE (Driver enable) are
shorted and connected to both RTS/CTS of the SoC UART.
RE is active-low, DE is active-high.

Remove the "rs485-rts-active-low" flag to match RTS polarity with DE,
and fix communication in both transmit and receive directions.

Fixes: d60483faf914 ("arm64: dts: add description for solidrun am642 som and evaluation board")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Link: https://lore.kernel.org/r/20240504-ti-rs485-rts-v1-1-e88ef1c96f34@solid-run.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am642-hummingboard-t.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t.dts b/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t.dts
index 234d76e4e9445..5b5e9eeec5ac4 100644
--- a/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t.dts
+++ b/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t.dts
@@ -282,7 +282,6 @@ &main_uart3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_uart3_default_pins>;
 	uart-has-rtscts;
-	rs485-rts-active-low;
 	linux,rs485-enabled-at-boot-time;
 	status = "okay";
 };
-- 
2.43.0




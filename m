Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543A6265602;
	Tue,  8 Apr 2025 11:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112543; cv=none; b=Na8oH4Aa5mEUoE5aXucrBP/UgDuiF5amFzeaVoUvSRtTiXTsj7YATMcy8FFOpuolYcUSf5IjeY+YnlBddH1yL1n5Sp3Gmcn8HLS0CvWKDvdzrKDHUvqr5XESx76bU7r0D2vVL7ascVD1+dOC+0f0rE4iBI3ozaiCAzDg/j9f6LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112543; c=relaxed/simple;
	bh=XbS8tdEbhm08vNwYVjNGzTEpXeF56wr27FRZCW3XbcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSgS+xblyVLB1g5nSTHABlUG5WV34gf658ycH9WiVt4w7AxjEx8xBmFuU6TcIBZ4L70qQB3o63gz0kdZqvgP3iVbcRlK/5lMg4G+KcyGGhsvLIbQTDBkhmzBp5Ibry12+/Ole4c4czW+llXlluod7UFRf7c7C1e/O2uV+EZ7Fag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04tx01zl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04tx01zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D666DC4CEE5;
	Tue,  8 Apr 2025 11:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112543;
	bh=XbS8tdEbhm08vNwYVjNGzTEpXeF56wr27FRZCW3XbcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04tx01zlD+FEbpHYnDTAUa3+64Nt1Si2IhQzNv8ya2l4GnSdR93I0bvh+b2CdYnDY
	 10uTmzWuD1rhkswMpRwot6KaugOFfstyRicm5SbzvP+DlEuiO05vWBGQ+wa54qbC2x
	 3wEV4+4KxXAj/VFUZq+fqvFAqhXUGhF1k1gmJJjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Klaassen <justin@tidylabs.net>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.15 107/279] arm64: dts: rockchip: fix u2phy1_host status for NanoPi R4S
Date: Tue,  8 Apr 2025 12:48:10 +0200
Message-ID: <20250408104829.232928339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Klaassen <justin@tidylabs.net>

commit 38f4aa34a5f737ea8588dac320d884cc2e762c03 upstream.

The u2phy1_host should always have the same status as usb_host1_ehci
and usb_host1_ohci, otherwise the EHCI and OHCI drivers may be
initialized for a disabled usb port.

Per the NanoPi R4S schematic, the phy-supply for u2phy1_host is set to
the vdd_5v regulator.

Fixes: db792e9adbf8 ("rockchip: rk3399: Add support for FriendlyARM NanoPi R4S")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Klaassen <justin@tidylabs.net>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250225170420.3898-1-justin@tidylabs.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
@@ -117,7 +117,7 @@
 };
 
 &u2phy1_host {
-	status = "disabled";
+	phy-supply = <&vdd_5v>;
 };
 
 &uart0 {



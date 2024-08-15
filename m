Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AE91714A1;
	Thu, 15 Aug 2024 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729920; cv=none; b=Jr2earafgaKVGcB/Tzd/zTFoLRGCxwZff5Xp7U8mE+6z+UfbqiBqQbZry1qPQEger+U1UmbkdP2/iXGgGtmwtbeXTDg+0NSG+Rb7EcpAigbx6xfqCTzZlv2ThNmGMmvMOLFol8OTEmqdc0g0r9mfa3y5bIRAg7H7ihlc7sr4N/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729920; c=relaxed/simple;
	bh=AlSi/MaBItUvEpvtObuVL6xoSlF5Vrs7s5orFYyMcc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaGNau3P6M/plR0qnGB3RZQQmhZVEOQdiFX/9SArcU+CQ0Fxv6GUj9oPu+qxTBmfbbf4Jt4oIa15M6RITy/wMAgFTOzI6qpPxgwFPtFi0vwE72LzIfDXkONWrH+PyeNoyxK4E4+MTONOQiybYeIJHi6/VEFB8UyztXCbWfjdbwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACbg+gSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACbg+gSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58152C4AF0A;
	Thu, 15 Aug 2024 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729919;
	bh=AlSi/MaBItUvEpvtObuVL6xoSlF5Vrs7s5orFYyMcc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACbg+gSwu4yYtmMeZdQyS9WaIVpQnAocbW3e0X9COAwG2L5hwQtvui853S0UQLaK5
	 Eu2txhElttt8z/55bYi1hx0MdpJPpZLB7OOIu3AtmEPe9edifCwNP8NbamM7YJ1EFn
	 CRMXUb30oIggUFSg1pe+xtpMO1M5/MNzD6xVRPL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 249/484] MIPS: Loongson64: Remove memory node for builtin-dtb
Date: Thu, 15 Aug 2024 15:21:47 +0200
Message-ID: <20240815131951.016477722@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit b81656c37acf1e682dde02f3e07987784b0f3634 upstream.

Builtin DTBS should never contain memory node as memory is
going to be managed by LEFI interface.

Remove memory node to prevent confliction.

Fixes: b1a792601f26 ("MIPS: Loongson64: DeviceTree for Loongson-2K1000")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
+++ b/arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi
@@ -23,14 +23,6 @@
 		};
 	};
 
-	memory@200000 {
-		compatible = "memory";
-		device_type = "memory";
-		reg = <0x00000000 0x00200000 0x00000000 0x0ee00000>, /* 238 MB at 2 MB */
-			<0x00000000 0x20000000 0x00000000 0x1f000000>, /* 496 MB at 512 MB */
-			<0x00000001 0x10000000 0x00000001 0xb0000000>; /* 6912 MB at 4352MB */
-	};
-
 	cpu_clk: cpu_clk {
 		#clock-cells = <0>;
 		compatible = "fixed-clock";



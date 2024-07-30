Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8898318801C;
	Tue, 30 Jul 2024 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358309; cv=none; b=NoHsSp/qA77sByRQaGS4HcKACmUNKwHUUul4ypzuw+Mout16UfV44ouC6dZU+QNG+t+9PU5RCv5fd0N+QV8+xt8wCgGGWJ5Bj9LwbuD1e9nzPxA3kzAKnWFLJTuF5LngO6ifkq7eXwAu9nRQVXn4jLUQBcuYnAd51X4jcugW4tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358309; c=relaxed/simple;
	bh=V7VZYk4F7qfQpjTk1cVPkPFc+uyjeOX7nPxuuzqKYiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf+nQZsiUcHiAaXwSltCVwTTaJgGiQY3b2403h6n81ZMDH/pqb1oUMm5QWYYK8eagCeXvGdhzQgBBdsh6rbB3GjprZ7NhEB8EuyZlSKkV887n10DR/fU2+s6H2Bo/cuV8YK9uhK6NH+QzoURL1UTDyMm625XXboFHvUrCSo7wlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azsK/GT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azsK/GT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7A4C4AF0F;
	Tue, 30 Jul 2024 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358309;
	bh=V7VZYk4F7qfQpjTk1cVPkPFc+uyjeOX7nPxuuzqKYiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azsK/GT/1h6XEHCz9i3xoL7EIJcOEItX7DA+BAR0QiDQDgEWRSRV69f5byaGkEgvx
	 jWwFDIlNEOgo4sdUAHfRWi5hw1AFGmNTRo8P9RgB4vWVk/S0pvXpDeyhMC13PuRrBp
	 eYGzGNx/Ksmrq7mA1Ocw/bHsX65P17uI2Jt2trF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 376/440] MIPS: Loongson64: Remove memory node for builtin-dtb
Date: Tue, 30 Jul 2024 17:50:09 +0200
Message-ID: <20240730151630.498082531@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



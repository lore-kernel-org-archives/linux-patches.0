Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD2B46D2A4;
	Tue, 21 Jul 2026 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654000; cv=none; b=P1k9YBN98hfmB7wA78nyNrM6pGSN/1UJnFevzvKOi/9tVjkc3L2KgAK0Hh3c1Uaug9O9GkYXAIhHy6QTm2sqxBKM4sOqhTPFepYUi0e3SP2dwkAw2iVjmGT3CWKv3ClPgqWIOYruET0HKjwZuHHKjZBdG5WgMbhkM/NRdsDcXfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654000; c=relaxed/simple;
	bh=x33vk+UIRGzB+UYqyzUxJhyEo77BvDCbU43pQL6HEEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZZkpKL/XsaPzMpPNWTXO2YNbbm4tiav5K7+KtG+smjLpAWdEGK5r109ZtPFApKai8/dsKi02WzXoq3Ds8q3/u6xR1pJ6ZMl8MieyHqyvE4TKVduq8Aqnm9z3R8QMXCr4+iPtYD00IpydbcOmdTH55rj+VJZMjusft4Uxfjw+ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1z7cYyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1z7cYyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27851F000E9;
	Tue, 21 Jul 2026 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653999;
	bh=zWCcxvFHITMvTtrOOZdG8f0RCMZ+8TY7+kiru29mhN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1z7cYyB8APnLS7TqTX9cUO8CDqwy21JD01g/pwrSNynR7K/v8wXD+wYP0psH0jn5
	 sgBuRXSJsRo1LGKKaaNTZ/oAtCPy5f5oqVJwWPo/bZJ4/QI9QBrNecWns3HvyB7OMj
	 etm9jIU50LCJSTGP0Bez5FduD8neMTRTxFJiZHFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 7.1 1539/2077] arm64: dts: ti: k3-am62a7-sk: Add bootph-all tag to vqmmc
Date: Tue, 21 Jul 2026 17:20:12 +0200
Message-ID: <20260721152629.076111203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit d8fe8442366ffd8306575028bda92389d0dfb674 upstream.

Add bootph-all property to vqmmc voltage regulator node and its
corresponding pinmux node to make it available during all boot
phases. This allows to run tuning early in SPL stages of boot.

Fixes: 8f023012eb4a ("arm64: dts: ti: k3-am62a: Enable UHS mode support for SD cards")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Link: https://patch.msgid.link/20260324140247.1200631-1-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -154,6 +154,7 @@
 		gpios = <&main_gpio0 31 GPIO_ACTIVE_HIGH>;
 		states = <1800000 0x0>,
 			 <3300000 0x1>;
+		bootph-all;
 	};
 
 	leds {
@@ -407,6 +408,7 @@
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x07c, PIN_OUTPUT, 7) /* (N22) GPMC0_CLK.GPIO0_31 */
 		>;
+		bootph-all;
 	};
 
 	main_ecap0_pins_default: main-ecap0-default-pins {



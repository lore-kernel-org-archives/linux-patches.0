Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4726C471271;
	Tue, 21 Jul 2026 18:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658464; cv=none; b=F2eygxrbza14m1lg4hmHTEmFg74jJ73hx5dHZ6mfo0CjF55PxGpsVA8O4M3//H4v9i5ZdClYnL36ibLbX4o6OTsNuUHBPwIxpb9t14VQ0CsllkwOe5zqEfMm/+ehYk6pTGzb0t/GcLyCNAWZ8Y8lTNRmCO9O/NPKsMiXmc4rqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658464; c=relaxed/simple;
	bh=QcBRE+g9IbqJr9ukJAro97JLCwqs/4MYLUE0FdZlruk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVce7iWZJg/VAZlS/6HyRNo2sn8rszzAdS7hNzAezqU3EwatFVFvIdU/oqJfc18qcm/NF3ox3ckZ91HafwM7aXokfktTefmzT/b4UUrDfhC7Zb5DIJE2KsI+f3PsnsSLbIwzZILy53g6FWcELBlq9Ywm6Pf/PB+riZ426HWzewo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNxz0Vsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNxz0Vsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53801F000E9;
	Tue, 21 Jul 2026 18:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658463;
	bh=SN0uL3QA+QtinE90X4A4z9SRtuAoWceUD6JfNhVnMns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNxz0Vsd2Qp8CGjFxGrZczTYb6wx7cyPrv9ti0VsKho+ykGuDPB04pA6tbz9agUdJ
	 xsZK0HfXGHR/U630JDjvEx7dXHGxouSNXWP86k23Rzy+z8GHqakmVYvHJvnt88F0Wp
	 6aCTsZpMcSrZCh+W1D6ZGutYgBRigqeUL9x/I7W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.18 1116/1611] arm64: dts: ti: k3-am62a7-sk: Add bootph-all tag to vqmmc
Date: Tue, 21 Jul 2026 17:20:32 +0200
Message-ID: <20260721152540.521773526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -396,6 +397,7 @@
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x07c, PIN_OUTPUT, 7) /* (N22) GPMC0_CLK.GPIO0_31 */
 		>;
+		bootph-all;
 	};
 
 	main_ecap0_pins_default: main-ecap0-default-pins {



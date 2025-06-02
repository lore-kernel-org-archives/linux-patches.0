Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CF4221DA2;
	Mon,  2 Jun 2025 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872206; cv=none; b=gGvbHW6JJccjKsAbTfec23OxYJab5VmMMqSpiBqJHw/K4u+3RSEu78QGk2cphKqa5BjoGbKfhT0VGJPKMkQbnUu5Als6gRF/4/ITB/yDaK6B8eQ5NhmFk798wQ9jZ8zLeVPES0jdX5rHtYRRwqmlfidIuQWdGCc0v5vkCSaEcZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872206; c=relaxed/simple;
	bh=ZHPzj8Wf7Mz1AimGys67VEYkpYMnkbnoGZJdsPF/UAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLeUTr3rv+mcCN0l3p5FywoVnvJVaQN3VyJ6ET99Jwuq8nTzAUxV+OcJvXOAm5DlwiR8uUH5XUk8fDWXr0tjrLCaod4FM6n/RsnAut0EfqEV9mUerrBUEENxeYAn3Eea+rXy9Lgg4FSO/uAdm7Dzsdiv8Lrq9T0hyMf5U8MmNnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYhaX9zH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYhaX9zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D252C4CEEB;
	Mon,  2 Jun 2025 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872205;
	bh=ZHPzj8Wf7Mz1AimGys67VEYkpYMnkbnoGZJdsPF/UAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYhaX9zHujLJuyT531X/7NukDxDerJZvjL8CeBUjQIcowxsdj3/NEsNsA5fSor+TT
	 gkUk3rfAZHaP+DYE89XYFOMES8BhE3/AeXgziPcC9tuNBt3qeYlYlNm4aJxXztAbYj
	 nte6QweV0Bf12SEa4W+vC1paLfXOJC1sBSqY89mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Neha Malcom Francis <n-francis@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.15 34/49] arm64: dts: ti: k3-am68-sk: Fix regulator hierarchy
Date: Mon,  2 Jun 2025 15:47:26 +0200
Message-ID: <20250602134239.281183164@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

commit 7edf0a4d3bb7f5cd84f172b76c380c4259bb4ef8 upstream.

Update the vin-supply of the TLV71033 regulator from LM5141 (vsys_3v3)
to LM61460 (vsys_5v0) to match the schematics. Add a fixed regulator
node for the LM61460 5V supply to support this change.

AM68-SK schematics: https://www.ti.com/lit/zip/sprr463

Fixes: a266c180b398 ("arm64: dts: ti: k3-am68-sk: Add support for AM68 SK base board")
Cc: stable@vger.kernel.org
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Reviewed-by: Neha Malcom Francis <n-francis@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20250415111328.3847502-3-y-abhilashchandra@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am68-sk-base-board.dts |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am68-sk-base-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-am68-sk-base-board.dts
@@ -44,6 +44,17 @@
 		regulator-boot-on;
 	};
 
+	vsys_5v0: regulator-vsys5v0 {
+		/* Output of LM61460 */
+		compatible = "regulator-fixed";
+		regulator-name = "vsys_5v0";
+		regulator-min-microvolt = <5000000>;
+		regulator-max-microvolt = <5000000>;
+		vin-supply = <&vusb_main>;
+		regulator-always-on;
+		regulator-boot-on;
+	};
+
 	vsys_3v3: regulator-vsys3v3 {
 		/* Output of LM5141 */
 		compatible = "regulator-fixed";
@@ -76,7 +87,7 @@
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3300000>;
 		regulator-boot-on;
-		vin-supply = <&vsys_3v3>;
+		vin-supply = <&vsys_5v0>;
 		gpios = <&main_gpio0 49 GPIO_ACTIVE_HIGH>;
 		states = <1800000 0x0>,
 			 <3300000 0x1>;



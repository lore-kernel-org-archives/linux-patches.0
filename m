Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF271223DEF;
	Mon,  2 Jun 2025 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872873; cv=none; b=bYCvQnvCSG8kawDAPPnkrqBk+78ii+BsYz73J/wYzhSkMPb32SDJtorVqpe2uBKzIWPW1uSJF9toM5dL7p0P/jzkGGCfaQuz9KYDYZHI6mW+WYN2q1zsxuvVDQzhEx1x90yb4peniF9Air0s3o3nT0rpczqOG9ymqRLgjvKjN54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872873; c=relaxed/simple;
	bh=W+jtXM0uDiHjILujSeFQds8dHndSWX4EAcSt01IacSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwaJU8zC7h0+y9KbO2+wUfDZ2wE8aYALlCgSF6afdkmplFtHx3SMc4RcQcRQ5PXqy0f+6/SKlYbkdEbeWwrP15bLKcykV75T7VrJbz9VCgIFqqZFbpO/5TiJ2MHZb9L2InJVr6eAG3fVfIlMUvoF3zc30c9XE9A88Fza1sFasj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kArRzM83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kArRzM83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE1C4CEEB;
	Mon,  2 Jun 2025 14:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872873;
	bh=W+jtXM0uDiHjILujSeFQds8dHndSWX4EAcSt01IacSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kArRzM83WyUT1yvqpzntWmoQsIoO/CwDecPahEdQ6e/MwTeDKtq8EWwfCkGFRquip
	 sBEAz+IZDkUnKmIehU0jeryVcHFI+/IEMJP8c3/mxA48CoIFZOWpeBWN9bE+29ebmU
	 K/GOSSLuV3s9u2KXW/iKXiXyol7oVEagVYmRZzMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Neha Malcom Francis <n-francis@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.12 22/55] arm64: dts: ti: k3-am68-sk: Fix regulator hierarchy
Date: Mon,  2 Jun 2025 15:47:39 +0200
Message-ID: <20250602134239.150019619@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



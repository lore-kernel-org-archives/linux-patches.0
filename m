Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EBB2FB97B;
	Sun,  7 Jun 2026 10:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829084; cv=none; b=ddHvsMD4IBw/l/ycEwA+ndvKULvh72e95tYcFNr8KSNHE01sD6UAQvIaRppIwUsSqXCCIP97IJQgCVlcYCEH+HkmZ866kq0cJtYcrnH56XK4drNm+s0IxK4SrA8gAHR5Ax92pylS3/H2g5EtwjTOAX97wrYpVsTnUBs6w9HYq60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829084; c=relaxed/simple;
	bh=JlETVc5NfEd59IdwbpCUq2xjEuPhzSaKPGzcPcgBa6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZn49Wqzmb7ua1emEX/BgN2SHqzz1fulKpQwREPhQbXR78cGeHwRnsRm0nK5tLE8g0o031DN1bumC+r69T1QEDHlTt/z1wNd2E2pZ+akw+WIiAzNu6gS9jPWIvVhTO7E37G6ftnIYb2tDEVIRcF7xH/X5i21D1G+nZ/MqkcfE4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnhpp54q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnhpp54q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D264C1F00893;
	Sun,  7 Jun 2026 10:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829083;
	bh=qUsirmbA+WgwVVtrWXsBI4CsWiM6aHO8ryuivUdAKbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnhpp54qDUJOOS+aOMP+YorUPIbeHxctikyHN+7SiCGDlaXVtgg8Hjlm3KlP6aGLm
	 JGgim0XbReV0fyBsPVkOqPc+GQY+ihyaT/4+0U8lV+HDh/ar5UUKgUpf0t69zfjdPu
	 Jo3xxNgc5x+wPKFn3u18JmxW3X8pHKVYqIob8Gaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hang Cao <caohang@eswincomputing.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 7.0 244/332] dt-bindings: usb: Fix EIC7700 USB resets issue
Date: Sun,  7 Jun 2026 12:00:13 +0200
Message-ID: <20260607095737.004756508@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Hang Cao <caohang@eswincomputing.com>

commit f1ecb0e563595d4ba9a3b8e39ed52a3dc2d8e328 upstream.

The EIC7700 USB requires a USB PHY reset operation; otherwise, the USB
will not work. The reason why the USB driver that was applied can work
properly is that the USB PHY has already been reset in ESWIN's U-Boot.

However, the proper functioning of the USB driver should not be dependent
on the bootloader. Therefore, it is necessary to incorporate the USB PHY
reset signal into the DT bindings.

This patch does not introduce any backward incompatibility since the dts
is not upstream yet. As array of reset operations are used in the driver,
no modifications to the USB controller driver are needed.

Fixes: c640a4239db5 ("dt-bindings: usb: Add ESWIN EIC7700 USB controller")
Cc: stable <stable@kernel.org>
Signed-off-by: Hang Cao <caohang@eswincomputing.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260415064238.1784-1-caohang@eswincomputing.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/eswin,eic7700-usb.yaml |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/devicetree/bindings/usb/eswin,eic7700-usb.yaml
+++ b/Documentation/devicetree/bindings/usb/eswin,eic7700-usb.yaml
@@ -41,12 +41,13 @@ properties:
       - const: usb_en
 
   resets:
-    maxItems: 2
+    maxItems: 3
 
   reset-names:
     items:
       - const: vaux
       - const: usb_rst
+      - const: usb_phy
 
   eswin,hsp-sp-csr:
     description:
@@ -85,8 +86,8 @@ examples:
         interrupt-parent = <&plic>;
         interrupts = <85>;
         interrupt-names = "peripheral";
-        resets = <&reset 84>, <&hspcrg 2>;
-        reset-names = "vaux", "usb_rst";
+        resets = <&reset 84>, <&hspcrg 2>, <&hspcrg 4>;
+        reset-names = "vaux", "usb_rst", "usb_phy";
         dr_mode = "peripheral";
         maximum-speed = "high-speed";
         phy_type = "utmi";



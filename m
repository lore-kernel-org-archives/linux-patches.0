Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67E31AED33;
	Thu, 15 Aug 2024 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730683; cv=none; b=RANdSBBuFCLBHC5BvnbF+G80vpfF3lwBdOSoiXeexXcfz7Ycj1xPn7owFtBSYoANsBD1CW/ocGJrXyHee+FkNWCHhHN9lwr3ie3qL9TkziDCpPAqM85WSBLVnuxGDOEW9S6R+n1ULoSHdTybGi8G3WHnxV+PqQceSMkXmMl25d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730683; c=relaxed/simple;
	bh=1GK7O2m4lMOBZHBR5ucNw/gQOLNbSI/z0hy2e4iqxTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hepc9xL/57Gqd7+4wVibxMhQ39rDFCi3hJQPtGyFdo5evjnG1R+JDhJq0YgYJP90zhVkLBl7wtUZuD31zc7MIdEEiWhz5WZhKzuPWceE+BE6VVbo/CRjJazZbFQkfZXKrwrF37zlRjxA/bugBvLUKCoTPoig9Zj4WJsNEw9eGqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIrtShV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIrtShV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D535C4AF0A;
	Thu, 15 Aug 2024 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730683;
	bh=1GK7O2m4lMOBZHBR5ucNw/gQOLNbSI/z0hy2e4iqxTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIrtShV/Sm7gd3IiPfd8+eVP20LXFv0WreL8V/AT7pW+Ohh1Gh1LMJrScgdLG4g8o
	 KxxIzu4I8J6rSp7vOUWfp7k5347s5ZmREGd+vr3n1KJBqZNFEfVk4pJHJnIOpu6Bjo
	 g7TMIi33uSk5YtxvJy86iHt4ZzfKMvuEvWggyeTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 484/484] ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode
Date: Thu, 15 Aug 2024 15:25:42 +0200
Message-ID: <20240815132000.178625341@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

commit 0df3c7d7a73d75153090637392c0b73a63cdc24a upstream.

The i.MX6 cannot add any RGMII delays. The PHY has to add both the RX
and TX delays on the RGMII interface. Fix the interface mode. While at
it, use the new phy-connection-type property name.

Fixes: 5694eed98cca ("ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -260,7 +260,7 @@
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii-id";
 	phy-handle = <&ethphy>;
 
 	mdio {



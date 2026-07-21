Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6938437DE97;
	Tue, 21 Jul 2026 18:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658358; cv=none; b=TwRZNCDXS1np3/rRnWIBCEzoh+98X0HP/6/CBj/hYw0NGw+e2W8Xzk8P3YQy7oTppzB+VPCCg5/dk+/OXbDXSIJoj1f+8Ok5myCANpFnDxbdPW1voAljfcgoGPHnnWyKZDDzs4oeH0Zimg25g4eaWik/nSMTLd+XtqEszXng2vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658358; c=relaxed/simple;
	bh=o9W1j86Hx5u2kybBbCw6Eh6f+2CzJBQCgk6shFP/+w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXA8DR1K4SS4ltJUv6DpSvElhjDvrIOSS/qYFjTBGu+zPCoS4Rq2yGEoivi8RpEksaF2xffVWMEcnHswuxVa0db/qYvRmULz5gjC6kvuyVXAFx2QMWmasVawtzh+3dDJlED4aSdXRWzUXd6EBwQdsXBC0E6+T32GiWklw2d7gUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjXBCOB9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjXBCOB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8549B1F000E9;
	Tue, 21 Jul 2026 18:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658357;
	bh=yFLAx/p1046Mms9SGpqQ/GyYEOGjFUgaCyGlyG7k0EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjXBCOB9y7LU77BEACPYsvl4wAi4qyWq3OJ3+tXXwrkV+nONKQUK9phLSfco/rQph
	 YKxMNDU0BJeDf4tWf9G4QCFZ1u62cIrLpfqAQM/x373htuUQvh5tfhOVslrR44Jg5Q
	 66qjUtk6LsoxHLB4e+UJBdqq5GluUnNuJkXPK4+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 1111/1611] ARM: dts: imx6ul-var-som: fix warning for non-existent dc-supply property
Date: Tue, 21 Jul 2026 17:20:27 +0200
Message-ID: <20260721152540.405093569@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 0372cc5776e7fd5570884aed0c1e9a8a546cad66 upstream.

The dc-supply property is non-existent in Linux now, nor when this DTS file
was created when importing it from Variscite own kernel.

Therefore remove it to fix this warning:

    imx6ul-var-som-concerto.dtb: cpu@0 (arm,cortex-a7): Unevaluated
    properties are not allowed ('dc-supply' was unexpected)
        from schema $id: http://devicetree.org/schemas/arm/cpus.yaml

Fixes: 9d6a67d9c7a9 ("ARM: dts: imx6ul: Add Variscite VAR-SOM-MX6UL SoM support")
Cc: stable@kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/nxp/imx/imx6ul-var-som.dtsi |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/arm/boot/dts/nxp/imx/imx6ul-var-som.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6ul-var-som.dtsi
@@ -45,10 +45,6 @@
 	assigned-clock-rates = <786432000>;
 };
 
-&cpu0 {
-	dc-supply = <&reg_gpio_dvfs>;
-};
-
 &fec1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet1>, <&pinctrl_enet1_gpio>, <&pinctrl_enet1_mdio>;



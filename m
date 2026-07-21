Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A353646D2B9;
	Tue, 21 Jul 2026 17:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653984; cv=none; b=fCId9RLwvztK0ln97UlV9y7tvxj6+/pt5bpjFn50zzXOMOVkKD43Vak5yZP8KjxXGmlzjnaaWAe2luM/n3Ktwy6UD0jmsE6dkrA7xy13wZ68f13lL/NFJCjzpChOoS0w0WTJft7mECOAlygpNq+EOx+EcYZ+suH53DKrjdy6lfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653984; c=relaxed/simple;
	bh=keE0lRBQzpB6Z80IHRDike2wPtEzTj1MOHMM0oNUQLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLEc+QyCir9pZAurI4PSOPHikUsjkjEUCew8ud8TSnkJseH+vwanGeOAPq2+tH6tKCii/eseQ74xXQvdGc9s+Px+gMuZKY1hlWxnpITpJ4mT4hKex8FJuPB0y46quKSBfI4Ap8OJJGLCBl5a1VaR2eQQdaD95b5JIskMMmROBpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIhoSzM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIhoSzM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158041F00A3A;
	Tue, 21 Jul 2026 17:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653983;
	bh=kCoPTK1qK3YQGnAFj1/6E2ZhOghutUC4bmIhpySyZ3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIhoSzM8ob3Z9EXQoYeDKLp9/n+p93qK9QgQ9CHwPyV8NA4jzaThjG9RZmIcyWAvd
	 /OI/egAzLqODy0Wd8jBKrr4S+/LrZlDb71wv35gO6MUlX+9GOclXLXK9MR8s+2lgXB
	 lvlvNbEB6FQPOLKqtzqjdWjBH45ctC/WZEEPNSCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.1 1534/2077] ARM: dts: imx6ul-var-som: fix warning for non-existent dc-supply property
Date: Tue, 21 Jul 2026 17:20:07 +0200
Message-ID: <20260721152628.958754120@linuxfoundation.org>
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



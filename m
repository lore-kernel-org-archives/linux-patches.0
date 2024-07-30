Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFC118C90A;
	Tue, 30 Jul 2024 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355551; cv=none; b=MsAzMJ8wccK7jGmJIZ79rG4bjW4LYrdcL2imVnpMU1ul3H8KlmojYgYkR9bE5zYQV/ZxQDODgxLYKa4IfkJ4Tq17dEuNu+8lBV++c2fR14pAZm+V123THU0xpNk25UGqQErlRIHFPxqkKfDKhCIonifP7J39o+j2YkkZqn2y2jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355551; c=relaxed/simple;
	bh=Z6ai77hW2578r2h6CSZZBMVH6i/Ws0GMwT4pJ6JD8QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKHT79RpE9jeXG76TmhZVK3a5Yp27zx8iQ8sHJhl00qHVzmnUYd1OxOyDspkGsZr71lKEhX6BYr3ruSuWFBddjYBXelHg0foCaQoOi3TuhX6UXZ/aI9m9aTZ1grtekotx0EbO19NOK8h1WpOl61zareeVljgZroPxaroJknLo/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmRc03c+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmRc03c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F43C32782;
	Tue, 30 Jul 2024 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355550;
	bh=Z6ai77hW2578r2h6CSZZBMVH6i/Ws0GMwT4pJ6JD8QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmRc03c+C73qelv3MiSQd2pL75bsd4/g2BPjZ9/5LUS1V3JFFl8zuz4FChvDc7V9/
	 lbsCNkLIohNY3GmAZ7BJEUYzM2tKf6iZDopX9Z0BuIxi/PYND8vpCVnhLQuiOkhz0N
	 ctdmW14Jklruqkv3jNBjVLbAt5PMP0rluWbmToPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/568] ARM: dts: imx6qdl-kontron-samx6i: fix board reset
Date: Tue, 30 Jul 2024 17:42:55 +0200
Message-ID: <20240730151642.517674811@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit b972d6b3b46345023aee56a95df8e2c137aa4ee4 ]

On i.MX6 the board is reset by the watchdog. But in turn to do a
complete board reset, we have to assert the WDOG_B output which is
routed also to the CPLD which then do a complete power-cycle of the
board.

Fixes: 2125212785c9 ("ARM: dts: imx6qdl-kontron-samx6i: add Kontron SMARC SoM Support")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
index d6c049b9a9c69..700780bf64f58 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
@@ -817,5 +817,6 @@ &wdog1 {
 	/* CPLD is feeded by watchdog (hardwired) */
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_wdog1>;
+	fsl,ext-reset-output;
 	status = "okay";
 };
-- 
2.43.0




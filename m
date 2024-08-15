Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB0419E7FA;
	Thu, 15 Aug 2024 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731092; cv=none; b=JIoQr9ERpbKjTcDFf5ibQHmoVAyYk29yQ0tDIdR8S+ZzC76OQfQewNgLPcP8I+a1OPh61Bvq7gjUU0S4JL+R/Aa2TkqIuTs+yrgzvxNZsXJDbF/+HIvT+QQGIfyyL1i05OhbKWBtBkRB6oQj7tENPycSE3x4bQs9eNCiKuzEMMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731092; c=relaxed/simple;
	bh=z35Eq1dr01QIJKlMWgt6H8M0vFUPj1+zn0EYwFq91c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfbYPMg64R7GLY9fINBGQJqXrGXk7nsjTfrt72nX6z2j7LbYS5FRKunkxjNKQI56zFjFL54IQ5ixi24ny+J62mDqAUMRnsm4CfBE9d8aGq1OevfAyYerRA1G4aWtZHXsz3YZw+Dgjhuu4NPYuwmirWjl3hvPkr2msfLFXjWvyz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Asy+/tUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Asy+/tUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004D5C32786;
	Thu, 15 Aug 2024 14:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731092;
	bh=z35Eq1dr01QIJKlMWgt6H8M0vFUPj1+zn0EYwFq91c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Asy+/tUWZvHAZYe1+gLjH5UvMMc2t1Yjia3thGKjiHAWtZn/jm08axGXyEYVNVBEV
	 ikQJpZJjtHpiW3pRP58oR7NlWyWOXB97keS2S/7DZLHN5wGJ0Z7YjUqEil6cNb7E3j
	 GQR69XFUfiC75p7hGH6MdJzahuXDNXlNncGyCrKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/259] ARM: dts: imx6qdl-kontron-samx6i: fix board reset
Date: Thu, 15 Aug 2024 15:22:33 +0200
Message-ID: <20240815131903.577493921@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 1dcbad290cac0..49b17ecb40224 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -813,5 +813,6 @@ &wdog1 {
 	/* CPLD is feeded by watchdog (hardwired) */
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_wdog1>;
+	fsl,ext-reset-output;
 	status = "okay";
 };
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFDE1B583F;
	Tue, 30 Jul 2024 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355038; cv=none; b=VGWi8LAi7PJufi7ZxJj8Lx3n9hwgKZilhGkyMj1domh/GJW4OQmFcThEksZorIb4i0zWXpOxj4WgpHG5XkyX3o9a0YMYyCmeXMH375Ami3huhtNWatWfS+/i7mo/8AlLW+RT7vUPVFNyOproZ+iAlziEJuHMEZRsB6mF7I97IQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355038; c=relaxed/simple;
	bh=+ylN1wZzQSWllbQU2q1hzPfuAXhJobeuZngNpsnBHts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkygjQvbfLqAvbGujPQ0rC2HhCAeLGmVryhA1/X25rXuQ0ynq0z0W7S0fS9R6b6qzqQfZpZ3nuUdVd26RPRR+FnOz1MkLGuj5RxLn/+Qjp8bc6CkdagikkOHyut971Yil2laQboP2R6n1wCE/fEf7Q8GJqHpn6vQowNs1xjGe4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TehkgvqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TehkgvqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCE0C4AF0A;
	Tue, 30 Jul 2024 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355037;
	bh=+ylN1wZzQSWllbQU2q1hzPfuAXhJobeuZngNpsnBHts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TehkgvqK37IhlTdS+btUvk1im8euX5Nmgl3h4OnAz+rHVqGdeom4EtGSFRnrsd4PT
	 tiZyg3MQ0AxwJXqhNZazfSewjFY4Zd6Id07LKj7QUazpGXIX2r7LKZezmp4UF4Gl5V
	 ZvnvKe/BQ+YrfoIYf3pujF5ni6G72vL4w9/pBwzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/440] ARM: dts: imx6qdl-kontron-samx6i: fix phy-mode
Date: Tue, 30 Jul 2024 17:44:45 +0200
Message-ID: <20240730151617.795163074@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 0df3c7d7a73d75153090637392c0b73a63cdc24a ]

The i.MX6 cannot add any RGMII delays. The PHY has to add both the RX
and TX delays on the RGMII interface. Fix the interface mode. While at
it, use the new phy-connection-type property name.

Fixes: 5694eed98cca ("ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 85aeebc9485dd..d8c1dfb8c9abb 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -259,7 +259,7 @@ smarc_flash: flash@0 {
 &fec {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
-	phy-mode = "rgmii";
+	phy-connection-type = "rgmii-id";
 	phy-handle = <&ethphy>;
 
 	mdio {
-- 
2.43.0




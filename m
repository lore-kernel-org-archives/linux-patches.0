Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39A414A0A8;
	Tue, 25 Jun 2024 09:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309259; cv=none; b=iihP/6rKbaE9ggajVu/BRXfEcmolbpmLp3+H/0uTGEie/6Rpf8qG691GOpnUG0eioK7kADkNcP9Ajwk/yd3o1NJ+8T/dRJfgHx9zPSfmWjy7aqpGg/UlbAQkiYieK82xX8VYBm4/WEcfGaPImOrNWxiEgvvOXYWR9iT+XgTIVuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309259; c=relaxed/simple;
	bh=8hCp9aPceg4vCR62aB8eZx8THw+W1nx5ZFnrpYJvDhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7TncXVO+/MqWgtwp6dasqtZqCpLWPQdEgG9fUTWQA6NlUav/pbDPkgXV2ZN0izCzqYQ0yAP+V2QDeTHyBaE9C0euxoISa2lRtwhaO0BoxgSq9jTJ4Dv7hUQ6b35/W17xTChmpc1PAT5uJkcjJhbn+TYMyHrEFcbhmyclvz1E+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMFZahB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMFZahB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B16DC32781;
	Tue, 25 Jun 2024 09:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309259;
	bh=8hCp9aPceg4vCR62aB8eZx8THw+W1nx5ZFnrpYJvDhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMFZahB9r1ftXuxZiJflnsMshTL++4euybGO1GHryJ06gUlHg88rWga9GEmRotaaT
	 eEtAynHYk8f/fjGzWB+RyDV3accQ6HYn8MB2YJkkj3yFqpjhWlJKOm6U5w3bCEey7F
	 9IHOorfNOi71x4Y9r0eSDjlzhCicNe1pLfDkXdrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/192] arm64: dts: freescale: imx8mp-venice-gw73xx-2x: fix BT shutdown GPIO
Date: Tue, 25 Jun 2024 11:33:10 +0200
Message-ID: <20240625085541.701579833@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit e1b4622efbe7ad09c9a902365a993f68c270c453 ]

Fix the invalid BT shutdown GPIO (gpio1_io3 not gpio4_io16)

Fixes: 716ced308234 ("arm64: dts: freescale: Add imx8mp-venice-gw73xx-2x")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
index 68c62def4c06e..d27bfba1b4b8c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
@@ -161,7 +161,7 @@
 
 	bluetooth {
 		compatible = "brcm,bcm4330-bt";
-		shutdown-gpios = <&gpio4 16 GPIO_ACTIVE_HIGH>;
+		shutdown-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;
 	};
 };
 
-- 
2.43.0




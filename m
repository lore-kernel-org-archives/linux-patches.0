Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124A61514CE;
	Fri,  6 Dec 2024 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498536; cv=none; b=fPH1+3yYGmy8tZc0TPQ0brmOcRSBRCOC72w8JNEFB9Hk1669sEsMQQYXoJ32BbeSqUCm/EMYv+cMhMx+YJeXbJoJX9jqjD2+nPAJQFcsaXHXQBEh6J/lexyi937IgrBcUaGkO4pxEWYKiuMQE1gLGPAdJIbmV4b6o/XPNOmMG88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498536; c=relaxed/simple;
	bh=SuBFZeXLa1bRyADlgUYUrVvjroTT+tlYTaiIE3vOB5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osUZvdNmbGoEQaW0a7GAggYP+D0K3g8ylXHFRi+OioaMAkxHw4kElEEUHdP6sylhi15B+OLmav2Ug2qjlg13j5aiiF1cLOE62RXXN0H6VFmOGoSf5R2iGAZp8b1rUDzWvQPcPWAHH7p3ZxHGsINsCcOOYvw9mcAtWTO/wEZ6/00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRl4pNYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRl4pNYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F1AC4CED1;
	Fri,  6 Dec 2024 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498535;
	bh=SuBFZeXLa1bRyADlgUYUrVvjroTT+tlYTaiIE3vOB5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRl4pNYot1fU1JPqb/9f5Eh/aTRx0K3oVxJW0Py4Wok0HikfmHnp+QQaGfBbrgf5R
	 I+QYfLLCLveOuncymPBT4A6T1ZyRhb7cemGR3IgofUdgW3L2gHc7noMz4C4BFxfttI
	 JAdDjJjpYABGtLnSf0WH0Sl/DMNZF9p8K2RrhHQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 613/676] arm64: dts: freescale: imx8mp-verdin: Fix SD regulator startup delay
Date: Fri,  6 Dec 2024 15:37:12 +0100
Message-ID: <20241206143717.317736329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 6c5789c9d2c06968532243daa235f6ff809ad71e upstream.

The power switch used to power the SD card interface might have
more than 2ms turn-on time, increase the startup delay to 20ms to
prevent failures.

Fixes: a39ed23bdf6e ("arm64: dts: freescale: add initial support for verdin imx8m plus")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
@@ -134,7 +134,7 @@
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reserved-memory {



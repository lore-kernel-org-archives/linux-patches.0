Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA95205501;
	Thu, 12 Dec 2024 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020514; cv=none; b=h3mlGTjZLI/oe3UpVqcvdDAZDJ5Z2WdHWX/rA96+4LhyIum5XW3KwCtPoYv0Unq2b05qS7JnlZ/qfOPrZRIfu0R4CPBAPJo8v14Z+TJRtEVDzKM7G6FUK2Clq9g5+i4wNsDIx0TB4x8ACHNeKwCls+9jEQ+T8Wu9CzzLQzuYhRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020514; c=relaxed/simple;
	bh=0jbPgY4oYDXFAp3FlHuGy2LgV+S7+UL4SuyZpWJBxM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvSPdMp32cw2oEVCPrPgMHTgeZs1kJe3PDCPVz9eYdT/0w4IYIhQPVZiCrBDhkCd8S8kDoNbL1+AVd6Y9gDAZyXnB/G6fumGeJ/iFTonj9J8f4zAje9tZ5dqv9QlLcNgCmag3vn7aqvCWqcWhDozAJwXsdB4q05hbTXE6obSOZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pdktLKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pdktLKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A84DC4CECE;
	Thu, 12 Dec 2024 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020514;
	bh=0jbPgY4oYDXFAp3FlHuGy2LgV+S7+UL4SuyZpWJBxM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pdktLKnnoftSfxBqBbUnCyAIfEczK/uvwKqv0lTsQxJ7QcA73HcV9tozv/stIfv7
	 /qZYwDLTkhhtAGkn8fKjNmUl1Ka1arrx2UHSmpVeQj3yXJcZYovG53DwiI0N93MgDD
	 cuWxHkNTMsiYsXVDXOoSuU2HRkew0srwaHOd9Khs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 456/772] arm64: dts: freescale: imx8mm-verdin: Fix SD regulator startup delay
Date: Thu, 12 Dec 2024 15:56:41 +0100
Message-ID: <20241212144408.770043942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 0ca7699c376743b633b6419a42888dba386d5351 upstream.

The power switch used to power the SD card interface might have
more than 2ms turn-on time, increase the startup delay to 20ms to
prevent failures.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -141,7 +141,7 @@
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reserved-memory {



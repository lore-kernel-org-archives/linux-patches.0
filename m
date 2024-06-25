Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804BB14AD19;
	Tue, 25 Jun 2024 09:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309320; cv=none; b=gX5va7ZdKUdDDCXhGd/aKTQtgOcV89qyDhD8H+3impmP1iYnXGxHhIxH8ufUwcBb/QlGJFzKxMjFe/yAKmXdme0xZL3JEAD8GDcOZSeBF50wkJisA5Pmh+2mLYPwVNN/k9lOsSS37ys1JTfIyhkVmbF9uNyQcTB4fh+WtA4wkto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309320; c=relaxed/simple;
	bh=8t97LCSXwaFCtac8YxeD/K9/NvJJTPnywXZ5ak/IVr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pL5BhIOLcqUDQumDT+b00Mi+Vas4tAQ/tv+Y/xo0h9TChjZ9ZNIw9RWvCvHvzqac6CzhI3yU+OOQUo/AhPQRVG9z/MfVLTs0ptjF2hco2lgzNxIbFa3T1o8ATmrt/ICY4Kb7atnrQjEg1Lc/RLUN8kPaDAP6izF5KsqeJLv+uHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cr9Fp4AL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cr9Fp4AL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A7BC32789;
	Tue, 25 Jun 2024 09:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309320;
	bh=8t97LCSXwaFCtac8YxeD/K9/NvJJTPnywXZ5ak/IVr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr9Fp4ALH71xUUk7TOQNasFi9tHQ51l5JQp2/omat1XdGewL0QnxOAAMn3FZnfTy7
	 Rc++S4mNiuk7wicnVasI+VeijhaQLZgrWK4lvt89zYbAVrRjCO885Jgu0b4SLDSNSz
	 +KWN84OGIxs3k0Z3Jq7L9mg5QsClCAgutvUOCMMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 169/192] arm64: dts: imx8qm-mek: fix gpio number for reg_usdhc2_vmmc
Date: Tue, 25 Jun 2024 11:34:01 +0200
Message-ID: <20240625085543.647702434@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

commit dfd239a039b3581ca25f932e66b6e2c2bf77c798 upstream.

The gpio in "reg_usdhc2_vmmc" should be 7 instead of 19.

Cc: stable@vger.kernel.org
Fixes: 307fd14d4b14 ("arm64: dts: imx: add imx8qm mek support")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -36,7 +36,7 @@
 		regulator-name = "SD1_SPWR";
 		regulator-min-microvolt = <3000000>;
 		regulator-max-microvolt = <3000000>;
-		gpio = <&lsio_gpio4 19 GPIO_ACTIVE_HIGH>;
+		gpio = <&lsio_gpio4 7 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };



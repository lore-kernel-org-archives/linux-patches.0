Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CC219DF5F;
	Thu, 15 Aug 2024 14:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731936; cv=none; b=ZFXDJwsIbj7/cu4oOxqPb1zwWfM7A+7lT15P4UBaA9s8oX73DRDi/7xzzLMH5X/9xMZtQF5MsGIjxBY8qU3u/Mk35SpsWH/+yHqVyMz+iksH4c1gA8ndUz3i2eL/vo/uLQ3KFH0nBFhM9DE5eHEjhOMfOowXm+ZD8JDlKi3Z6yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731936; c=relaxed/simple;
	bh=lXCaPeE4tyNw7tY3dzzySTdd96q0PHPyReBmPbMETmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byPtepYOz0duvzE7dKHp1mtYHzdO62saWNTCp5ixpk3038i+rcUrmqnXyzMuh7BEXwr8gxMFIuDrCEIdmx6RaXKH77ZElgciLR38AvAktBUu6ZPb84B4/XzhRr9Qtzolb2rsdN/v4q+oDDApQYx8QhmlzK0TeHgctu5ibi73Ywo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bu21avVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bu21avVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE550C32786;
	Thu, 15 Aug 2024 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731936;
	bh=lXCaPeE4tyNw7tY3dzzySTdd96q0PHPyReBmPbMETmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bu21avVaiETLp27eU8SpA+7eqPkYFMmOSROHjTmKxBh2e/OU2IBDjmaWgZJMgOrQY
	 m6wU8Tso5W6YjTtX0X1J5cp1oMRMX3QxYAxSn9q7tPAM1If9xOr/TSfr23jWWaQav6
	 QRkjjFDkGi+6fsxDWR+DX6zn0nnWZgxjwlqyGfI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/352] ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity
Date: Thu, 15 Aug 2024 15:21:30 +0200
Message-ID: <20240815131920.153173155@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit df35c6e9027cf9affe699e632a48082ab1bbba4c ]

The PCIe reset line is active low. Fix it.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 115084500c37f..9ec1519e17195 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -728,7 +728,7 @@ &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
 	wake-up-gpio = <&gpio6 18 GPIO_ACTIVE_HIGH>;
-	reset-gpio = <&gpio3 13 GPIO_ACTIVE_HIGH>;
+	reset-gpio = <&gpio3 13 GPIO_ACTIVE_LOW>;
 };
 
 /* LCD_BKLT_PWM */
-- 
2.43.0




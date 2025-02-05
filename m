Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EC3157465;
	Wed,  5 Feb 2025 14:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766803; cv=none; b=XKmSqVdWVqwBbooV2uNQznXWpwuMLA5Yr9qFb0ws5Znn3xGOSkqJmSkCO0I+7DQsJfdgiwnUivqk/KKx7kszMEQ9DCihdBcqCdGEp+jscOzUWwp1yfQWy5w+ahJODuPb94QVOxHreUYh1MN18RYYkfhREtur0MQNQv0fG0QYObY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766803; c=relaxed/simple;
	bh=HT0ZgNUV6QEyvICRlTLvBc1olqbPTFn5MPzNcDg6AHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/xLxIZ3Av122IsuoA1mjbk7N6siyOfgYLjR4P9K/1lqgZrgnD/8y+zfm59C3L/UtdAzMo8QwYAqgwnLI0KK51WeutZYP+qYcAstwXV103vxocDEUTu/jdkxuHM2NnebbiVWsO6ZJO7mCv00RLv9VEQkxH6h/83r5k8lJYyece4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhVApn41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhVApn41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC3FC4CED1;
	Wed,  5 Feb 2025 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766803;
	bh=HT0ZgNUV6QEyvICRlTLvBc1olqbPTFn5MPzNcDg6AHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhVApn41IT4Fdc50+FDmLASi+wqnJlsddV5xHQZ+JVG6yP9FA8AavLGWWNY/K1wAe
	 Mf7NPGPcHJdZmReUl5qESkJxe/0Yyo7MunNDHlKL7N4+olmU3H7yKQuuF8n0zxzPd6
	 EHz9XLYk66UgY6HtuPhcILUMJ3aHOtwmCPMxx/I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 363/590] arm64: dts: ti: k3-am62: Remove duplicate GICR reg
Date: Wed,  5 Feb 2025 14:41:58 +0100
Message-ID: <20250205134509.158765285@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Brattlof <bb@ti.com>

[ Upstream commit 72c691d77ea5d0c4636fd3e9f0ad80d813c7d1a7 ]

The GIC Redistributor control register range is mapped twice. Remove
the extra entry from the reg range.

Fixes: f1d17330a5be ("arm64: dts: ti: Introduce base support for AM62x SoC")
Reported-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20241210-am62-gic-fixup-v1-1-758b4d5b4a0a@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
index 5b92aef5b284b..60c6814206a1f 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -23,7 +23,6 @@
 		interrupt-controller;
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
 		      <0x00 0x01880000 0x00 0xc0000>,	/* GICR */
-		      <0x00 0x01880000 0x00 0xc0000>,   /* GICR */
 		      <0x01 0x00000000 0x00 0x2000>,    /* GICC */
 		      <0x01 0x00010000 0x00 0x1000>,    /* GICH */
 		      <0x01 0x00020000 0x00 0x2000>;    /* GICV */
-- 
2.39.5




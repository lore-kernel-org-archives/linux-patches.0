Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4311EB5FD;
	Sat, 12 Sep 2026 07:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199786; cv=none; b=pTc8kyvPew60tHNqdzGwHPLZCiQSCYAJJg1+c4qrJG/DIjggQDf+UzNysGWMRWuYtj9bbi0PcoxaDE9eCBd62dvC/2JbLw5P5/OuhIILIZTDw187qKmEZg018/7rLJllwbQtPQBuy2TdK2e5Crz2yVAlIPDP21qKWR4Mii1gFP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199786; c=relaxed/simple;
	bh=6mDIp/zDlR16+oHw/OhuXECW9I4hk4pS/KGGJPzRJTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSuh78KaRTGT1Li+Z3a+Z1l9vuYiAxyWniNcmHUIq7Hw9MNr9PX0Oio7wR2MBeRSEBo/xcn8S/uHDC1Y+xQKvL6H1hT3UazwLhLsDN2eC2QYRjO+kFP9LWqYocQPNbsFZ2ZeIcsH+ErXkRVtYEpjO+BTlPGHk20QjEHQ9p2reu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHwLlK2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHwLlK2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968421F000FF;
	Sat, 12 Sep 2026 07:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199784;
	bh=9SgQEcHINi8BtFlQQ3XWZ8cdOxyjqdvMw4NjxPKwT7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHwLlK2Xs8X5Cu7Tv6RHIrYRm1zCwhJwaa7MXwlsCfX6TqrxuzZthevBq/43QKT0F
	 5W96pGTuDXv4SiAHR50k9ONjRl9uKMSP6zYmLN/sACLhlbFzCUrferxvFpZjkqm9oy
	 /dpDpbRNdtA5FVLL7T1Gj+ukX57rgHLL4QwuCmvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	E Shattow <e@freeshell.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0656/1815] riscv: dts: spacemit: Add enough deassert time for the PHY on PICO ITX
Date: Sat, 12 Sep 2026 08:40:06 +0200
Message-ID: <20260912065704.280680750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit a225e19a4cc4e040ca0389cf0bbe209c23f5c92d ]

RTL8211F require at least 50ms deassert to guarantee the register
access, 10ms is only enough for the PHY reset.

Fixes: 74657a376960 ("riscv: dts: spacemit: Add ethernet device for K3")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Tested-by: E Shattow <e@freeshell.de>
Link: https://patch.msgid.link/20260710063314.1030249-1-inochiama@gmail.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-pico-itx.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
index 1b535226e3ce0..650a0fe5b1ba8 100644
--- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
+++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
@@ -195,7 +195,7 @@ phy0: phy@1 {
 			reg = <1>;
 			reset-gpios = <&gpio 0 15 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <10000>;
-			reset-deassert-us = <10000>;
+			reset-deassert-us = <50000>;
 			realtek,aldps-enable;
 			realtek,clkout-disable;
 		};
-- 
2.53.0




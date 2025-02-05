Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EACB1519A4;
	Wed,  5 Feb 2025 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765047; cv=none; b=T9v7qvscAVwGbxnmkWtrsJvmK9Uy1st42ZHvJdRg1ZZMVZJGkwOnQIGERQW0XP5bnnOt5WCAtCroEbA8xrB22U6CAa04RQEsoNOFhkRa6dse8RKujpKQ3d4TRdSAXMU/Wv5xDr6vHBX70zCfZETyTgK2FVCKlLfIWQAct0whm8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765047; c=relaxed/simple;
	bh=/dwElW6z28VGheJVU+UAx4MBIUetp7yeiAXEZaTBVJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ6tIA97seTOIjtAAUh3HDkuKjVxmqwkGKNevXG0ChG5rmzuwELOJ2masQfXqhdtRmp6HhZrlc225TedkmAzR+ow5StwZSJmq/dvf5cqO0gxVLdlAwsUMHTsfMlnJWjD4HA5fmWRw2JiAZWSwwUR0eEEyWDblL25jZeKADB0J3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKPUlKzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKPUlKzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB0EC4CED1;
	Wed,  5 Feb 2025 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765047;
	bh=/dwElW6z28VGheJVU+UAx4MBIUetp7yeiAXEZaTBVJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKPUlKzujRuKegcjixIPBcTj4c9e/jydIjXS3hglGNoIYnRqXd0QH5WglH4YDiGoT
	 aTijxnqIuqgc2PiPZB5zlkG5PL4Kzl8v1DmElh1vCadq2OlxunzXHEeD76r0ji8eBn
	 0h498yZQYLyZ05jj5m0lvvO0cb7E56zjRMd79ARM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/393] arm64: dts: qcom: sa8775p-ride: Describe sgmii_phy0 irq
Date: Wed,  5 Feb 2025 14:42:26 +0100
Message-ID: <20250205134428.991664444@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit 1ff6569b0ffe7a2e311104cb3cd841983e484ac9 ]

There's an irq hooked up, so let's describe it.

Prior to commit 9757300d2750
("pinctrl: qcom: Add intr_target_width field to support increased number of interrupt targets")
one would not see the IRQ fire, despite some (invasive) debugging
showing that the GPIO was in fact asserted, resulting in the interface
staying down.

Now that the IRQ is properly routed we can describe it.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230817213815.638189-2-ahalaney@redhat.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 30f7dfd2c489 ("arm64: dts: qcom: sa8775p: Update sleep_clk frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
index 81a7eeb9cfcd2..8fde6935cd6ec 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
@@ -285,6 +285,7 @@
 			compatible = "ethernet-phy-id0141.0dd4";
 			reg = <0x8>;
 			device_type = "ethernet-phy";
+			interrupts-extended = <&tlmm 7 IRQ_TYPE_EDGE_FALLING>;
 			reset-gpios = <&pmm8654au_2_gpios 8 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <11000>;
 			reset-deassert-us = <70000>;
-- 
2.39.5




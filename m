Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD8E155756;
	Wed,  5 Feb 2025 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765056; cv=none; b=k5fwqEuW3+tunyl+ejNbttyqpT8WP87bUoCxY+hSZevM52wejnB/zeFKtp0DRY5YPn4c5lFOwIipuZKrdk3xxblQ7NYJJVv0gMMt+QEGJSM5dJPs4zqZ4TFw+0VhMcciV3dpv/NNW/lXcGsZYREzIHZZodc5hedzQJt4+x19084=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765056; c=relaxed/simple;
	bh=J0sA0jmjf4gvbTgddD6HUKRX8dM+zVZ5ZK5QUYTnPMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5qDmfKgEFHWw2wbkw40pX4K4Ge2o59p6eI+Gunsjekz1bbCJrKMpFA/4z0cDniXp34WMWx06qhW06yCT5i5R3URawDQCkoS9KAxBjGesCGapFbgPydC1pujcOQ3Ll8KmP6lAAJ/3L3ue4+U4gAfCyhR1aCjB2Ezo+JF1dF2aeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pc8OpmcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pc8OpmcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF7AC4CED1;
	Wed,  5 Feb 2025 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765056;
	bh=J0sA0jmjf4gvbTgddD6HUKRX8dM+zVZ5ZK5QUYTnPMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pc8OpmcHToT2Q9KqAt8g2nfl+8D+DogS/EtArFmKQJd856keFm5KTwZjs7oxcbwH8
	 JO2BDYIJc/ZWB6HkewNbaK6S0W5v08VYL8P6ZChxWBXs3/R7BTrhW6AYnx0P9LclwX
	 uDWzAnhCQYsdr4kTz+Pu5fHs1m8sknOqw5062Voc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/393] arm64: dts: qcom: sa8775p-ride: Describe sgmii_phy1 irq
Date: Wed,  5 Feb 2025 14:42:27 +0100
Message-ID: <20250205134429.029128092@linuxfoundation.org>
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

[ Upstream commit 454557d0032d088b4f467f0c541f98edb01fe431 ]

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
Link: https://lore.kernel.org/r/20230817213815.638189-3-ahalaney@redhat.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 30f7dfd2c489 ("arm64: dts: qcom: sa8775p: Update sleep_clk frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
index 8fde6935cd6ec..9760bb4b468c4 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
@@ -295,6 +295,7 @@
 			compatible = "ethernet-phy-id0141.0dd4";
 			reg = <0xa>;
 			device_type = "ethernet-phy";
+			interrupts-extended = <&tlmm 26 IRQ_TYPE_EDGE_FALLING>;
 			reset-gpios = <&pmm8654au_2_gpios 9 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <11000>;
 			reset-deassert-us = <70000>;
-- 
2.39.5




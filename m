Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD862C9D;
	Mon, 23 Jun 2025 21:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713563; cv=none; b=QnfoAAn404sjhzj+yc7I24Oc8XpXWokqE6fjhrv1E28KU9XJnDpWwnOrkKrltbLdD+L5r3ebTH5zwITArHh8H9GumQ6ksdiNxal4efJqdP2V4ebDrDpKwb/mlqbUR9ykJydylNa4a6Bz9LqbL/DTZmRgrb/0jfOSpj/XNmVm3Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713563; c=relaxed/simple;
	bh=f6TwXNVxw/ZaZDyL2Bxl69BW4jEYhMQ93HTXJHWfxnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKeyl/8EgbBf10+K0Y0nH3PhxojQcoTisebAIS0UM4x0U/gOKP926XJ6+Ii9nNwcijXyuY7toLnxEQ0JahBEbk/GlbnGAPO2tHrvb8E+RE23p+hYW6/F7cBlc1AVO3O1r95w8ulZrrD4pI3dw89zVkpqAXHGXLxcovxDhsOwCug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/NO0z31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/NO0z31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A30CC4CEEA;
	Mon, 23 Jun 2025 21:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713562;
	bh=f6TwXNVxw/ZaZDyL2Bxl69BW4jEYhMQ93HTXJHWfxnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/NO0z31qi8zPYzoCrsUjx4JbYyusYIvTFJi/I0cIz6WuquZKSQijO0yFE03BG/kC
	 b/wnv5H2BPMQl0+LW4d3F0vjbV6pvtQrWx5vbfJg6ZuTfDPgu9TUf0SlKlAXcjLqmt
	 vKEb6cZB4kxPVzMa718kX83sMxxwtzRbVel6wlFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/508] arm64: dts: qcom: sdm660-xiaomi-lavender: Add missing SD card detect GPIO
Date: Mon, 23 Jun 2025 15:02:35 +0200
Message-ID: <20250623130647.994163595@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit 2eca6af66709de0d1ba14cdf8b6d200a1337a3a2 ]

During initial porting these cd-gpios were missed. Having card detect is
beneficial because driver does not need to do polling every second and it
can just use IRQ. SD card detection in U-Boot is also fixed by this.

Fixes: cf85e9aee210 ("arm64: dts: qcom: sdm660-xiaomi-lavender: Add eMMC and SD")
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250415130101.1429281-1-alexeymin@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
index a3559f6e34a5e..9612671dc5afa 100644
--- a/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
+++ b/arch/arm64/boot/dts/qcom/sdm660-xiaomi-lavender.dts
@@ -402,6 +402,8 @@
 &sdhc_2 {
 	status = "okay";
 
+	cd-gpios = <&tlmm 54 GPIO_ACTIVE_HIGH>;
+
 	vmmc-supply = <&vreg_l5b_2p95>;
 	vqmmc-supply = <&vreg_l2b_2p95>;
 };
-- 
2.39.5




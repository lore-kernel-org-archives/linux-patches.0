Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9930833E37C;
	Tue, 16 Dec 2025 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884033; cv=none; b=AosawLThHbQJxEy+adw1RiPZOu5mZ56YMnR/cdLiuF13R/JTG6dLrqR4zRXMWu2IUit0wXI/Tq5FoLKIw8duTxjHp3MIcb3bhVbg0SbZZWq7NZl04kscv3auDKZF0YVOBlv/o/Mr9m7+2s7uba2BYaaFyEHD0CrUYg3j28WHk6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884033; c=relaxed/simple;
	bh=O5elhKqgimEE3u4GkVJ47dTr9B363725gwbBOJQILT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BagfqbCvQiSmHaGt9xspQAAwjLxIK5us/liL6WZml8JzAULW2rmFYJpNoKhi4IWoqZXIW6cbvjLOyxh/tPI7wC7rTQShmjINnZDJKnAGkubaViq501W457MKaxdBuYa5/c6uc7idMCUOwKA76AK8npu5uddg7kja++bdVWH7Lgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iz3GMHVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iz3GMHVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E5FC4CEF1;
	Tue, 16 Dec 2025 11:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884033;
	bh=O5elhKqgimEE3u4GkVJ47dTr9B363725gwbBOJQILT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iz3GMHVzZeV/tsZIDV1LzGQhFMt3C1iV5eC8tzaUOcF8oKtLw4ZiulifCfxMhXso8
	 ix2lcvdzQmThYKxWIgUrOIdoV7G/LdpWzN0dDf+wOJa80ihAJGzqF5PWYLDnLd+2PF
	 xbmMep0yEIFQ3qKjX9c2RYEUqbN6srQtCjWZvuWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/354] arm64: dts: qcom: x1e80100: Add missing quirk for HS only USB controller
Date: Tue, 16 Dec 2025 12:10:40 +0100
Message-ID: <20251216111323.569604738@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 6b3e8a5d6c88609d9ce93789524f818cca0aa485 ]

The PIPE clock is provided by the USB3 PHY, which is predictably not
connected to the HS-only controller. Add "qcom,select-utmi-as-pipe-clk"
quirk to  HS only USB controller to disable pipe clock requirement.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20251024105019.2220832-2-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index b03f3ce250dbc..8536403e6ac99 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4272,6 +4272,7 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			interconnect-names = "usb-ddr",
 					     "apps-usb";
 
+			qcom,select-utmi-as-pipe-clk;
 			wakeup-source;
 
 			status = "disabled";
-- 
2.51.0




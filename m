Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BBE35295A;
	Tue, 16 Dec 2025 11:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885770; cv=none; b=Ah4XTQdv2Jpsi/2gMUFbcQAZo+ppQrore55QBpmqM0+D3U+3XMpbykQ/BBRjIkHbkUwVoHS+g8LEJyNtnmAsgvDPCQoxMcKbhJcWCvGrxsoU6dzqqOxYRhoPS6F1IehxPN/ljQEUQgA0Ww0i0kSqD44Su4ChfemvQpuQpJabnwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885770; c=relaxed/simple;
	bh=uyHaDDVNbp6ua8sgwA6qksAxPO9PnBkck9Tr3obqhCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQ8I7IzkKdpNJcBENGCl9IAZLYfV49kK1eioQ4kgHcoIvxIkNFUh1ateqgDeVs0HcHy3B09KiRBRFOLPBmw6dOoAiCdY90vZVRnlRFnwJS1pNqikaekhrQFPZ02lT6WowolAxrb0Uv5Tm9Xf5LldX/4qA9TIT1gcaF3rY0H3iiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jY3k09Il; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jY3k09Il"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F11C19422;
	Tue, 16 Dec 2025 11:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885770;
	bh=uyHaDDVNbp6ua8sgwA6qksAxPO9PnBkck9Tr3obqhCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jY3k09Ilvwb25s1rkh+Yv45SS6NK3f9OU8darL5H9GQtFLfiKEXdIAUrhenvadtSI
	 GiBoTkQpa5pRU7/5Q4JxySu3/ONLjxNFff3zFgD7eCdUvnIQzp/TtG+BRgFNbMQGRT
	 oJ2vT4qYwVmdj1Ffg+fedPwm4UeUeS4FUpLrcB/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Talari <praveen.talari@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 238/507] arm64: dts: qcom: qrb2210-rb1: Fix UART3 wakeup IRQ storm
Date: Tue, 16 Dec 2025 12:11:19 +0100
Message-ID: <20251216111354.121346135@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Praveen Talari <praveen.talari@oss.qualcomm.com>

[ Upstream commit 9c92d36b0b1ea8b2a19dbe0416434f3491dbfaaf ]

For BT use cases, pins are configured with pull-up state in sleep state
to avoid noise. If IRQ type is configured as level high and the GPIO line
is also in a high state, it causes continuous interrupt assertions leading
to an IRQ storm when wakeup irq enables at system suspend/runtime suspend.

Switching to edge-triggered interrupt (IRQ_TYPE_EDGE_FALLING) resolves
this by only triggering on state transitions (high-to-low) rather than
maintaining sensitivity to the static level state, effectively preventing
the continuous interrupt condition and eliminating the wakeup IRQ storm.

Fixes: 9380e0a1d449 ("arm64: dts: qcom: qrb2210-rb1: add Bluetooth support")
Signed-off-by: Praveen Talari <praveen.talari@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251110101043.2108414-2-praveen.talari@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
index b2e0fc5501c1e..af29c7ed7a685 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -648,7 +648,7 @@ key_volp_n: key-volp-n-state {
 &uart3 {
 	/delete-property/ interrupts;
 	interrupts-extended = <&intc GIC_SPI 330 IRQ_TYPE_LEVEL_HIGH>,
-			      <&tlmm 11 IRQ_TYPE_LEVEL_HIGH>;
+			      <&tlmm 11 IRQ_TYPE_EDGE_FALLING>;
 	pinctrl-0 = <&uart3_default>;
 	pinctrl-1 = <&uart3_sleep>;
 	pinctrl-names = "default", "sleep";
-- 
2.51.0




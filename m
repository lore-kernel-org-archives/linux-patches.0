Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D10269318;
	Wed, 21 Feb 2024 13:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522019; cv=none; b=B3fENsRKhCxB2DT0QtoNft9yZpXu5JxqbaYP30aWlmaq7g+4rEzWZ6YzV9N7rx0gtLvW81ILQHgyOpxbj/Sgs2V5oiLmUVvUrNW05WPraA1i72guwpQ53U4MmgtEMX6okHADgzc0hQAvOjt5wit3DwTRTzrkf+51HnpNaoY905E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522019; c=relaxed/simple;
	bh=zUYoMEy2R+R8IFJwBMMZ0gC5cLhX5LfXH+Al4l7cLzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCZxzUYI+VXRCd13+4TrTCOOLi4OFEqFvuQqEBgXme/9aHgFfyAJ0zKUv7s4NhxIP/8PyEvstJOM00XjNHrWOiNM0+ZD3ju669CQg3hwDoAnlpyN5D5YC8gJDM00lsIV5W1aaZmjIoKxIPtj4kPhgmSsScBfsPAvLBxr9k88wJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhFtxBpD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhFtxBpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9231AC433F1;
	Wed, 21 Feb 2024 13:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522019;
	bh=zUYoMEy2R+R8IFJwBMMZ0gC5cLhX5LfXH+Al4l7cLzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhFtxBpDemaMevzClzVCk0ax/+dTdkyDag7SU7TXuNXNmyIKMp4ERXWCquL8KUwGe
	 Mkg83fqAfONh5ns8hEJ9lvbHJaj8VuuGcWoKji7NLABooBHQez52FuuqJLVuGIcZNs
	 rmMmBKmJlxyGpMHQvxVBbiW2IzOi6NUMbXLlUdlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 028/476] arm64: dts: qcom: sc7180: fix USB wakeup interrupt types
Date: Wed, 21 Feb 2024 14:01:19 +0100
Message-ID: <20240221130008.953930578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 9b956999bf725fd62613f719c3178fdbee6e5f47 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 0b766e7fe5a2 ("arm64: dts: qcom: sc7180: Add USB related nodes")
Cc: stable@vger.kernel.org      # 5.10
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2774,8 +2774,8 @@
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 8 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 9 IRQ_TYPE_LEVEL_HIGH>;
+					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 



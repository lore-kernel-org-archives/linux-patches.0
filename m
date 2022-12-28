Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB3A1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410A6C433F0;
	Wed, 28 Dec 2022 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243321;
	bh=K/2lHATCUDGDwNG0ggU95o7p+VZC/cnonyJH/OT+EKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2wyJwo0SfFJIqBkwDRRqtX2U1XBeBM0v5ARqyBGxBJYuRrFEnjvlcfN8oLN5mOe7
	 NBou+Yjf1J6qNAhB6BwW/fUHgSxbwqCcEj+1Cvd+OfRQINPEU2z+78Ru23UBDbKXDM
	 6/7rkxAnj37jxGUFhKqXW9F+LWe1awy1q4dAxdKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 708/731] arm64: dts: qcom: sm8250: fix USB-DP PHY registers
Date: Wed, 28 Dec 2022 15:43:35 +0100
Message-Id: <20221228144316.975910342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit f8d8840c72b3df61b5252052b79020dabec01ab5 upstream.

When adding support for the DisplayPort part of the QMP PHY the binding
(and devicetree parser) for the (USB) child node was simply reused and
this has lead to some confusion.

The third DP register region is really the DP_PHY region, not "PCS" as
the binding claims, and lie at offset 0x2a00 (not 0x2c00).

Similarly, there likely are no "RX", "RX2" or "PCS_MISC" regions as
there are for the USB part of the PHY (and in any case the Linux driver
does not use them).

Note that the sixth "PCS_MISC" region is not even in the binding.

Fixes: 5aa0d1becd5b ("arm64: dts: qcom: sm8250: switch usb1 qmp phy to USB3+DP mode")
Cc: stable@vger.kernel.org      # 5.13
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221111094729.11842-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2306,10 +2306,9 @@
 			dp_phy: dp-phy@88ea200 {
 				reg = <0 0x088ea200 0 0x200>,
 				      <0 0x088ea400 0 0x200>,
-				      <0 0x088eac00 0 0x400>,
+				      <0 0x088eaa00 0 0x200>,
 				      <0 0x088ea600 0 0x200>,
-				      <0 0x088ea800 0 0x200>,
-				      <0 0x088eaa00 0 0x100>;
+				      <0 0x088ea800 0 0x200>;
 				#phy-cells = <0>;
 				#clock-cells = <1>;
 			};



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9691A2103
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F6CC433D2;
	Wed, 28 Dec 2022 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246626;
	bh=DdwE8nGV7R2/8VF/7Z3y2CUgJ6sF/dlFB5LQu3rt0F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJNby+5HZBg58n0UM8GYySxNQHoQRcS3MkS57SNjBXElE9o0m3AutnMBLu3JU13Dp
	 WPwhw/xFWmL3Mn2zKZbnrjYZRpypNI9RvGx43VYgP24xc7xDcQjd6hPKodx1I+Qx75
	 CLaaZIjFS2bGsPSdp4IznnbkYfFC+DLGjS0EKyOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 1105/1146] arm64: dts: qcom: sm6350: fix USB-DP PHY registers
Date: Wed, 28 Dec 2022 15:44:04 +0100
Message-Id: <20221228144400.172648894@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

commit 347b9491c595d5091bfabe65cad2fd6eee786153 upstream.

When adding support for the DisplayPort part of the QMP PHY the binding
(and devicetree parser) for the (USB) child node was simply reused and
this has lead to some confusion.

The third DP register region is really the DP_PHY region, not "PCS" as
the binding claims, and lie at offset 0x2a00 (not 0x2c00).

Similarly, there likely are no "RX", "RX2" or "PCS_MISC" regions as
there are for the USB part of the PHY (and in any case the Linux driver
does not use them).

Note that the sixth "PCS_MISC" region is not even in the binding.

Fixes: 23737b9557fe ("arm64: dts: qcom: sm6350: Add USB1 nodes")
Cc: stable@vger.kernel.org      # 5.16
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221111094729.11842-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1150,10 +1150,9 @@
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



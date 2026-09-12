Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244321A6813;
	Sat, 12 Sep 2026 07:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197659; cv=none; b=DxJoUK1qUofc+NI55tK/DgYiMXbrCMEQ+YIw7C9pdMBl46aw7FAcQGMaR8qxnLvR+zPK9gDGo9M2uK1eTPE9Iw/b4OIZDGzmV/TfMGyfkhJBaJ93upag8RWpxqE7Wl+JiT+vxOZERB/mh7UwfYJAKQu333cb8DoTEQzNzp1a+I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197659; c=relaxed/simple;
	bh=McaSw+mTLq9KLXJ02Br2VIyoh5l9+kBlLMEKKRo0Ax4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8Fwi2LaxJ/bLfGKqF3PBh83cpH0zN2U3OZ/qroX56g3iOjrk2Ynxg40ERqnTaAoTH66pu7I2UpxbwA5Up40Yz2VTRcFRU40vginG2LK2O9VpGDkj1z2Mcw0J6ZFay1sBkaRkZUfl5H+kZofy7hkEVoY91QzD7FZ2ockW6Lqc1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuQtOJDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuQtOJDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D019D1F000FF;
	Sat, 12 Sep 2026 07:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197657;
	bh=J63Pe2JT5HCRP44f6R51LU9OX014vIK4VftNT9SyuPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vuQtOJDb6K3X7M1JZr7+IcXV55SQD6EfokOnNcYY/7YcW8lNoZHHzGGWT38l4+z96
	 cIPhUSDoJGgfHZ5IvI0uOvyr6w9qs6i4kWElLQ4a8129oSzYHihsf6LAuHQ64zSOsy
	 RxCmAtdnPzSRyMXrBaCsdqH7keKWKA4ZO/aMYtVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0219/1815] arm64: dts: qcom: glymur: Fix gcc clock specifier for usb_mp_qmpphy nodes
Date: Sat, 12 Sep 2026 08:32:49 +0200
Message-ID: <20260912065654.134027070@linuxfoundation.org>
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

From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>

[ Upstream commit eca50d95b60cdcabb82a8e1b727fad2547e52f1d ]

usb_mp_qmpphy0 and usb_mp_qmpphy1 have #clock-cells set to 0 so they take
no specifier. Drop the erroneous QMP_USB43DP_USB3_PIPE_CLK argument.

This fixes the following dtbs_check warning:
clock-controller@100000 (qcom,glymur-gcc): clocks: [[59, 0], ..... [0]]
is too long
from schema $id: http://devicetree.org/schemas/clock/qcom,glymur-gcc.yaml

Fixes: 4eee57dd4df9f ("arm64: dts: qcom: glymur: Add USB related nodes")
Signed-off-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260602-glymur-fix-usb-mp-qmpphy-clock-specifier-v1-1-19c6f44d5655@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 5997078575206..02bd6dcd99579 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -786,8 +786,8 @@ gcc: clock-controller@100000 {
 				 <&usb_0_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
 				 <&usb_1_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
 				 <&usb_2_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
-				 <&usb_mp_qmpphy0 QMP_USB43DP_USB3_PIPE_CLK>,
-				 <&usb_mp_qmpphy1 QMP_USB43DP_USB3_PIPE_CLK>,
+				 <&usb_mp_qmpphy0>,		/* USB3 UNI PHY pipe 0 */
+				 <&usb_mp_qmpphy1>,		/* USB3 UNI PHY pipe 1 */
 				 <0>,				/* USB4 PHY 0 pcie pipe */
 				 <0>,				/* USB4 PHY 0 Max pipe */
 				 <0>,				/* USB4 PHY 1 pcie pipe */
-- 
2.53.0




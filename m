Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3708717C9A9;
	Thu, 15 Aug 2024 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730194; cv=none; b=WaDteERvQcsfBaHy34wSoESLZO6v0f4BExFiOj2edueYDSQvakNJpO9v8p70YysoIoG76JOCKeFRm146O4MWCRQcKAK9aEnqgKJGeRIcVLzq4Pqt+z9ZJe2CE944bjGQ1KtiDart7mpm9Y64QBs1NT+8+EVtQ+Qycg03PQP0e8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730194; c=relaxed/simple;
	bh=b/ezNmuRBOy/rOKvV6fr3zUqKDPLVO0Nvc3ZosvC8ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocmYHxvD5A1L2t4hkuAupUW1+HTiGcIYYZ5xH8i7RO7qrWxZm69tsOnY9gcGRsouUmMdmS+T0lR+uTZnrEMo++zzDk2JDKb4dM4G2P1mMQHcjYtdD80q0expz5jGzjzxUvN7xentel3+31aQEdeLH2M34p8QfInt2TqCR+Z/HsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZu3Hpe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZu3Hpe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D19BC32786;
	Thu, 15 Aug 2024 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730194;
	bh=b/ezNmuRBOy/rOKvV6fr3zUqKDPLVO0Nvc3ZosvC8ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZu3Hpe2qe0Lo2Jh7xrX5uaPmdrI9QBzFgGjRPEt8j5lHmlBghDmSSc7v6j6v8pEk
	 InCfc5iZfQAnzHT+rP8Uwgbcgra7L4nmzrzErGMMsueZecNnTrNMplZQ6kJTJiQuWK
	 zHY/SthO2uHCn+tbkMQ7uOJm6hRIdibKxS2iDUvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 300/484] arm64: dts: qcom: msm8998: drop USB PHY clock index
Date: Thu, 15 Aug 2024 15:22:38 +0200
Message-ID: <20240815131952.996190089@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

[ Upstream commit ed9cbbcb8c6a1925db7995214602c6a8983ff870 ]

The QMP USB PHY provides a single clock so drop the redundant clock
index.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220705114032.22787-7-johan+linaro@kernel.org
Stable-dep-of: 0046325ae520 ("arm64: dts: qcom: msm8998: Disable SS instance in Parkmode for USB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 42329e78437e9..f5772d6efaa8b 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2013,7 +2013,7 @@ usb1_ssphy: phy@c010200 {
 				      <0xc010600 0x128>,
 				      <0xc010800 0x200>;
 				#phy-cells = <0>;
-				#clock-cells = <1>;
+				#clock-cells = <0>;
 				clocks = <&gcc GCC_USB3_PHY_PIPE_CLK>;
 				clock-names = "pipe0";
 				clock-output-names = "usb3_phy_pipe_clk_src";
-- 
2.43.0




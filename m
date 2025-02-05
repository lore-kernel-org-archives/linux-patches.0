Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8402F158218;
	Wed,  5 Feb 2025 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766776; cv=none; b=Z3dPZ2Lx+Vg72Ft8boNjPOFelJ6C3U+9YFYgo2+iJMbm3RsrbmEIZMOUzINw4EJ7zHboSbH6QhhYcfOs6QILp+ZKBAYv5m8XIfchHWh1wE9p6OD0/Wl1Rrw2ne9IVFrzH4Ylho6wty9WQeNID+qrqVTztkL+1G/qmpHqSOWVab8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766776; c=relaxed/simple;
	bh=iLR6mEp7yhLBN23lC/2ad1T+bBeQXDLIOdXwvjmm9Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUtNRL+sIL8Ujr39hGhck6WgVJ556qYx9SULADHv2j6sIdFFSwYzKAH5779DOKe6+/01AJ18FlPlmSlbWkMBIckAPmKr6DXcgzqJFNmpAQMeg/9dTWu2i0VY7OO+Gsh4o7hu6E6bMoeX5Q3ROS2+V4BAHWBznONQ9KYLo7l+0xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMZ0TbkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMZ0TbkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A71C4CED6;
	Wed,  5 Feb 2025 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766776;
	bh=iLR6mEp7yhLBN23lC/2ad1T+bBeQXDLIOdXwvjmm9Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMZ0TbkZ9b7mrPm8eTiaiwk7l10fLVYZENobZBKvBsYGxVdDPf2f6RyeJt5tZKt21
	 DCIc2usAj35yYmHy0Q9xa+21nDmJNiXCZVd19+UYeQcczw76gDJCEY4I5pb6kky22x
	 otsXvmjy4e8y+eWQXDhUlua33mhcovcWqrMysKjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/590] arm64: dts: qcom: qcs404: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:41 +0100
Message-ID: <20250205134508.509782064@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1473ff0b69de68b23ce9874548cdabc64d72725e ]

The QCS40x platforms use PMS405 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9181bb939984 ("arm64: dts: qcom: Add SDX75 platform and IDP board support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-4-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index cddc16bac0cea..81a161c0cc5a8 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -28,7 +28,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5




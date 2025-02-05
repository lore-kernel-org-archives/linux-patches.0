Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7993218A6D7;
	Wed,  5 Feb 2025 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767244; cv=none; b=by8ZNdPLcs2MULTC9v9HJ84PviREIk4QCmA05YgbmSwv8nfJF7YdUutKyQAjgd/LewpODXwSts8v+DlKKOBIRq+zyV86kqOXn9oZUHvSlCA82MWKEWfeXi0GnUKBLY9rEJLTiJ2m0Mu1S9E7TS6VV+A3FHLTw1P+6a0t1EoCZyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767244; c=relaxed/simple;
	bh=JiZXV51rkRJJIlqbPpY6nYZbH2OL/lyJkWhHL1AhI20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdiCH8AaW4mokkkaMDTNADMHPD4JiSoVTTLbq7piE/PaZ7O1bIacfTUCUeESB5udO3qCwCvjb2hLEimrt3b+1PLIB/vI7RBaPq0osbOCgduYh/9r1RYu87y2g3QUNT6hOsR0sKG9D8VZY6KZwdaInatKiXJL7EPJQOJTPOTvDaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BLApNAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BLApNAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E790BC4CED1;
	Wed,  5 Feb 2025 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767244;
	bh=JiZXV51rkRJJIlqbPpY6nYZbH2OL/lyJkWhHL1AhI20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BLApNADh8NebbWqn7pId9lCw508RI46P4JfVyxBqUphLqj/pP8cLJYBLjsZRW+0o
	 DI3UT8cOT+oqAbI9sHEc6FhDdzBUco2i2bWFdLs5NsYRfw7ck688t6WZlI/TWya9w9
	 bXY+NktdopnHb2WnoGxBFO3Al/LvbMKuX4Gk2D0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 377/623] arm64: dts: qcom: msm8939: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:59 +0100
Message-ID: <20250205134510.642536140@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5c775f586cde4fca3c5591c43b6dc8b243bc304c ]

The MSM8939 platform uses PM8916 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 61550c6c156c ("arm64: dts: qcom: Add msm8939 SoC")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-2-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8939.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8939.dtsi b/arch/arm64/boot/dts/qcom/msm8939.dtsi
index 7a6f1eeaa3fc4..7cd5660de1b33 100644
--- a/arch/arm64/boot/dts/qcom/msm8939.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8939.dtsi
@@ -34,7 +34,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5




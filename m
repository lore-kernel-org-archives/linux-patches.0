Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F451DB153;
	Wed,  5 Feb 2025 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766672; cv=none; b=Bu0IKCwansNyHOqylAuNteOygRED2OQQsh3kZ65TnzGhz1dy5zJxkXlRgZv2qC1/gHVWyh95BvzOrzV9rMbjq9v93WlLO9ZtNIrdMg3OuEBznvhbDanTb/kb7JoV5et2zI8vEFC4iItdvwP+9SmRDJTBAP0GMuX23ZGZzjZ6Rq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766672; c=relaxed/simple;
	bh=wwY2kTl2Uy+7b6Ws6hMva3BXnVIeEso9XYR9Gz0zae4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uABKLBxhfsitYWdjkHgyOiSo9mESHiSFgsx9bCGsQGx7/3SWozt+VmW9jye/LWKQzSbp3e7R4icP2p0w0dXafV8orbx0Dl1lW/X6unZk1VzJTEb8wn6ANbV4nz2TmCLgC6wgkl5/6D4uEr5yKEJopJ0cw4iWNdjz5uuTRvoIKG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsuwO/oU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsuwO/oU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEFFC4CED1;
	Wed,  5 Feb 2025 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766672;
	bh=wwY2kTl2Uy+7b6Ws6hMva3BXnVIeEso9XYR9Gz0zae4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsuwO/oUBNnMYLm4nbQmF6Ifm59ndmBuwFYXHTYQTvztb03Z6DwC0RhQUs59nyZI/
	 Z1wIVYfB9rUT+brMsY7XEaZT5th7bo5Qf4Tww9Moy+tkAy+2xrH7q67LRXacz9/M65
	 b/GKJHDw8aRrlf8mAw80M7qrmjsd69YMZfpLMki4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/590] arm64: dts: qcom: sc7280: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:44 +0100
Message-ID: <20250205134508.624356625@linuxfoundation.org>
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

[ Upstream commit f6ccdca14eac545320ab03d6ca91ca343e7372e5 ]

The SC7280 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 7a1f4e7f740d ("arm64: dts: qcom: sc7280: Add basic dts/dtsi files for sc7280 soc")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-8-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 3d8410683402f..8fbc95cf63fe7 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -83,7 +83,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5




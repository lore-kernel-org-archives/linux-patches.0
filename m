Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99B422D7A6;
	Mon, 10 Mar 2025 17:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628936; cv=none; b=WQF7yVNKGM3I9q7JmbDkSlOjCkH5xYE6Iv9i4gu4qPRyAMpb306DIOBkBBzZ9rJ2z36wiJhC0KOZ2j+NMM5Aw+LN76sCRxqci9foD4uDUm7d8YV6OuNV/eCXmSCKCDUNd76qFaohgWE7cp+9dXHv+gChRFASFCqvsQ8bd11BipY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628936; c=relaxed/simple;
	bh=R/4ciNRLBsNy0ryfpcOPc4bLKHs2u9QERZ42ULH/sNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLQsoRP+Ly8htg4W1HJh+AaI5r9eyV4kUsj7e9NGZ0r6Y/oqQbzgYUEvjmlOvN5WBX7NvYMeoK1A5rZuJcufmFn/812u0enP3RfKLapkMK2XctTzXjq5N1wgYdGeJ2u+uZCLlajFhV5zPUtEDRhVDrWy66bq9yEapZtfLULafWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3CE579Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3CE579Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29992C4CEE5;
	Mon, 10 Mar 2025 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628936;
	bh=R/4ciNRLBsNy0ryfpcOPc4bLKHs2u9QERZ42ULH/sNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3CE579QFo8Q04ulSXbGgKWjbaro4qSm4gTmn4lkVAUNBuiFgXYmOyJ2Iqj6CDs6l
	 D6GidtE9QEjS5DNrD+NjaAesJE/kxPEyReAIYe3dpaspG+QQGo4Uo89v9vJIffaunA
	 0akPo9MzeJ3HS2DJV1e4jSkh4pVDd3cAUP3w3WlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/620] arm64: dts: qcom: sc7280: correct sleep clock frequency
Date: Mon, 10 Mar 2025 17:59:27 +0100
Message-ID: <20250310170550.377372944@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 929fc0667e985..c65f3c9a6673f 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -39,7 +39,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5




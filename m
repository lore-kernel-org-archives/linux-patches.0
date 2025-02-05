Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F0B15CD74;
	Wed,  5 Feb 2025 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767303; cv=none; b=D91aV51spl+Exxkn5UXKce3kTKz9faqInY9AG2bWZN4fTx/ywWGuD34EYcN0kg/JhHGfTWHYf1TYir3ROjtPhPt37N+vMlf81YOueDwXKFGZMog2zqm9oldL3WfwSBhomNLLsLwJzQXFrs44CLdhkCYaITC7tck3pEFzaAWSpPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767303; c=relaxed/simple;
	bh=t6CbGRZD8J4BeMEu0O1d+9Jtw0QEoI8Kscyv+mDfuT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7nfQUFgOv2sapmFS1+ETbDozEaCUb6Gm/R/wszF69cBbK/G/O6d+Rj9WW/P6LQGJb0IPmIsv/GYTG8OB2A6GCVgxgaC7hb3nS5h6J/Un5NREkS52Y864nRSk7VOdsTx7HD5eRLYuVyfCYdlhSTWB7vuEyshouipj0oLznhGxlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T89cdfoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T89cdfoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEECC4CED6;
	Wed,  5 Feb 2025 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767302;
	bh=t6CbGRZD8J4BeMEu0O1d+9Jtw0QEoI8Kscyv+mDfuT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T89cdfoEJtuwOik36DYs9ZshLR9DTTPjtOVW+SANRQ5vnSz50fn3CvyHxye57zZ8L
	 s0tMGCydYD01A0qb+pxFib02CR4ZgjKdcZwjmi5Z0h7Hx/JeQ2cHoG9zdXcWcf5m8B
	 KbGDKNUsqa/jEk/lT7Wt85XU3Crbu593kXlw2LEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 385/623] arm64: dts: qcom: sm6125: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:07 +0100
Message-ID: <20250205134510.952363980@linuxfoundation.org>
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

[ Upstream commit b3c547e1507862f0e4d46432b665c5c6e61e14d6 ]

The SM6125 platform uses PM6125 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-11-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index 17d528d639343..f3f207dcac84f 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -28,7 +28,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			clock-output-names = "sleep_clk";
 		};
 	};
-- 
2.39.5




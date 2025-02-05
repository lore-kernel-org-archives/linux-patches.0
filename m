Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF993522A;
	Wed,  5 Feb 2025 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765266; cv=none; b=G/t4/fzMZbmBSP1kiKRIZCL6RTJzYfTC2AnF77LZA1Kx3w+vEir4/5bTgQeXEPi2d9tGs1jP98bD6XkoPkOCw6hLQKyIyvcB9xcxtgi4efM6GPhgRv584G8e8wXo4RcNs9bag0ybwFuKinyGX1HPSAGbUDcjXaAqD4PNq2UPde4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765266; c=relaxed/simple;
	bh=z6vN4hqLBTm/8VyEJDlf2Boh9+Prnv3VhN0RQH6P+MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsBSVlfoIAEyLt1CAaKTSrwnph5kiK7KwoPbUfudTMGmcgGR8AM6VbA6dcZdAOLCNh22MvvdoxA5B4kPS4zHbf6q1/iB3OZrwhZV1cuEJDjTa+Mb1zXqUyEEynnmVApvuqKemKDjCtMgWBDC4JdSsilS3SLsLwzShHOtZ6u5D/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4eisRN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4eisRN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E781C4CED1;
	Wed,  5 Feb 2025 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765265;
	bh=z6vN4hqLBTm/8VyEJDlf2Boh9+Prnv3VhN0RQH6P+MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4eisRN+LxlQeIQOuethCE1rtmh5/dH5ExAYuAoefii/my++KZMV4dNvupP6Ki44V
	 d+ymrOBOynhKEvHmnIy6ao6/NrXKnh3AZ6hhBp13offhriB18ovoJe0XZTETH7h0F3
	 5d3vwqCae3fOyfvnuZYmvs3w0E5AOundIi84hi8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/393] arm64: dts: qcom: sm8450: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:47 +0100
Message-ID: <20250205134429.795184974@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c375ff3b887abf376607d4769c1114c5e3b6ea72 ]

The SM8450 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 5188049c9b36 ("arm64: dts: qcom: Add base SM8450 DTSI")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-15-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index a34f460240a07..007689d7f4fa2 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -40,7 +40,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5




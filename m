Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24091DB15F;
	Wed,  5 Feb 2025 14:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766666; cv=none; b=KqujefPsXKIdlxLJG9Yc5Y+fxBy4yxhadk6vLrf8Vn5defYu8sqt6RLmZd0aOSbRn5zDZINua5M3MyatLzWJ+PALJgQvrqLLJoLHwXQRBrKzQqT3kdwACArpaGZ0ll8uUm5TnGeZ/M7tZyMjll5s1WHnGsM4Q6rw2V1e6aP8Lzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766666; c=relaxed/simple;
	bh=BHSMzjVVpQLv3RKViSJ7WjTqr5AIx2I5CBX8evWbBfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJNAFV/R79sOmuSqdULcLzSouhgbdvObUQ4C0l1xbGlDJhoq/GYTe7TKh20CR3RJc3+bs9ro+KMRR6iVFKJLFvf9TJg6Tiry2pEC2bUVCsRteOLD1+SFTPtX+HbfzbuEueG1kv1xMlj3XZZ3RtWldOiOLmwD5/wPYBI/pCR1d50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BZvHeBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BZvHeBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7792C4CED1;
	Wed,  5 Feb 2025 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766666;
	bh=BHSMzjVVpQLv3RKViSJ7WjTqr5AIx2I5CBX8evWbBfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BZvHeBJcSwfKKi/pNjTRJQN/sy4P2b8nsj8juOQ96PtgC5SpWIwKB/lwm7iA8Li1
	 Iz3jWxrUmEExRAy+Dq9ZFmm73ZzoeeRL+t06cWMGLIt0Yeqi3IyfNCmBFPVAHihqLZ
	 UiJ3QXPEuf796t1jH1+0XNapJA3lERUMMJzilNbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/590] arm64: dts: qcom: msm8939: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:39 +0100
Message-ID: <20250205134508.432791031@linuxfoundation.org>
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
index 7af210789879a..effa3aaeb2505 100644
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




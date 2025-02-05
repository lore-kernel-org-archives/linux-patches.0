Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0DF1519BE;
	Wed,  5 Feb 2025 14:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765253; cv=none; b=mzQnCV2slFBYENEQYWtXdRkkTOCxOv/r6ujGUu/i5jU+Id7u5UgaAId+8/V2FzDuvG1en4p0slTuuzvPmyupqSAe//q2bbzKuBfPOjUe5iybjzyZGGxaLUUVWarIv7iztc8ytGD1qI6bpRZhsdUTDjaghOxqTVASUTRwdBkMEhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765253; c=relaxed/simple;
	bh=lz2p8uIdDz5edkBt5R91chzMZCsswtWeUYhjmajYvr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1LOglVq9S6ERDV1q13kpGgUTe+xMn/D3SbpuZh6UvUzTKrAaHZG9wD6hGojVlzgNgZzSaWhccXEsUFSy6sFKdEnCSbhbF7hYCAqGqbREjwNzJPSnjT8gf8eB8AuXLt8xv2B2u7u4NOvwED/TeCytosZHOkJDcddFgNZFxaQN0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hfnky/28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hfnky/28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E16EC4CED1;
	Wed,  5 Feb 2025 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765252;
	bh=lz2p8uIdDz5edkBt5R91chzMZCsswtWeUYhjmajYvr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hfnky/28NEqjaPsFHpfN0jnXpNatn+hP4ezZuL/Tl3+gJ1E7MnkRAHE5N6+I2H8VW
	 5S+DGWQuufhLiaSVOdOzB/t2KqYIMnB+Rx6nRYw6TIyynzUM7htcRndP/JCBmvLSQr
	 hIkxFL/ZhSN8sBO/U02ZsJhOxeYVpdsoVoSH+z+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/393] arm64: dts: qcom: sm8350: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:46 +0100
Message-ID: <20250205134429.757901945@linuxfoundation.org>
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

[ Upstream commit f4cc8c75cfc5d06084a31da2ff67e477565f0cae ]

The SM8350 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-14-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index d4f1b36c7aebe..dded95fa52f07 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -40,7 +40,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5




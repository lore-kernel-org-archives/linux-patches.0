Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B858533993;
	Wed,  5 Feb 2025 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767275; cv=none; b=Mx4/9i10MvWpwOofzBYyXnsPdfotujYxKxXZvgqMkdSsgrKI/c0sCXQEXoC2QF8VpJlZ4iBH8ZwGUr4hVTOPV+zwyH/KANOCgEWi6a0EsQYgiWWQo7iS9QoZkZZXkfmJtlBHaYtuDK4b7hmSqqXvI1Kf8aEaPzZAd0q5u1YduWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767275; c=relaxed/simple;
	bh=huyLBH3zyMW8rbONc1H8f3Uo9M6fNDuQG/Zr0uAXvHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahFbBmgI4B2LjqQpZiFG1O9ttpK3yWTYrXf8LLImA8POvZY2Bpks963qhnTTnkl5FTwmqJ5xJfhBxuO6wNCJYsDRTpqh5ZEsiws9THT/WWJ2qdcHQUA7UprMuJ7ZgI2ESKK3RYMOVuMtl/r/gedPZwA5/FRvYXdnnBkCJfcTgNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4C9o0sX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4C9o0sX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7AAC4CED1;
	Wed,  5 Feb 2025 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767275;
	bh=huyLBH3zyMW8rbONc1H8f3Uo9M6fNDuQG/Zr0uAXvHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4C9o0sXyu9Pkyl29Z2N86xkdIwNwb66HJ7aOQLrHoGCo2qgtMjPxRvLXGMenv8el
	 XOK9s4DKZz4upOIO65yumhk7QarrohQoQovj+kd8q93JBb8hSwImFzCoRP7zFvKHhC
	 PGfQNGk+CFbe1i/JMGCyWLKyy5XTgBI2T7XoAzUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 368/623] arm64: dts: qcom: sa8775p: Update sleep_clk frequency
Date: Wed,  5 Feb 2025 14:41:50 +0100
Message-ID: <20250205134510.299708462@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 30f7dfd2c4899630becf477447e8bbe92683d2c6 ]

Fix the sleep_clk frequency is 32000 on SA8775P.

Fixes: 603f96d4c9d0 ("arm64: dts: qcom: add initial support for qcom sa8775p-ride")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20241025-sa8775p-mm-v4-resend-patches-v6-1-329a2cac09ae@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi b/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
index 3fc62e1236896..db03e04ad9d56 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
@@ -608,7 +608,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32764>;
+	clock-frequency = <32000>;
 };
 
 &spi16 {
-- 
2.39.5




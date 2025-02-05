Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CCE1FC7C2;
	Wed,  5 Feb 2025 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766837; cv=none; b=H4lFWdk2OMi2xpuk7bWYlLk7A2WInu19f2lneWBkTHBEFtVB+FDWYHufT9ppwfYR2xZv8fi6bdN721/LOjKaNm0y+8QVgcf3dSq2EVm7ggJYcVDJctRwvMV7f1uy02RPfYTkiSeSNH3d4ho02s95Bmy+1qyMxHuSti8U6/DVNik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766837; c=relaxed/simple;
	bh=CVOyGpTWt3qHXDh5PYFOKfoKCVbRKOp/jthwZrKHjBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bj6WAMtf9qC1KjYqak0pwHNXa/q4Havltwms0ZNb11+DO7/JUFwZVoPhUEX3+3JfqusLYQScENMwjpkN/QcoDwzzMYe/fcZ3+g0QZLFVdJRv/iSpI12+zNIQGD3axcpjlmwsL8vZI0go0hTcQIxhlUf2SwlTpFi1eMu3Gyn3O8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaIOwS3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaIOwS3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429D3C4CED1;
	Wed,  5 Feb 2025 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766837;
	bh=CVOyGpTWt3qHXDh5PYFOKfoKCVbRKOp/jthwZrKHjBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaIOwS3LqDKTHCJv6lAZ8nUMlQVMm0wSk+lhouZ2ID6G9N/Yb39mHd+sngRK9i+jk
	 JpIl0kHu1MsnYylzqxM5uPc7XTCY7QLDAf9EAyGDTb8NGTzDK5u6lceYe60fIVKBLP
	 9ArnNDDzEGb/Z0WFCt+MCyQnmAFtPA48B+glHQVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/590] arm64: dts: qcom: q[dr]u1000: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:42 +0100
Message-ID: <20250205134508.548151777@linuxfoundation.org>
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

[ Upstream commit 5546604e034b6c383b65676ff8615b346897eccd ]

The Q[DR]U1000 platforms use PM8150 to provide sleep clock. According to
the documentation, that clock has 32.7645 kHz frequency. Correct the
sleep clock definition.

Fixes: d1f2cfe2f669 ("arm64: dts: qcom: Add base QDU1000/QRU1000 IDP DTs")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-5-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qdu1000-idp.dts | 2 +-
 arch/arm64/boot/dts/qcom/qru1000-idp.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qdu1000-idp.dts b/arch/arm64/boot/dts/qcom/qdu1000-idp.dts
index e65305f8136c8..c73eda75faf82 100644
--- a/arch/arm64/boot/dts/qcom/qdu1000-idp.dts
+++ b/arch/arm64/boot/dts/qcom/qdu1000-idp.dts
@@ -31,7 +31,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/qcom/qru1000-idp.dts b/arch/arm64/boot/dts/qcom/qru1000-idp.dts
index 1c781d9e24cf4..52ce51e56e2fd 100644
--- a/arch/arm64/boot/dts/qcom/qru1000-idp.dts
+++ b/arch/arm64/boot/dts/qcom/qru1000-idp.dts
@@ -31,7 +31,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5




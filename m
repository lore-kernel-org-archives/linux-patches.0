Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE85B1519BE;
	Wed,  5 Feb 2025 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765237; cv=none; b=R6s+JiTfJr2yoF4+uphDXZIzy1rYEsuYHtV8F7UX+5m1p2oHP7xJa640rluO8ss3OKZwxev0nuWUCneuSCVQtEDsrvTaU9Xkk4gL5S54WGum90MEtlJahlhZ2iDb3QERyPTFgBx+n4626TtZ1JWo5D76S+egeE7SxijQwt1DrVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765237; c=relaxed/simple;
	bh=NyXTl0VOoOrQrtnaFBxqUxOa7uNb0JFVwJSBHYHQnCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vC3VLlCnX8mbU0bs2kpt+bIzj0fjTipTDwuJOFJd4ykAdX+6k6S4yWu5h9MJnoeiP6P21fMPQwMQYntpv9eOF2laIIEqlPdHQhAREji6WyOOb37PC9RAT3xzy1jh6/pd94OH+iB+4t5p92mlkIKXX7/QWHQ30pwVbgB5e7gn6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPz9JhSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPz9JhSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F242C4CED1;
	Wed,  5 Feb 2025 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765237;
	bh=NyXTl0VOoOrQrtnaFBxqUxOa7uNb0JFVwJSBHYHQnCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPz9JhSAyzlPm4KpavCQ1qNqFRIwEtcN4EhXBZLDXLMQ4Zwqrzwxz0s16e6c+y6r7
	 0YuV3MSNovhAwKjRMJ43smyY34nIy8kbIV+J/C7P8FrloMraLsFWPzQWEYh5XUWfQU
	 T5uEvFc0iw1TiWezWpG9dY9MUy1vEmYgn9FFAp60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/393] arm64: dts: qcom: sm8250: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:45 +0100
Message-ID: <20250205134429.719859701@linuxfoundation.org>
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

[ Upstream commit 75420e437eed69fa95d1d7c339dad86dea35319a ]

The SM8250 platform uses PM8150 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9ff8b0591fcf ("arm64: dts: qcom: sm8250: use the right clock-freqency for sleep-clk")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-13-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index b522d19f3a132..88e8f0437e938 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -85,7 +85,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5




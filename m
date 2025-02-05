Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4978186348;
	Wed,  5 Feb 2025 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765205; cv=none; b=BYno9J7nQDUxrjWzfsSQZBUHgRblnBtFmCMffJL6Mvlq6dwowV6YNChCaYaVk4frY6jez3OIu5fkQi6tCqfEWY9Gyp0hkj8ZSgv9bzT587qaHFE8ayi+2O4h0QTMPncm58rra3BrqLEpP9F7hciuGSWLvnkrL+1r+Ph4dtbdKFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765205; c=relaxed/simple;
	bh=aA/IcsQwryif1TZgonu65Imlvbgm2Ai9LPMf86aQXWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zu0K0CPZWDxWJqhthIqvbsk62mOjpqUvmNcJDZZHzOyQDeuAWKM6iZ+XU304AGgMRO5hyQwX27SzuFXuPQo17XUFzjgwsLA/oVARobDcq/SfW9ckC6rEWFP1u+pjSd7bzMkOMtBSVZTQhBmIYWAfTn6TRFqrFeK0wKrKdJpZWZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EitCV9gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EitCV9gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9792C4CED1;
	Wed,  5 Feb 2025 14:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765205;
	bh=aA/IcsQwryif1TZgonu65Imlvbgm2Ai9LPMf86aQXWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EitCV9gcZpgoNIoyJrVP8S7F6BCj0UJ9ZEZmivq+CBXY9AeyB1h2ifkCecq1aeV20
	 7R4pK9z21g16N8eihvFPsPcUZT1jC1JT00Q0ZohFvfBp8eqKecN0Qd/Lk295w81ssN
	 fBtpVM4gSAm6dXtHZXlDjy8b6yu/3MWqvRpPRzJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/393] arm64: dts: qcom: sm4450: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:42 +0100
Message-ID: <20250205134429.601969555@linuxfoundation.org>
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

[ Upstream commit 158e67cf3619dbb5b9914bb364889041f4b90eea ]

The SM4450 platform uses PM4450 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 7a1fd03e7410 ("arm64: dts: qcom: Adds base SM4450 DTSI")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-10-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm4450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm4450.dtsi b/arch/arm64/boot/dts/qcom/sm4450.dtsi
index c4e5b33f5169c..51240f45c8e84 100644
--- a/arch/arm64/boot/dts/qcom/sm4450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm4450.dtsi
@@ -23,7 +23,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5




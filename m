Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764EC423A61;
	Mon, 20 Apr 2026 13:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691667; cv=none; b=u9859Fu8kpPEXVehv6kn4c72c6lvSciz0owuNdDdL0avO9nCAG8UcAv6cGaGn9doWY8JiegyeagQN/6hUbhOtDxLL3fLNt4UO8aMXa1mBTvUshxnjnBLNWge0wfgGdQTFxmfv2EKPT5mjVGFePGoe7iP9eyIHPvRiQGoBlGkARA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691667; c=relaxed/simple;
	bh=OmmxsabJzBJrL2Ch/21GzDM4yobf31hGV6JyOlyz/jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rS+UhEZh2o1GkHCi8uKPYJo7dz66yjbu3i9obl+2XJ1STBYobYO7vNBwx9IY9ZeP93WfVbhgkn8DaR0FN9a3ElO9C79tzFCY7r/4eCcE4hFzKHAFT6QfpQrvDrW5udG+u/YL7WPMpi/LRaMZUcK1vauVd5KSwlR4Xn8T6/LHOAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1xO3kOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1xO3kOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4AFC19425;
	Mon, 20 Apr 2026 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691667;
	bh=OmmxsabJzBJrL2Ch/21GzDM4yobf31hGV6JyOlyz/jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1xO3kOqmrVgWL9I1Lao5bAPbmyJp8aWzaeB4tFTURr6pTb+jI3YGIdxcPOA2Gqp9
	 DO7teNpTkJQdU3bmwCAiySZP5cVvFTUj9k4GdTkQqY0fpxdG6/UpF5UDzJL902BZaE
	 saIFBEVQon0rzxuvpUlLdq6PG3xBm2cioy53YETKHjAYoSPIQraqFvmOYnFE9pZC3n
	 5YC/8JjsKTzkffzn0REP3H2lZiUZVWdbN2Zah5JQLx+MXVXDCEqQWgUGDGJxjdWxoN
	 u28j+G2CBoyxWzkgHWvRgd6sAlZMXqJFNEOB9iJRY59eow4Yxtjf1W5RQHvzPvjNOW
	 pOWI2HsiSFDQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel J Blueman <daniel@quora.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] arm64: dts: qcom: hamoa/x1: fix idle exit latency
Date: Mon, 20 Apr 2026 09:19:16 -0400
Message-ID: <20260420132314.1023554-162-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Daniel J Blueman <daniel@quora.org>

[ Upstream commit 3ecea84d2b90bbf934d5ca75514fa902fd71e03f ]

Designs based on the Qualcomm X1 Hamoa reference platform report:
driver: Idle state 1 target residency too low

This is because the declared X1 idle entry plus exit latency of 680us
exceeds the declared minimum 600us residency time:
  entry-latency-us = <180>;
  exit-latency-us = <500>;
  min-residency-us = <600>;

Fix this to be 320us so the sum of the entry and exit latencies matches
the downstream 500us exit latency, as directed by Maulik.

Tested on a Lenovo Yoga Slim 7x with Qualcomm X1E-80-100.

Fixes: 2e65616ef07f ("arm64: dts: qcom: x1e80100: Update C4/C5 residency/exit numbers")
Signed-off-by: Daniel J Blueman <daniel@quora.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260220124626.8611-1-daniel@quora.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 6d97329995fe7..efe8d5e7079fe 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -281,7 +281,7 @@ cluster_c4: cpu-sleep-0 {
 				idle-state-name = "ret";
 				arm,psci-suspend-param = <0x00000004>;
 				entry-latency-us = <180>;
-				exit-latency-us = <500>;
+				exit-latency-us = <320>;
 				min-residency-us = <600>;
 			};
 		};
-- 
2.53.0


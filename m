Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FBF33EA;
	Tue, 11 Mar 2025 15:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706635; cv=none; b=C84/AbqGGBn2nyzaj5vz3lMTiyMhdsWpm2dRpCVwlrlSiVz0n6Wnil0F0mrjvStSIoMLVRE8q4QU5DiKEpZpDwOBT9pPxIBI3QIzjgwRdGP9MaDqX6P8DOa+6+6urDn0ps4V/4UO7vNpJHQdgCAqSvoDQ7s2ic8Clru6nQ371Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706635; c=relaxed/simple;
	bh=9QgfEaPmxAa2D3f1nm2H3LMhHJ8MwHmK66JyODO7cZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h51VYA+oQL+ODw9Z2eFaTyV5wacvdM/qogULKXe/rJ1coaXSI47vkYFggfYSmm/Q1gN4Wu4ni97XD0kJvYLZS9kacc+4YDBewaOf8L9exu8/NDzDd+rlj8ZkdHH7WuOTQRAZ3fJOEyHpq3fB7L+GNpgopOl6x0B7RwbCagkFY70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QN9PgEBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QN9PgEBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F815C4CEED;
	Tue, 11 Mar 2025 15:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706635;
	bh=9QgfEaPmxAa2D3f1nm2H3LMhHJ8MwHmK66JyODO7cZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QN9PgEBjiA+RZoU05bEd/KpPtE7CsEXoiDhfyBLjhaYCdQ9oCgKz3KR5DZIhIb12m
	 xTyloDCw4JTd1BZWjtHa78iOC/ZK9btmuSeHX8IDFmnT86xUqZ0cDU0vyoLsy2DjYY
	 d0QUFDc9R8NwrltocPW0KNekiI3gXPOra5kSK/EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/462] arm64: dts: qcom: msm8916: correct sleep clock frequency
Date: Tue, 11 Mar 2025 15:55:40 +0100
Message-ID: <20250311145801.272799154@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f088b921890cef28862913e5627bb2e2b5f82125 ]

The MSM8916 platform uses PM8916 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: f4fb6aeafaaa ("arm64: dts: qcom: msm8916: Add fixed rate on-board oscillators")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-1-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index c39a299fc636f..4e0441d99eefa 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -104,7 +104,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5




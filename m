Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F9E13C8E2;
	Wed,  5 Feb 2025 14:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766708; cv=none; b=Lq6Htkwdb1R04/6ZA3RQfFh0zky9S6BSyUOXnzLKSmX6qS0ddkoebimLj0u2SU3lRcHGHcH5HEqMaN9wVXpGZOWziKz97a+uViUWVIYxNs6mGXfK1w2NsB9BJY9huHLFSnQwUwDVBuVbD28u0pcnUlNOjdc8bZN4pt707ysdqY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766708; c=relaxed/simple;
	bh=wPo35ld3lvoTuCIrsWMnZS2Wa+Zu0XSvfFaSvla15Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFT51FYCDsXQEYYkaSYqXDpnaKJB28zEhIJVP8lCzxZ+gfqpyQIp3rl458QM8fcFO11h0gpMrzKqxzMnl3GgR7sy0aepTS8PqLqgwFW9LAhn6KqAoCLgqJkATrGHnNsajztLQ2SyT6QXuafwx8X71yfSVGma7VTT8ZokfqQPDeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grxwRpgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grxwRpgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF38C4CED1;
	Wed,  5 Feb 2025 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766707;
	bh=wPo35ld3lvoTuCIrsWMnZS2Wa+Zu0XSvfFaSvla15Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grxwRpgO52wj4c4MC1lJwl2kahb1ZN/6Bpu6P6YaSjyY93yebzUw0l8arjMzgMUjC
	 0cpY3AsqmhlzCcQeJFQUL8+aLHAwPHGVa0KBxXzeYn1F98fZwBkE71kRc1xD/LKMMP
	 S2IpQzX7o1GmFravOcJEjora7YZdLCmsDS9psMTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/590] arm64: dts: qcom: sm6125: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:47 +0100
Message-ID: <20250205134508.738035371@linuxfoundation.org>
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
index 133610d14fc41..1f7fd429ad428 100644
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




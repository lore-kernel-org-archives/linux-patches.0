Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C0013C3F6;
	Wed,  5 Feb 2025 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765215; cv=none; b=cdlijt2KkLHhfvpJ+5kDFGTw5nRJrTr0XqQ2UnfIAmyx2WkRT/Pzaec26EDMi093aAOVi4tNYVbxJrr/BjtDEKBJdAZGgB0GKG+r0q65UUi/4+YLLkjnxZJAJpOGcoOWKfSRdInZADCBL9/td/e6BDfdsnVA8mA/lY+RsEtZ7xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765215; c=relaxed/simple;
	bh=2+ho2Pwyo7u6Y4hq4LRSo/f3S3f09DJIVuxumLuvA+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIjNzb+D4abfFVlmV3mte6V4iaE4MkdEhbnevzyn6onxT85QmOt/cviPAngaHsUnP2ku6GiMUrKlYZW2xjmRfNrlv9JZvBEO54Ki1yWBc4P9TBbrhysZDYNY5sOy07n8W/TU12kIV0U36tFlhwccM3AkkejDR6JOT822IeLWWyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCnTs04h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCnTs04h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC399C4CED1;
	Wed,  5 Feb 2025 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765215;
	bh=2+ho2Pwyo7u6Y4hq4LRSo/f3S3f09DJIVuxumLuvA+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCnTs04hbwrHTN3cdnicCdEJ+16kpwjCBMMe5C9vRQfeAxWBW5C93s2mU1o/h8Ts6
	 PCbED4wwe5WHlMkOjM1UlGcvHpVmtF/Tc1FjeRVEAqOvU4MYY5uFIXeuUaij3bq5Av
	 ws6Etdth1Xzm2+GbCwTvWj81wbWgmNwJhIn/FeMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/393] arm64: dts: qcom: sm6125: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:43 +0100
Message-ID: <20250205134429.639420533@linuxfoundation.org>
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
index 07081088ba146..2b2c55132f673 100644
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




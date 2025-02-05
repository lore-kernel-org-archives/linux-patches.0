Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1198B1DBB13;
	Wed,  5 Feb 2025 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766737; cv=none; b=XbaJtUh6+JJ8VTV4wYa3SgtAwANgqUXOfiudnh6ucsi3Oq5cOsqgXgJmJkPc1H9qouormKOXMjnFhnOwOXJwt+wSAoCAbVlp7c9O779VKwW/+GxRY4wQB4F9OwAnKeYDDrVwFSl8x+8xRt2QrpNNUl4ISPHY9mjNLtzkeYPXVhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766737; c=relaxed/simple;
	bh=s8td/iSTPsPhSG7TO7ZRbCYjz2lYZGs2FkErUgThJGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nH5tLFX4sLUfJyUzG1HIjmhr3AlN0K15tY1ebdeak81A3UYU6uo/DWWD4s+/DwRbC040Kvc/q6rPc8akci4VHwNv4J3EDjSdNJLfon7lEDsjubx0AmIumLGqT9EwV9jctF7ngELtiMZpqioCQ6baQqDepBLPpxRvIK+TfzwOAj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xq7RFMF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xq7RFMF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CD0C4CED6;
	Wed,  5 Feb 2025 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766736;
	bh=s8td/iSTPsPhSG7TO7ZRbCYjz2lYZGs2FkErUgThJGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xq7RFMF2fySpx24Db8lfaZLaxllws96gMBs1zsPtiDBk7inXRn0+1jxSOwEEFlFCY
	 NN+PlxM0V/gYsh0S0Wq1qqhvlkUlR92eALU/z8aqw7Cje8PxIEVXrIrcZiRBeVDpOz
	 hWin4qJ+a8+DWqXxbEim4bFH/lcBYNFA9VR7xDB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/590] arm64: dts: qcom: sm8350: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:50 +0100
Message-ID: <20250205134508.850859113@linuxfoundation.org>
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
index 37a2aba0d4cae..041750d71e455 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -42,7 +42,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5




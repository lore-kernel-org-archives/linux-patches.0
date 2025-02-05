Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8035522A;
	Wed,  5 Feb 2025 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765149; cv=none; b=IxoMD5zPaKPnOxe+f1kf1XsWuHJZbmpUCtWdZeySKoiZUgICoFgufyvXmX2vL4v63xZ3TITKEpDkF9UWVQ6B9bfWSFy//Jf05oCKXolLRWlqmByXaXGnG/1thKmeavah6bzt6dMsx8iclGTgK8Q0oNOTUaOOlw0eV6m8Bwt7xJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765149; c=relaxed/simple;
	bh=kJSy77rIMKAmPHX0VYr0iavw0f4o+nfcX5DTtobi/Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhY8HLGX5wZneDH63muExUak2ZHhPv3EDQIQIyMc95UJ+VF68QzcOj/pAp+2I/KhXzOYpObiIbtvdHqYJBCHZ6pgP+VmQyNa3UkjuqSBm9wc7wx6BUT/oEBqVr7CBiR4gLB07YIfyuImi4IHYutFp2Hkn4rmW8sgt+VlNSvfmtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyuULlba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyuULlba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1069DC4CEDD;
	Wed,  5 Feb 2025 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765149;
	bh=kJSy77rIMKAmPHX0VYr0iavw0f4o+nfcX5DTtobi/Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyuULlbarytXBNOBni8yRgTtYLh7NeM3hgdV4NSkKglxlU/GbPf7ntVPX8F8QgBMl
	 2T4WV/tdBlMGOOKOWDBxgcce/SmW1DbmvE/wOIn0jht2jGxlypHdjMG4P1YE7LzDKu
	 oGYRjjv6TF8fleiNzTf+J4Tchg51cTJtn+nHgXtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/393] arm64: dts: qcom: qcs404: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:37 +0100
Message-ID: <20250205134429.411755006@linuxfoundation.org>
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

[ Upstream commit 1473ff0b69de68b23ce9874548cdabc64d72725e ]

The QCS40x platforms use PMS405 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 9181bb939984 ("arm64: dts: qcom: Add SDX75 platform and IDP board support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-4-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index 2721f32dfb710..cbe469cc159e9 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -28,7 +28,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5




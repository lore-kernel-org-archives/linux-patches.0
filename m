Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2EE198832;
	Thu,  5 Sep 2024 09:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529433; cv=none; b=pVa68n+DYW8mdTxMXvCGT6Eo80lMyjzfyia1PZLeLmQJVbOA6osD9v9OX/Zajfj1LzGwjU3VURQNJDGvmCk3lAPT2/l3fycFyIVlKCrSHR1HW+ddubeFQH1rh+Mq36muFxSrgYI0wtGJYDmbjvuZePpAB1VGSLTDzYLV0SkPwjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529433; c=relaxed/simple;
	bh=DM9mgoByS5dkhWbEcJ7on3GAP9yYvQjjjJ+WaIeAhcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1AFQVU93ZJZHBVm47IWktFvLrtvg3GrJI4wvGXvwO7MG5JqPx+ZrAx2RcrNdgAcEPurbw9rMxzmiG9Y3WhKEP5NanNgjsK2QtaoWRMDGi9Bu2SXgHYK4woQBhSyQjaFXeOfYu3fFvG9hVIxHO+knVYxZggmXv0EHeMHn1QCB9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtayQUxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtayQUxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C09C4CEC3;
	Thu,  5 Sep 2024 09:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529433;
	bh=DM9mgoByS5dkhWbEcJ7on3GAP9yYvQjjjJ+WaIeAhcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtayQUxAXLwndR6zTjf9JR7bhRnYb/O7x0FUIqV1avMYv0nYGsBDT7VHXYjlGtD6W
	 K8Ui8L9jF/PdoBfAbkPY3Z27/CpHboGvbX/jlw22+OkhXmWMKH9g9YW5iVJfZYl+D5
	 i2c+jUdzIOYg3gUnAmNGc09eEaX3h3lVqmur82Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 032/184] arm64: dts: qcom: x1e80100-qcp: fix up PCIe6a pinctrl node
Date: Thu,  5 Sep 2024 11:39:05 +0200
Message-ID: <20240905093733.501489576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 0aab6eaac72ac140dfc5e0a38bf3178497762e43 ]

The PCIe6a pinctrl node appears to have been copied from the sc8280xp
CRD dts, which has the NVMe on pcie2a and uses some funny indentation.

Fix up the node name to match the x1e80100 use and label and use only
tabs for indentation.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240722095459.27437-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 2ac90e4d2b6d ("arm64: dts: qcom: x1e80100-qcp: fix missing PCIe4 gpios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index d2c8c860895e6..2cf3ea4f6e2e6 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -558,7 +558,7 @@
 		bias-disable;
 	};
 
-	pcie6a_default: pcie2a-default-state {
+	pcie6a_default: pcie6a-default-state {
 		clkreq-n-pins {
 			pins = "gpio153";
 			function = "pcie6a_clk";
@@ -574,11 +574,11 @@
 		};
 
 		wake-n-pins {
-		       pins = "gpio154";
-		       function = "gpio";
-		       drive-strength = <2>;
-		       bias-pull-up;
-	       };
+			pins = "gpio154";
+			function = "gpio";
+			drive-strength = <2>;
+			bias-pull-up;
+		};
 	};
 };
 
-- 
2.43.0




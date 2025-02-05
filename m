Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEB318A6C5;
	Wed,  5 Feb 2025 14:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767333; cv=none; b=uIJ/8CbZIWZSjbwogN0m0udeLNbbu8o8OJMG8/E2dR9r7dy0MCgxPpubH22TAlYiKydjdLGO9fGvkLY9TlAkBe5q57bVoLKpmFdeXcToQHllN8cD07LdqJZuZ9ZQ7VNNaqNblSneHPG13B/ilHvyrd36rk4+XZ350D9p8Pg+bN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767333; c=relaxed/simple;
	bh=9eUSKwf0hiSVpjRhn/KpflATjTZ0p4ZlHSLSzadcf20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQsd9GdiWRfN57UExOotmX4BZ+f2HMQTn2QLk7jvncxS9BQlWZIkBxfuQdTNIZ6yqpWNEhqWmJZDXnmcabWAxST047rJqmrJZ+DZptcBGnzxJWq0qVpvJvQ8rc8N3vLmDREDAHZKaMuWdfI8tUWO/qmo2mfmSRb3L0t0cAwOwsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUvl8Leu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUvl8Leu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E052C4CED1;
	Wed,  5 Feb 2025 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767332;
	bh=9eUSKwf0hiSVpjRhn/KpflATjTZ0p4ZlHSLSzadcf20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUvl8LeujbzoRezPD8K09Nrb9tA+zSBTKO5Ws6BTIRUWtgi+VwD9XLH9yl69z3fr7
	 aHIUS8qmpRE4coroODDx47+FKeRz1eHJ1nvnpzvuT+SlGIJZmpVVVL9DX6F8UgISrL
	 JHQSLuz8xDACMppW7y7LttRt9E2C9HjEsypDRmVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 389/623] arm64: dts: qcom: sm8450: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:11 +0100
Message-ID: <20250205134511.103246116@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c375ff3b887abf376607d4769c1114c5e3b6ea72 ]

The SM8450 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 5188049c9b36 ("arm64: dts: qcom: Add base SM8450 DTSI")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-15-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 53147aa6f7e4a..7a0b901799bc3 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -43,7 +43,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 		};
 	};
 
-- 
2.39.5




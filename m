Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AC91519BF;
	Wed,  5 Feb 2025 14:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767356; cv=none; b=XIMTlkKhbIFL0yjXrZES3dM5ONGWNlxSERqwV2BxIDddbhXC1WTKVUUWYsD7mMnG9AvJlrVaoxGuEkwC3C8DxM2yE91mXQxbflQOle6/lo/LM6PfggGIdNUbRpd5/JC9TTckSNHyTU5nn5xsXmNohv3RudJpi20rBT/Sncp8MSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767356; c=relaxed/simple;
	bh=u5FSXw5LUMqRC7CcyBtDlt2pqt4T6duAXUthFgdMjHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrLTQxJsDzRtMpsrGTDgDKtdLV8C5NIar9R5LVN9UiTFx/7kRjHRxxU6yrbJcF158wSl7qZbgU3XpWtkgqJPYzl4jlreOhAGhsGSpbz188kQMr3LRGgM/e+LjaDqd6upSPSa/rZp2g+s80CTvFo0sq48YJtMWGiiRGj8jyzkYPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJqNrfXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJqNrfXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A3BC4CED1;
	Wed,  5 Feb 2025 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767355;
	bh=u5FSXw5LUMqRC7CcyBtDlt2pqt4T6duAXUthFgdMjHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJqNrfXP0UJKbfSIax327upsKHfdg0VuF+T9aIw1E7CF/V/BF0eGyA/5gkLXRSYiT
	 DCdO0exzRJ9OdWwLhkwm92tpaQuKECaJDDlv4bAfAtThZguR+aEgskuuPzKLwMJS6j
	 5IwWLuIHUUVFB1iYIGWYsD+1vZuBEfyT1cQBG5Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 392/623] arm64: dts: qcom: x1e80100: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:14 +0100
Message-ID: <20250205134511.218969339@linuxfoundation.org>
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

[ Upstream commit 67e25a3e12d128336114a5d1572e055a8bd33129 ]

The X1E80100 platform uses PMK8550 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-18-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 7e4f46ad8edda..4dfea255c83f7 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -38,7 +38,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 
-- 
2.39.5




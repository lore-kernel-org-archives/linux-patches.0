Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E02C8634E;
	Wed,  5 Feb 2025 14:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765580; cv=none; b=XGzbDA9ZiLeyT0kbWAdHEpm0WW4/rnzlLyVt46+BRng7EGY5CpODz3DERZD1qIrURKvUvytOZ2ijHZDsLA9wbQyjDzKclMQRUVH7FwE2PcdRW3n+KoyC2YNmjuBilDaSGPb1Wr4brHVRne8cNt4KT19F6En7tcbhMM3MfuIEImY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765580; c=relaxed/simple;
	bh=fvhAqaOZG8Eiid/B7EP0z65+1QLpv7hdSQtMyMUyyxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr2Vb7M8IgQyVGqYrp4MOB3kXfCAqYTcEOdXw1tI2aJMGa/CTNntFvT+OjhyLZX5WnwH8jx8Q4oW0m6/92MqQiYe9BjSH16EqU2sCYjgFgpOfDuNwtp7EdSUgRk9OEMoibLJpRRjnT7v0zG3AJH4/ZiTHL6u0nGUYT8z76DGQHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcJdAh09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcJdAh09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B98C4CED1;
	Wed,  5 Feb 2025 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765580;
	bh=fvhAqaOZG8Eiid/B7EP0z65+1QLpv7hdSQtMyMUyyxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcJdAh09gyZJAJ5dUuDyLmHoBeEbO6gqrGaB0gta5caXv9u4EQoQlIv+b3U7Xfzsp
	 +H0FKqK0zE2yM0y+AmB9r2kKySn7c1BpCoKj4fTDax4oMM9trRLaQ9dQfS8t7kKpMO
	 VAphbAs2Od5FZX8WrX5VAh/el5KuWWwVzA/VJnSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wronek <davidwronek@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/393] arm64: dts: qcom: Add SM7125 device tree
Date: Wed,  5 Feb 2025 14:43:00 +0100
Message-ID: <20250205134430.297498452@linuxfoundation.org>
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

From: David Wronek <davidwronek@gmail.com>

[ Upstream commit 72fbf05149bd451e7222c2ed1e3823972f19df9c ]

The Snapdragon 720G (sm7125) is software-wise very similar to the
Snapdragon 7c with minor differences in clock speeds and as added here,
it uses the Kryo 465 instead of Kryo 468.

Signed-off-by: David Wronek <davidwronek@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230824091737.75813-4-davidwronek@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 092febd32a99 ("arm64: dts: qcom: sc7180: fix psci power domain node names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7125.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 arch/arm64/boot/dts/qcom/sm7125.dtsi

diff --git a/arch/arm64/boot/dts/qcom/sm7125.dtsi b/arch/arm64/boot/dts/qcom/sm7125.dtsi
new file mode 100644
index 0000000000000..12dd72859a433
--- /dev/null
+++ b/arch/arm64/boot/dts/qcom/sm7125.dtsi
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#include "sc7180.dtsi"
+
+/* SM7125 uses Kryo 465 instead of Kryo 468 */
+&CPU0 { compatible = "qcom,kryo465"; };
+&CPU1 { compatible = "qcom,kryo465"; };
+&CPU2 { compatible = "qcom,kryo465"; };
+&CPU3 { compatible = "qcom,kryo465"; };
+&CPU4 { compatible = "qcom,kryo465"; };
+&CPU5 { compatible = "qcom,kryo465"; };
+&CPU6 { compatible = "qcom,kryo465"; };
+&CPU7 { compatible = "qcom,kryo465"; };
-- 
2.39.5




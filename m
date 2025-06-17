Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97452ED153;
	Tue, 17 Jun 2025 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177852; cv=none; b=jSb1O4sgLDtTWXm9EyqNMNgi0qqXev+U9R0kgLASZntWgCwIrSi1x2u6cEMBF6dsvxUU8qrR7i6+CTLKXDKXbfmejz+N1Q2IQW2KjpXTNHHXfkTcCi4AtbTDNO+hVV5blbCFK+LrcZTiBxsICpGdsHH6TKHetMEEjOVxBwXZY4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177852; c=relaxed/simple;
	bh=EnqYr/n9DCcCG3SwJ2RqFrMyhDVZbZeo1vABALC5dxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiqrgGFdCz+OfsLlGpWYdf7z/dxldR/KhtjupXU3pCD34B6j3YkuYZJLwE291uButSnSBU8Fz+e9bCGYiZ2TWTi8lL4vM1rK/P4i8AZ+pz9slmkyM33k6l8+86rVXGnbg+Bi1l2mCSpRzdjPAtuoTI8tzaL+0F/lkp8m0jBrWwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML42HthA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML42HthA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59361C4CEE3;
	Tue, 17 Jun 2025 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177851;
	bh=EnqYr/n9DCcCG3SwJ2RqFrMyhDVZbZeo1vABALC5dxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML42HthAXSuv8+FvbFxd+b/YLqeGjYNmVAjwWVx7XwCKEnFglZUrh2Xo9ULZ5FnKE
	 JFF7s9rOwW9/030xg8FUePyLmYcn3A+1XpQMg21TQP5H4Baqsxj04fOzXlmPd8+xtp
	 nM7Z1CU4uQ5+nMR0FRRuPEhtOSKRt3VnArkLPnl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 372/780] arm64: dts: imx8mm-beacon: Fix RTC capacitive load
Date: Tue, 17 Jun 2025 17:21:20 +0200
Message-ID: <20250617152506.604938063@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 2e98d456666d63f897ba153210bcef9d78ba0f3a ]

Although not noticeable when used every day, the RTC appears to drift when
left to sit over time.  This is due to the capacitive load not being
properly set. Fix RTC drift by correcting the capacitive load setting
from 7000 to 12500, which matches the actual hardware configuration.

Fixes: 593816fa2f35 ("arm64: dts: imx: Add Beacon i.MX8m-Mini development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
index 62ed64663f495..9ba0cb89fa24e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-som.dtsi
@@ -233,6 +233,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5




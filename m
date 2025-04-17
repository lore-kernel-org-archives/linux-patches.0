Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2F1252915;
	Thu, 17 Apr 2025 18:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914715; cv=none; b=FESCTU6GEZCe3Wyf01+oXhyxQVwVsHXvRswuNiXgr5xt9Ispy5AeUMjOZTTo6+CGTkdsJv3OGy4YWXlXbrW3GO12OIGGU4I6JVps/nIBN8XxGj9/Nny/rfn+l6qjelM9Xu7Qxa9uIWLWMs/3wAlmUTlyP/wxqT+FzKRu5k8KmS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914715; c=relaxed/simple;
	bh=aQQkbhzmIlP2TkSlBpxQZ8thyQ2Nx1qfvkp4fPMby1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSEH78JrECPxSj5IN2vegqTLyPZTQIhscLxECTSSP2AJAzApzKhLkJoQ7tqGekYWm6s89yD9XjkT/TaGcrxVlTmkfeJ0TQ5hnVSS7ra4VHXwc/IX69rfvOoUfI2nYLLlRjc1OhMm6NhpoRlT194ZTZ3hgtFUCVO4F6EibpyP9Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXXwQtdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXXwQtdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C5AC4CEE4;
	Thu, 17 Apr 2025 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914714;
	bh=aQQkbhzmIlP2TkSlBpxQZ8thyQ2Nx1qfvkp4fPMby1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXXwQtdhuVRGcZoeut1VFn/cWSnzJrvWGZ66B0VAG7NoHGVkkc7XqRLj/M31GN1Mw
	 LA+tVQQ3o2oEcDjCQ7Rb0ENItY7b2sn1po80Uee3a3RTK92uTRtmDBbLEJhuz31I1w
	 CLEgrqRb8ztbSBPMKXfYfGnerlXRZO56vHbuZSng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keerthy <j-keerthy@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.13 306/414] arm64: dts: ti: k3-j784s4-j742s2-main-common: Correct the GICD size
Date: Thu, 17 Apr 2025 19:51:04 +0200
Message-ID: <20250417175123.739025829@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Keerthy <j-keerthy@ti.com>

commit 398898f9cca1a19a83184430c675562680e57c7b upstream.

Currently we get the warning:

"GICv3: [Firmware Bug]: GICR region 0x0000000001900000 has
overlapping address"

As per TRM GICD is 64 KB. Fix it by correcting the size of GICD.

Cc: stable@vger.kernel.org
Fixes: 9cc161a4509c ("arm64: dts: ti: Refactor J784s4 SoC files to a common file")
Link: https://lore.kernel.org/r/20250218052248.4734-1-j-keerthy@ti.com
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
index 83bbf94b58d1..3b72fca158ad 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
@@ -193,7 +193,7 @@ gic500: interrupt-controller@1800000 {
 		ranges;
 		#interrupt-cells = <3>;
 		interrupt-controller;
-		reg = <0x00 0x01800000 0x00 0x200000>, /* GICD */
+		reg = <0x00 0x01800000 0x00 0x10000>, /* GICD */
 		      <0x00 0x01900000 0x00 0x100000>, /* GICR */
 		      <0x00 0x6f000000 0x00 0x2000>,   /* GICC */
 		      <0x00 0x6f010000 0x00 0x1000>,   /* GICH */
-- 
2.49.0




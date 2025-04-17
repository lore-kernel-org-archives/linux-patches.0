Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ADC1CAA7D;
	Thu, 17 Apr 2025 18:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913431; cv=none; b=QFBFoiIfiakBPDhcAvDbq1EoXZhiVvoGWiP29HtuJm/Tf/0E8wwYr6LfC5li8JWTkX71ma/m3j3TMzCs5qCkW7kiFEjH/brvAHK9cRvfASSgUEXtZC8B1QHUznut4Gs1Iyyxoqnkhvq3FPcDxT3WYsqUqhMerQgG5WO5SZyvyNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913431; c=relaxed/simple;
	bh=Kqw+JQbVLVp1mc11yUCt66jV+Vny0/cWappHioZ+xRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrtBViDHesoaqQRcpSv65Y8Jh8NRsI+P2AzwYaOzwkydgjfCYTEMKxlfNa3raIw7xa+gZL8kY64cUF67yCaRu8sdYXAk1QHYPWjdBjivp3bWFBelIfWuHKI5N3ehQHAqGiuq4lmlrKCpa9LJIbHQhpwfITkB2tDlg01baI0J5MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkbmXh43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkbmXh43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2065EC4CEE4;
	Thu, 17 Apr 2025 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913430;
	bh=Kqw+JQbVLVp1mc11yUCt66jV+Vny0/cWappHioZ+xRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkbmXh43BtWmFO8AN+sSF4zDQoB9rfsfV+1jChzByPg02APm+znd7xQl4wbERGeJx
	 ljQ4X8k3w6AuY/SrOi88Y5uiNzli3EZaQ79TyLvqCcZd311Mn44Ozr2Rd+vZ6U5u+/
	 1ZBhes04IOt3nj/mRBNwsQL7bDlrCAeaBFa6zS0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keerthy <j-keerthy@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.14 337/449] arm64: dts: ti: k3-j784s4-j742s2-main-common: Correct the GICD size
Date: Thu, 17 Apr 2025 19:50:25 +0200
Message-ID: <20250417175131.752447815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
@@ -193,7 +193,7 @@
 		ranges;
 		#interrupt-cells = <3>;
 		interrupt-controller;
-		reg = <0x00 0x01800000 0x00 0x200000>, /* GICD */
+		reg = <0x00 0x01800000 0x00 0x10000>, /* GICD */
 		      <0x00 0x01900000 0x00 0x100000>, /* GICR */
 		      <0x00 0x6f000000 0x00 0x2000>,   /* GICC */
 		      <0x00 0x6f010000 0x00 0x1000>,   /* GICH */



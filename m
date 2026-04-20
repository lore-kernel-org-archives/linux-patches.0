Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178BF33A9FF;
	Mon, 20 Apr 2026 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700122; cv=none; b=s+grCunpqfXLLXsqG1nVlPPsItjQ8VZczeST4w/lDPJbyIqGqFNzkq9+sQgFLky7b7xv1rprnKTt/l1CuDFJXd+rpUtJvQdpmkqaioqXRJkYFJ7YjQ0VWtvd3EIDVWZEx/3eZWm5vwLeHwIwIb3pV8JH6/yEsXjfoSKeivwAmkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700122; c=relaxed/simple;
	bh=oNIiBIelInoAPRJjOGb0cOLD9r9Q291vii9aU+fx/cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWwtqxJyj5iOsGwIDt5ldb/dacLgGbeQJnTJ9hWlaYahP4mk+MU8wTONoVSU0S/mpX1WRZUmwTzHIJ6lWB3SpSNd8daUwfe7zNq3Y3nRWj2TghEwVTn8DcmQo67SsEKUGzli8G4tc/WmFlRtVB5w9u9c+NhrljwzRlmP9GVTJeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qU9eh/QI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qU9eh/QI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB8DC19425;
	Mon, 20 Apr 2026 15:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700121;
	bh=oNIiBIelInoAPRJjOGb0cOLD9r9Q291vii9aU+fx/cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qU9eh/QIyiEF2D9hUKaAnzo8eurFwdUV6OF2wE5zYGRyWyCSJ0sNINkitlyJxBIOC
	 kloBDG1H5lUyvZoSjMYf80vf21OzaX5yv0P9E/rO4oIr+q2dGWa77hlOgi8qMbJSDD
	 oLUjCT9ADQnmhoaNh9aFMK0r8UwpgkLusXhRzfxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 051/220] arm64: dts: imx93-9x9-qsb: change usdhc tuning step for eMMC and SD
Date: Mon, 20 Apr 2026 17:39:52 +0200
Message-ID: <20260420153935.877875947@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke Wang <ziniu.wang_1@nxp.com>

[ Upstream commit 08903184553def7ba1ad6ba4fa8afe1ba2ee0a21 ]

During system resume, the following errors occurred:

  [  430.638625] mmc1: error -84 writing Cache Enable bit
  [  430.643618] mmc1: error -84 doing runtime resume

For eMMC and SD, there are two tuning pass windows and the gap between
those two windows may only have one cell. If tuning step > 1, the gap may
just be skipped and host assumes those two windows as a continuous
windows. This will cause a wrong delay cell near the gap to be selected.

Set the tuning step to 1 to avoid selecting the wrong delay cell.

For SDIO, the gap is sufficiently large, so the default tuning step does
not cause this issue.

Fixes: 0565d20cd8c2 ("arm64: dts: freescale: Support i.MX93 9x9 Quick Start Board")
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
index 0852067eab2cb..197c8f8b7f669 100644
--- a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
@@ -507,6 +507,7 @@ &usdhc1 {
 	pinctrl-2 = <&pinctrl_usdhc1_200mhz>;
 	bus-width = <8>;
 	non-removable;
+	fsl,tuning-step = <1>;
 	status = "okay";
 };
 
@@ -519,6 +520,7 @@ &usdhc2 {
 	vmmc-supply = <&reg_usdhc2_vmmc>;
 	bus-width = <4>;
 	no-mmc;
+	fsl,tuning-step = <1>;
 	status = "okay";
 };
 
-- 
2.53.0




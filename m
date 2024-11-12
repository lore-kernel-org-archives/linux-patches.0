Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8382C21745F;
	Tue, 12 Nov 2024 10:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407239; cv=none; b=pVVQ3ShmdVpn/vVMKrtBnZ8kliuYi3K+rxLLwrjXgk/OZtEuWZaGZ3zvJO10q/0t+pvFekoOUOnuIcwEHbUx3L5XsSXPQS3fbHdO9t7mJ3OkfrEzUMeoSVJzxGkP5bEX/NEEa7Yycl70ImtEBalq5f++aGA1uqorkRBCQrNmP3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407239; c=relaxed/simple;
	bh=eTCPauiIB2OijRdcJROO4Y85zFLiBDYYms2vAhilxcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQ+BOBazbxm6nEd61s2DHYM8Q2tQZWCegf/Ta1M0F72MjIzyOuYocqAOEUlSIzdaoSLEkLDwXmWy3U78lTbg37Xo5oEHzYbXjBGU/u//7b6JUFLP7Qv7Vqi14bHTAPJYUOtbQTAdGPkOw7uwoBTH3apZ3S6jDocQNyRqep7ierA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTk6tKgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTk6tKgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C619C4CECD;
	Tue, 12 Nov 2024 10:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407239;
	bh=eTCPauiIB2OijRdcJROO4Y85zFLiBDYYms2vAhilxcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTk6tKgkptQgXDI6EPrsl/3lnbRNBkJ+DhohdfsBtQE+GPLXlsZgfwJXb6JF0t6lb
	 ZqOp2ciFAmRlGmQjYWVKouAxya2Nh+db4xRfpfD4oseHf3XIASJrXusZLUDfkINxhP
	 3AkOmfxq+kXJkqybYzBnJo892zx86/rChqAkirJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/98] arm64: dts: imx8qm: Fix VPU core alias name
Date: Tue, 12 Nov 2024 11:20:23 +0100
Message-ID: <20241112101844.588050581@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit f6038de293f28503eccbfcfa84d39faf56d09150 ]

Alias names use dashes instead of underscores, fix this. Silences also
dtbs_check warning:
imx8qxp-tqma8xqp-mba8xx.dtb: aliases: 'vpu_core0', 'vpu_core1', 'vpu_core2'
 do not match any of the regexes: '^[a-z][a-z0-9\\-]*$', 'pinctrl-[0-9]+'
from schema $id: http://devicetree.org/schemas/aliases.yaml#

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: eed2d8e8d005 ("arm64: dts: imx8-ss-vpu: Fix imx8qm VPU IRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qxp.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
index f4ea18bb95abf..dce699dffb9bf 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
@@ -46,9 +46,9 @@
 		serial1 = &lpuart1;
 		serial2 = &lpuart2;
 		serial3 = &lpuart3;
-		vpu_core0 = &vpu_core0;
-		vpu_core1 = &vpu_core1;
-		vpu_core2 = &vpu_core2;
+		vpu-core0 = &vpu_core0;
+		vpu-core1 = &vpu_core1;
+		vpu-core2 = &vpu_core2;
 	};
 
 	cpus {
-- 
2.43.0




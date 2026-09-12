Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5D91EB5FD;
	Sat, 12 Sep 2026 07:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197886; cv=none; b=koZc3UCl5Mbnh16rcQw5FzYa67G1UJO4JGwCxRGYlVOXba6HI4OnE2Xlz51qq8a7AX6rd0bq57ugP+D6Xy6m+JPRZrH4GJdc+oLB+OEshtNkAWX7m5eKQ94Dg/cJXKgk/Lon/op7TLsSqI3SUyof/lU4gAoVX1/ZDIWjmlSc3Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197886; c=relaxed/simple;
	bh=atnCSU2WpvWvgnKYNOO121oLKtloQDIazLwGPVDERrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POZxuAVPahh3+GIsRdb7msPz8EnQrJJuACQckx6pLLz4prdKguk4HKYAd/Os+NZVbw5r0v6k/SZbk5b8wQLT0AzwmukHzdtFU4O4S+N2h+mqQyzCvrc+/vnuhEwDNq36GAS2OQGHhJuCiRvqOqE2n+so6CkA3iMuoWviywb/E1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g44Gqdyo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g44Gqdyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF9C1F000FF;
	Sat, 12 Sep 2026 07:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197885;
	bh=gWx+BrHGuKz/jtTxc63anl2NlXxCc3hjzpSPSLGf7UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g44GqdyoTvDmADDjwGFoEO/5H9Zwt0O4g6U86HswQf73WyvdUyvyeZA5IcTwGMhZK
	 fQgCyvRk+5xbUHbup+wPCJOGAYKUG5zhVsu46RATbebrBv9LBoDFeXiGCZP9ycBJq1
	 qDDnaWWIh1heBO+DF+1w6xEDipe+U58JaYdyBhTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0265/1815] clk: qcom: gcc-qcs8300: Use retention for USB power domains
Date: Sat, 12 Sep 2026 08:33:35 +0200
Message-ID: <20260912065655.194178715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit d8638610e0c9ebab2800b7ad6c2c2a3737090da9 ]

The USB subsystem does not expect to lose its state on suspend:

  xhci-hcd xhci-hcd.1.auto: xHC error in resume, USBSTS 0x401, Reinit
  usb usb1: root hub lost power or was reset

To maintain state during suspend, the relevant GDSCs need to stay in
retention mode, like they do on other similar SoCs. Change the mode to
PWRSTS_RET_ON to fix.

Fixes: 95eeb2ffce73 ("clk: qcom: Add support for Global Clock Controller on QCS8300")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260629-monza-suspend-v1-2-b601d8a2f2f8@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcs8300.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qcs8300.c b/drivers/clk/qcom/gcc-qcs8300.c
index 71c5a901715ff..31fd870b10f7a 100644
--- a/drivers/clk/qcom/gcc-qcs8300.c
+++ b/drivers/clk/qcom/gcc-qcs8300.c
@@ -3305,7 +3305,7 @@ static struct gdsc gcc_usb20_prim_gdsc = {
 	.pd = {
 		.name = "gcc_usb20_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
@@ -3317,7 +3317,7 @@ static struct gdsc gcc_usb30_prim_gdsc = {
 	.pd = {
 		.name = "gcc_usb30_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
-- 
2.53.0




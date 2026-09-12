Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D6920ED;
	Sat, 12 Sep 2026 09:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206720; cv=none; b=SdPXog0ku4SIqZNAV9j2D30XCWAqYcRbmCcE34I4DS53SCfOAOQgOvqJL8xbeVVIJhqmD7yDhx+pKfE23any/moYENW237HSrhtKOtIGJS5qW3Kf2sheYzaHYFaRisFB9bAnAScLKvuWIQipkOBqS56gQmYpMsTsEXTg2GHdaHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206720; c=relaxed/simple;
	bh=sGewrxU7Z9fDvCTxp3W2K33PVp/YUmJ7fecnZSFJM40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMOkMG4u2+mEM7DdOoCly5+3bGw9X3rQ5Sun55IO6udSfVk9QlnMU0ldDl4oLhA+iNa4vd5PXQEKimKiiMQzabvBDUIL2k6eU6Web68tr3WFXlSn4wxKSbQHnQvPrFckVhdb/fcwmAGKNPLnXVsqNTIgetcY3gMGegHjF4GQWRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPwZT/Lw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPwZT/Lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3621F000FF;
	Sat, 12 Sep 2026 09:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206719;
	bh=aDBvtWNBr48DPQF0+mBgOrOsoO5wLWLhcyF1TbFSCvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPwZT/LwJQkFSi7hVqzWsreh/wu0nHRU+YDdFL9lJKqXmKxbCSFC3OEVVyYeNuj8a
	 rZ+oAhbThwelG1S5N7g/jG4tQK14zDOx5sFuYScSiwnRPge/hrlHn2e8YPuhvEgf51
	 24kJp6Ge0JhGqTYxKV3Qbk6XaZ5aIr/SBpjqe0ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0264/1518] clk: qcom: gcc-qcs8300: Use retention for USB power domains
Date: Sat, 12 Sep 2026 08:40:33 +0200
Message-ID: <20260912065629.459814414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 009672b75fb90..fe0632687f9f0 100644
--- a/drivers/clk/qcom/gcc-qcs8300.c
+++ b/drivers/clk/qcom/gcc-qcs8300.c
@@ -3306,7 +3306,7 @@ static struct gdsc gcc_usb20_prim_gdsc = {
 	.pd = {
 		.name = "gcc_usb20_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
@@ -3318,7 +3318,7 @@ static struct gdsc gcc_usb30_prim_gdsc = {
 	.pd = {
 		.name = "gcc_usb30_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = RETAIN_FF_ENABLE | POLL_CFG_GDSCR,
 };
 
-- 
2.53.0




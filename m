Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683B23E025C;
	Mon, 17 Aug 2026 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973913; cv=none; b=L+zfZtGzQi8V+om3pPwY2QRrbRqUBtcBKDlN9B89OEN+QWy4MR2y5yDN/Oc6FvTVMzbvXxzOnUpuAxCLqegMmkw1X2n/IBvLLgmtazzxR0asKdx6/XlqX2ZqB4Rr44/L+ykie60nfNLxmzvBYVSYsQ74y1HGuHYr3JlGrTkFUgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973913; c=relaxed/simple;
	bh=dnfXfGEHFiGgNjsiFNE0Hi0FdEEx40FVk4HIqOA+QJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSyeDK4nZ80caL4ds5cI9C1JpkCFu77zAkZQJPtofCz9ZNeuBNG4EhPwLBR40SkVUKuA2RedYKG+1ha0BZ2NF6YxFOxSfUtbUK/3mdATrSsXr4SjACzIw59ZpttxUKyA6AjygFxqM/fj56SM1wNHI2aLWxMsGfD9LKgHAAUgDV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lC3Gsl+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lC3Gsl+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2971F000E9;
	Mon, 17 Aug 2026 13:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973912;
	bh=SF/5W0A49hmDi2sXp8MQrg2nA9TBmCxLinL6dihKLcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lC3Gsl+aKeLCE783jkO1vBMMFAx34VbPZa8rHjddESKkJJ8/N4Kmp9wNzNtpz2wT5
	 d22yCrUJGLtVn7TH3DYhYbhod+Ocu6Plj875bj5GpxtX1sj1MOTa0OGl1aE3NE+TxC
	 p/YL1zqF6tqeWfD8TepRfp+//IFslJq9jbh0hvP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	Linus Walleij <linusw@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 024/271] pinctrl: qcom: ipq806x: mark pci reset as a GPIO pin function
Date: Mon, 17 Aug 2026 15:29:09 +0200
Message-ID: <20260817132537.750368794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Ulli Kroll <linux@ulli-kroll.de>

[ Upstream commit fd46760956509f580f7d3d25db4de10e7c6f949b ]

The qcom pinctrl core supports marking functions that represent GPIO mode
via PINCTRL_GPIO_PINFUNCTION(), so that strict pinmuxing does not reject
GPIO requests for pins that are muxed to the GPIO function.

Mark PCIe reset as GPIO pin function

This allows ipq806x to keep the PCIe-reset related configuration in DTS
without tripping over strict pinmux ownership checks.

Fixes: cc85cb96e2e4 ("pinctrl: qcom: make the pinmuxing strict")
Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
Acked-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260719134548.8830-3-linux@ulli-kroll.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-ipq8064.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ipq8064.c b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
index c1651f112950e..f35dbe07ab6fe 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
@@ -507,19 +507,19 @@ static const struct pinfunction ipq8064_functions[] = {
 	IPQ_PIN_FUNCTION(usb2_hsic),
 	IPQ_PIN_FUNCTION(rgmii2),
 	IPQ_PIN_FUNCTION(sata),
-	IPQ_PIN_FUNCTION(pcie1_rst),
+	IPQ_GPIO_PIN_FUNCTION(pcie1_rst),
 	IPQ_PIN_FUNCTION(pcie1_prsnt),
 	IPQ_PIN_FUNCTION(pcie1_pwren_n),
 	IPQ_PIN_FUNCTION(pcie1_pwren),
 	IPQ_PIN_FUNCTION(pcie1_pwrflt),
 	IPQ_PIN_FUNCTION(pcie1_clk_req),
-	IPQ_PIN_FUNCTION(pcie2_rst),
+	IPQ_GPIO_PIN_FUNCTION(pcie2_rst),
 	IPQ_PIN_FUNCTION(pcie2_prsnt),
 	IPQ_PIN_FUNCTION(pcie2_pwren_n),
 	IPQ_PIN_FUNCTION(pcie2_pwren),
 	IPQ_PIN_FUNCTION(pcie2_pwrflt),
 	IPQ_PIN_FUNCTION(pcie2_clk_req),
-	IPQ_PIN_FUNCTION(pcie3_rst),
+	IPQ_GPIO_PIN_FUNCTION(pcie3_rst),
 	IPQ_PIN_FUNCTION(pcie3_prsnt),
 	IPQ_PIN_FUNCTION(pcie3_pwren_n),
 	IPQ_PIN_FUNCTION(pcie3_pwren),
-- 
2.53.0




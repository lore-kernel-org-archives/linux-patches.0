Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884633E025C;
	Mon, 17 Aug 2026 13:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973910; cv=none; b=eoZyn6Nze9gN7+nlK9C0yKBYjlp2EaHUhvgtx2lKPbCSvPF5vMgbGLqoWhMH3VdRcceQnOwY7l3G/YIxyxXgOYZ3kG+pu+VgSjvWrKnaLv/P2ac9IgLjpU4K81CZr9kmoVCtDn+eaFPPLI8YU94gwtrWDirrMugP7RgcGV8B9i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973910; c=relaxed/simple;
	bh=0Ccun8ZqhzM3YIpGmobPfbm2O/jRP+eSCHMcaJBvens=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Za1qGcJrw/5dfvmgYoNZmz/4FazRZoTGYtr1a+tC5EW8/Pq5U98/mW93O6vOIgYpGogmakxHb4t9L5yHkhF+VdElKqYA7rdSurjsV1t6oBsySP1uthfpAFNuAEZvCXw4rnva+2QD336JtRGwUNwYIk6NInxPTbZno93osLgs4/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdHsd9Gc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdHsd9Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CFC1F000E9;
	Mon, 17 Aug 2026 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973909;
	bh=smpZQCvEk15SHIUddOpBQz7MRtgxM24WUoP4F0WzvZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdHsd9GcCwF4zeUXOOKMRZpW1W7JSzBxHOUZum8xFwyQkHhNjZrl5HceyiTGVe38K
	 7nZu+ldRL/E2Vdp9Exmup8Z/WEkBsTlhrx/IUOaIQAgaddoy5nKxdcrnSTer8DZxjY
	 20pd6BCdmfQUfiY51MCX0GQrebzHdPP7haV08hzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Ulli Kroll <linux@ulli-kroll.de>,
	Linus Walleij <linusw@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 023/271] pinctrl: qcom: ipq806x: mark gpio as a GPIO pin function
Date: Mon, 17 Aug 2026 15:29:08 +0200
Message-ID: <20260817132537.713066832@linuxfoundation.org>
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

[ Upstream commit 687f39faccba29ab26de965411db37e849af8ec2 ]

The qcom pinctrl core supports marking functions that represent GPIO mode
via PINCTRL_GPIO_PINFUNCTION(), so that strict pinmuxing does not reject
GPIO requests for pins that are muxed to the GPIO function.

Add a IPQ_GPIO_PIN_FUNCTION() helper and use it for the ipq806x gpio
function, matching how the msm-based qcom drivers handle this.

This allows ipq806x to keep the GPIO-related configuration in DTS
without tripping over strict pinmux ownership
checks.

Fixes: cc85cb96e2e4 ("pinctrl: qcom: make the pinmuxing strict")
Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
Acked-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260719134548.8830-2-linux@ulli-kroll.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-ipq8064.c | 2 +-
 drivers/pinctrl/qcom/pinctrl-msm.h     | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ipq8064.c b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
index 0a9e357e64c60..c1651f112950e 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq8064.c
@@ -480,7 +480,7 @@ static const char * const ps_hold_groups[] = {
 };
 
 static const struct pinfunction ipq8064_functions[] = {
-	IPQ_PIN_FUNCTION(gpio),
+	IPQ_GPIO_PIN_FUNCTION(gpio),
 	IPQ_PIN_FUNCTION(mdio),
 	IPQ_PIN_FUNCTION(ssbi),
 	IPQ_PIN_FUNCTION(spmi),
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
index 4fbff61de6bb3..b94ba1a4177ed 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.h
+++ b/drivers/pinctrl/qcom/pinctrl-msm.h
@@ -24,6 +24,11 @@ struct pinctrl_pin_desc;
 					fname##_groups,		\
 					ARRAY_SIZE(fname##_groups))
 
+#define IPQ_GPIO_PIN_FUNCTION(fname)					\
+	[IPQ_MUX_##fname] = PINCTRL_GPIO_PINFUNCTION(#fname,		\
+					fname##_groups,		\
+					ARRAY_SIZE(fname##_groups))
+
 #define MSM_PIN_FUNCTION(fname) 				\
 	[msm_mux_##fname] = PINCTRL_PINFUNCTION(#fname,		\
 					fname##_groups,		\
-- 
2.53.0




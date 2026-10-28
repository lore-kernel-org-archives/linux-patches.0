Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216808;
	b=pnCvkmyQwzFdjXDqOqH3ipZNVZaYuwZBNH/tGFTMOyowADIqtGZ3M08A92CGXhjYTCek
	 MrRg/14lo+jBF3Xl2N1jTdaBkbGU0sedf7wt3RIQddR1FFZdNIwqerXsP0I7+eMyjkhF0
	 oKLi4HzAf4bDnOZCGFpQTKZDX00tk1QcpmM7q8j7eziQl8PRTpUGqNwhr5Pxbxpz4IswS
	 mmDWHVogUPUi9r83Th3iQBRgpBNcMSgn0kljK5uhy8jlgxGdcdcM5p0d98aKaPiCg3W2x
	 //ilvg0Ecx0WGtHv6dJtzrd4x4EIifyflcugOCJwx760jBOqxDUovLuRuv/iQ4Ug/eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TqjNmh/cfnYB2ZmCJgbmH3sDhigylAuBUPPlEvShUMY=;
	b=S8NMYXooDAYvTCz4Gs/qtphF/pttDNC1soY5FmcLm9A1SqaqHGz7qums8IryEMCSU2Le
	 VdK0m2EvLNrn90aq7yzEsOwc0Ngwms42VMLl280V4hxFho8ZExGv+QIwuPeILpUHm3+r/
	 BOaaq4ICWQ8xJ3ff/294okfixyZK0NpYlZiVT25MZszWA6INij5IyGE3QIYIMGwmLfZsr
	 fVQ+Xisj5vAmyJq4cI9vaC4dbmuYUXDoRRJKlLNHoFWoEPz6J8raxEIrg9dKfoi+hC9j5
	 AWRINGRTyHCDGiv2HuwxGlPU8d+iFBHjI+X1MtL8RpefCaDykTszBP/dt87E/UCjuGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixihkW5K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E73606A31A;
	Wed, 28 Oct 2026 19:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixihkW5K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86C21F01825;
	Wed, 28 Oct 2026 19:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216808;
	bh=TqjNmh/cfnYB2ZmCJgbmH3sDhigylAuBUPPlEvShUMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixihkW5Kc/NPjk4cD+RGVPv9/YhuBpiYjGjynghEdQcqMnjzYxyRsaoTSy1uhiLwk
	 8vohMVTDE/rHPRN/CeDbl+3LFlDC/BERzNmEHLV6M0c83DARsMyDrfP74bqOCbtdPe
	 bJE4GXbJus2YzCA7HXqsNVFiFoGDdX+NgDEVfrRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1684/1887] spi: spi-qcom-qspi: Support pinctrl sleep states
Date: Wed, 28 Oct 2026 18:03:00 +0100
Message-ID: <20261028170537.779748804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 0098c52745112c4387942a37559ababeaf072f0c ]

It's fairly common practice for drivers to switch to a "sleep" pinctrl
state at the end of its runtime_suspend function and then back to
"default" at the beginning of runtime_resume. Let's do that for
spi-qcom-qspi.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20230323102605.5.I79544b9486033bd7b27f2be55adda6d36f62a366@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d283d5d4d9f6 ("spi: spi-qcom-qspi: Fix incomplete error handling in runtime PM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qcom-qspi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-qcom-qspi.c b/drivers/spi/spi-qcom-qspi.c
index a6d5f287eddca..3fb9cc85d554f 100644
--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/pm_opp.h>
 #include <linux/spi/spi.h>
@@ -581,6 +582,8 @@ static int __maybe_unused qcom_qspi_runtime_suspend(struct device *dev)
 		return ret;
 	}
 
+	pinctrl_pm_select_sleep_state(dev);
+
 	return 0;
 }
 
@@ -590,6 +593,8 @@ static int __maybe_unused qcom_qspi_runtime_resume(struct device *dev)
 	struct qcom_qspi *ctrl = spi_master_get_devdata(master);
 	int ret;
 
+	pinctrl_pm_select_default_state(dev);
+
 	ret = icc_enable(ctrl->icc_path_cpu_to_qspi);
 	if (ret) {
 		dev_err_ratelimited(ctrl->dev, "%s: ICC enable failed for cpu: %d\n",
-- 
2.53.0




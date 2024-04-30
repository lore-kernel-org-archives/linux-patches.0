Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495C612C7FB;
	Tue, 30 Apr 2024 10:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474567; cv=none; b=VCaqDI8HHgisfXBrto1C4qaaFnmVe3VAhEtySTWESxXI5KRRuj0sgacfMTL/O0wvDUg9OqsVUgx4YHBx3JazLZjfUVYY8EZo8xZZVpIaQWE/ZIXaN70+GMZb1n6almHUIoSEH38+CscKlsO/TdkKSjbiFiIvZQ40piCSO8cafBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474567; c=relaxed/simple;
	bh=3Oz8ifsHIeUIOEn/eTKTVf2FvH8CYW9wCxyTZY/L6nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyQJyhZGkyGq7UtOSMlgkTbz0ytObe1GbfgnG4bOwK6aA8ZjevMBrrzAVSmPVLhNtoTCwQdcbWFKAkGsR9kZQVhSn7fUWARcl25woO8OpSbE0BgBZ9RZp8FiqGe5UHXbVhlYGWPzi2iDVOOw9u1yYcYnyskL8v+H7u/KwDT7Zl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wCNl0nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wCNl0nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986A2C2BBFC;
	Tue, 30 Apr 2024 10:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474567;
	bh=3Oz8ifsHIeUIOEn/eTKTVf2FvH8CYW9wCxyTZY/L6nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wCNl0nn37xjq5SK+POJ73zoLc7yYP1rHWZ/2xG+BKPrCnaCao1FuFmtJc8g2pp6V
	 Z5Uj7htgr2FFav+ojgeFNyhpBCMZh39QUs7dYDXfQPBg8S7/WwhrGMv6CgkH0P3bvY
	 cWfzFt/+xfsMlaDyx8iP1yfk2Y0Hlw9n2+gET030=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Steev Klimaszewski <steev@kali.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.8 196/228] phy: qcom: qmp-combo: Fix register base for QSERDES_DP_PHY_MODE
Date: Tue, 30 Apr 2024 12:39:34 +0200
Message-ID: <20240430103109.455550148@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

commit ee13e1f3c72b9464a4d73017c060ab503eed653a upstream.

The register base that was used to write to the QSERDES_DP_PHY_MODE
register was 'dp_dp_phy' before commit 815891eee668 ("phy:
qcom-qmp-combo: Introduce orientation variable"). There isn't any
explanation in the commit why this is changed, so I suspect it was an
oversight or happened while being extracted from some other series.
Oddly the value being 0x4c or 0x5c doesn't seem to matter for me, so I
suspect this is dead code, but that can be fixed in another patch. It's
not good to write to the wrong register space, and maybe some other
version of this phy relies on this.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Abel Vesa <abel.vesa@linaro.org>
Cc: Steev Klimaszewski <steev@kali.org>
Cc: Johan Hovold <johan+linaro@kernel.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: stable@vger.kernel.org      # 6.5
Fixes: 815891eee668 ("phy: qcom-qmp-combo: Introduce orientation variable")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240405000111.1450598-1-swboyd@chromium.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2211,9 +2211,9 @@ static bool qmp_combo_configure_dp_mode(
 	writel(val, qmp->dp_dp_phy + QSERDES_DP_PHY_PD_CTL);
 
 	if (reverse)
-		writel(0x4c, qmp->pcs + QSERDES_DP_PHY_MODE);
+		writel(0x4c, qmp->dp_dp_phy + QSERDES_DP_PHY_MODE);
 	else
-		writel(0x5c, qmp->pcs + QSERDES_DP_PHY_MODE);
+		writel(0x5c, qmp->dp_dp_phy + QSERDES_DP_PHY_MODE);
 
 	return reverse;
 }



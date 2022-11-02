Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1557E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EEFC433D6;
	Wed,  2 Nov 2022 03:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358244;
	bh=AT3tSx49P2euq1EeMMUdLI/5ok+6uoQDFq3fBoThes0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2Ewi2zE2tgO+F20B7ZFhUiPmmwuSv4vZGYR0jmZhLGLAu47bYC5oX3pTz0Bkl8WI
	 WM2tspRiGLIEi/0lSuSNG91OSlHzAOCztfv4ya+Hg1QWYe1cHTwUEsWumWBJACIGqu
	 5ywTiiwd3H71TlTV8hZNyfGQDg5ii5Tcz9afvUpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/132] ASoC: qcom: lpass-cpu: Mark HDMI TX parity register as volatile
Date: Wed,  2 Nov 2022 03:32:51 +0100
Message-Id: <20221102022101.311677966@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit 1dd5166102e7ca91e8c5d833110333835e147ddb ]

Update LPASS_HDMI_TX_PARITY_ADDR register as volatile, to fix
dp audio failures observed with some of external monitors.

Fixes: 7cb37b7bd0d3 ("ASoC: qcom: Add support for lpass hdmi driver")

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1665825530-7593-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index b37f4736ee10..5e8d045c1a06 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -781,6 +781,8 @@ static bool lpass_hdmi_regmap_volatile(struct device *dev, unsigned int reg)
 		return true;
 	if (reg == LPASS_HDMI_TX_VBIT_CTL_ADDR(v))
 		return true;
+	if (reg == LPASS_HDMI_TX_PARITY_ADDR(v))
+		return true;
 
 	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACURR_REG(v, i))
-- 
2.35.1




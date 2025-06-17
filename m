Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8882F9496;
	Tue, 17 Jun 2025 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177251; cv=none; b=hY6Ghh5So0YWEdwpU9yM53mrBLxlX5SsnupwsQQfeGsmeV5X8A/cCLTlrMcybXfXt77XGxLWI1FkN0wJlNv3738pZR2OeVxHM/I3MyIUc4yIf+HuomJ3aqqAWAqGoQ+qsO1Jlh36TXqlaykWwJr0IUE9F+NfcNmtUFRLUP/Q6ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177251; c=relaxed/simple;
	bh=qqbOCDQ8JFpWD5BYMvKdBo2s7yvZJUhV5vioxfRA22A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmyHNoVIfURrHZ4apAK6YvrlMasEzpX/H/dE/JY6ly5bcoTDO/yivsVse68W6HreB+ihTx26evscC10h90Lby4iGuzNdqPKoiiU4gULo18cnkDluveXRD15sIbvHPi4OwgtYwLTmj56fp03tI4DNvjgokCpax3PQjJQixKJdVAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cycXHLou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cycXHLou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A26C4CEE3;
	Tue, 17 Jun 2025 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177251;
	bh=qqbOCDQ8JFpWD5BYMvKdBo2s7yvZJUhV5vioxfRA22A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cycXHLou7MvN6zH+ntGEapWlSNyai/Mfec1Yu+uvQhJ1B6tCe5uhD9uI/BlOT8kjH
	 CW4Yf2vJPoLFxlbqjxT+mKE334zsHYVZLNMKoneIy3bkooN4FiWRi95H5OeoBXenZz
	 3qlIZblKCHCQEqDOSUnr2hPpIE7NPrjXi052Iqpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lijuan Gao <quic_lijuang@quicinc.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 260/780] pinctrl: qcom: correct the ngpios entry for QCS615
Date: Tue, 17 Jun 2025 17:19:28 +0200
Message-ID: <20250617152502.044911081@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijuan Gao <quic_lijuang@quicinc.com>

[ Upstream commit d18cdb975ba8aad7046ff82df1a963fa21082a45 ]

Correct the ngpios entry to account for the UFS_RESET pin being exported
as a GPIO in addition to the real GPIOs, allowing the UFS driver to toggle
it.

Fixes: b698f36a9d40 ("pinctrl: qcom: add the tlmm driver for QCS615 platform")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Lijuan Gao <quic_lijuang@quicinc.com>
Link: https://lore.kernel.org/20250506-correct_gpio_ranges-v3-3-49a7d292befa@quicinc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcs615.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcs615.c b/drivers/pinctrl/qcom/pinctrl-qcs615.c
index 23015b055f6a9..17ca743c2210f 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs615.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs615.c
@@ -1062,7 +1062,7 @@ static const struct msm_pinctrl_soc_data qcs615_tlmm = {
 	.nfunctions = ARRAY_SIZE(qcs615_functions),
 	.groups = qcs615_groups,
 	.ngroups = ARRAY_SIZE(qcs615_groups),
-	.ngpios = 123,
+	.ngpios = 124,
 	.tiles = qcs615_tiles,
 	.ntiles = ARRAY_SIZE(qcs615_tiles),
 	.wakeirq_map = qcs615_pdc_map,
-- 
2.39.5




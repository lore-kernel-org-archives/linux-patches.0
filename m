Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823D1C8E6;
	Mon, 22 Sep 2025 19:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569561; cv=none; b=RBiUdlxCn9itfTmcGxwNYmGZwDoNrLSpKOV3hw8JsIonsfHQlVrfzgcoZz52cXPCvD85R9V0f+GYz1PGn8jGFEQwsONHebot2IEG559aiNe+jjQwAN8mH31I9hQyIv1NTJnFt/fEVGpYaNWQESPfFghkWLWNpTJjnP9wk0/ugt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569561; c=relaxed/simple;
	bh=b4KXmcolKZyvgLteaK6Ec2n6mBKIKPffQKmtl8Nqw5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJ2XxjAtdtNRzA0oXjVXcH1JtVbIeio2U0tfdOqYIaPsruKpwgclyCDXw0BETeLdAbgEtKUdkh0IgjZIu1GmfCVregO/QdnRxkD2lfzuRtLvZHVGyHPi0Sz+PqsLzZenurQlWc6SJq/0v5DTbUEfEvzU8NsDI2Vvfc2JB1CZ4sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cS8KEUQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cS8KEUQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4AFC4CEF0;
	Mon, 22 Sep 2025 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569561;
	bh=b4KXmcolKZyvgLteaK6Ec2n6mBKIKPffQKmtl8Nqw5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cS8KEUQH4oANiHoNkPIB1HK3GovYy9zo4U8nbDUq5cS6TMMk9wZkCl5/pfgNi0+Zb
	 i6f4MDDUMlx5WRtalsOfZbFWeJOofI/W4ySBAq0Y5cVJn1t5zu1e7B+3z6RONG4X67
	 KB/kjWiwQCOEK1Z0Wm67+J09DhQsF9gWJ4ueLWfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 29/61] ASoC: qcom: audioreach: Fix lpaif_type configuration for the I2S interface
Date: Mon, 22 Sep 2025 21:29:22 +0200
Message-ID: <20250922192404.353932102@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>

commit 5f1af203ef964e7f7bf9d32716dfa5f332cc6f09 upstream.

Fix missing lpaif_type configuration for the I2S interface.
The proper lpaif interface type required to allow DSP to vote
appropriate clock setting for I2S interface.

Fixes: 25ab80db6b133 ("ASoC: qdsp6: audioreach: add module configuration command helpers")
Cc: stable@vger.kernel.org
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Signed-off-by: Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>
Message-ID: <20250908053631.70978-2-mohammad.rafi.shaik@oss.qualcomm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/audioreach.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/qcom/qdsp6/audioreach.c
+++ b/sound/soc/qcom/qdsp6/audioreach.c
@@ -728,6 +728,7 @@ static int audioreach_i2s_set_media_form
 	param_data->param_id = PARAM_ID_I2S_INTF_CFG;
 	param_data->param_size = ic_sz - APM_MODULE_PARAM_DATA_SIZE;
 
+	intf_cfg->cfg.lpaif_type = module->hw_interface_type;
 	intf_cfg->cfg.intf_idx = module->hw_interface_idx;
 	intf_cfg->cfg.sd_line_idx = module->sd_line_idx;
 



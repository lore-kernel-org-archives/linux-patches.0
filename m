Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EBB262D14;
	Mon, 22 Sep 2025 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569735; cv=none; b=n+lGyrfgVEkGrH3AiwuUm3Jt+1EZ9+kU6EfCfTON//y49kuTs/5CWs2ofOvvfDEc1+4e4htlDE3bx2T/vHfPMGnNS9GPHuaQ7tPAI1fdqH3GSvZNV1jp0Lky5K2dRZVAek2oLP0uAl8TdJXWS4RRbRkNtQFbVQwWCVZENvaayxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569735; c=relaxed/simple;
	bh=4GLnHZZO4/v+3WRo+Delkis9QhK2cQb2GT7X5l+Ej/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmxCp6g0e4qzEH1Iv1Zq4XXJIB3uFQMdcHqG/wqWhQPlBFo6xjVrW5RhO3B9qeYH9i0447ZgdZZmBXx4etI4xRC8H0M9CI5Z3qavAVvlsRabHzOS0H2671AJJ5Gf3HauH6+1ylFk/ANSYnw5AfH20jvezhmrQkCbxYCaD3jZeK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LL/StzP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LL/StzP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58AAC4CEF0;
	Mon, 22 Sep 2025 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569735;
	bh=4GLnHZZO4/v+3WRo+Delkis9QhK2cQb2GT7X5l+Ej/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LL/StzP0CMxFHZe7ovMLjN+CawrTVncad7XuGS6ukNFVzPpt2ZhKE8R9LpJ/Fw/xJ
	 f48bSI6Dt1jTl7LZe2Zu4DpKrDfvdkTZ555fj3b3aGkdLtUfMkxZKDZM4gunCh/xmi
	 C4GaWnOl0YQaGrMNtFTXkzpPiCbs3z3zzRjfnZ+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 37/70] ASoC: qcom: audioreach: Fix lpaif_type configuration for the I2S interface
Date: Mon, 22 Sep 2025 21:29:37 +0200
Message-ID: <20250922192405.611313448@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -967,6 +967,7 @@ static int audioreach_i2s_set_media_form
 	param_data->param_id = PARAM_ID_I2S_INTF_CFG;
 	param_data->param_size = ic_sz - APM_MODULE_PARAM_DATA_SIZE;
 
+	intf_cfg->cfg.lpaif_type = module->hw_interface_type;
 	intf_cfg->cfg.intf_idx = module->hw_interface_idx;
 	intf_cfg->cfg.sd_line_idx = module->sd_line_idx;
 



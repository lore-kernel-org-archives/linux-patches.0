Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56E2306494;
	Mon, 22 Sep 2025 19:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569953; cv=none; b=FeRTp3ysGSeHNIzZKm1kkkraPLXCDy/49rQCOX4nuTbCLKsY8sOOqacckZYaFdky6gYP9aS62tfDUyxwqnfaF8IRbVZVitoLyLiDflPVvUbvx13aDfVom5qNuc0jtO0T/uSaUEBvKorVohjTZRxwW1464d712USsP2SGdnB/vHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569953; c=relaxed/simple;
	bh=ax7APLxVM/qYcj03auzZph1PdP7oSB4XPf0bWuj9Fmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr7bIwnJmS3jhuTbhOFpk24ZbU9wlLxI2BOKItsfYCRcpSGTHYeCqkfXmNAJUfvLzsk0eRJ8PG5pYWa0H1NFhAZNZbslo+4RUZi1oTAtKB9yLVJcm78UQVNTLtX4bWcOAJegxgo4SahLMdXjXc374bHM81lJEiVPjLgJhB0CJYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mgz8KEtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mgz8KEtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA24C4CEF5;
	Mon, 22 Sep 2025 19:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569953;
	bh=ax7APLxVM/qYcj03auzZph1PdP7oSB4XPf0bWuj9Fmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mgz8KEtDFWhr+rIhGf2UuoWeHN6aH32jv1cJDMTzUBkYTUVFGZ2NwDBM/erCKmWH8
	 D4adOgxbBNfh2u66eNFgBlZ0bVUbxiKEiMupsVryHnMi5KNN1mEu7dFWpbMTVTiBQC
	 I7Y4Dv7b/Y41Gv0pcpRwZ5OocgmwXI/e7NdRlRUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 054/105] ASoC: qcom: audioreach: Fix lpaif_type configuration for the I2S interface
Date: Mon, 22 Sep 2025 21:29:37 +0200
Message-ID: <20250922192410.332808346@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -971,6 +971,7 @@ static int audioreach_i2s_set_media_form
 	param_data->param_id = PARAM_ID_I2S_INTF_CFG;
 	param_data->param_size = ic_sz - APM_MODULE_PARAM_DATA_SIZE;
 
+	intf_cfg->cfg.lpaif_type = module->hw_interface_type;
 	intf_cfg->cfg.intf_idx = module->hw_interface_idx;
 	intf_cfg->cfg.sd_line_idx = module->sd_line_idx;
 



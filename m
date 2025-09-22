Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0A0C8E6;
	Mon, 22 Sep 2025 19:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569564; cv=none; b=lYHyZ6V/u9YNh3xXHyHcfTzNvPSDMR6mEtKxdBcJNHBnnxksSXKk6OBhQhB9+2ZtstLSVwv2NkbqRRWhigWi9aEeLMf2F3pOFUlZcyG1Bscfkl2/mgB/STY4i1a1nU7UVnVQhDWeFypzzBTrt2eLOHNlko/+iPSY9WUfvmImmKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569564; c=relaxed/simple;
	bh=u+EYXCHdbAu5uEdOL4pjngCmeIiWrThj9TwklyORGfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBUO3dZ/zNexfPQjTquecviDSb5P6o8jZMFg4cOdc3UTxDDE/W4Br/MPPapLFy70b0iPu0vUeYv5FeFDB7ZhwaxJMv/71CGn27PMveS62vLDVQsI2oskr3VEay+XSJcwJQt3VnwVgbUISCzfD7z4q2CEM7JyCIsy/1AAQBIlvgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkqjQ//n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkqjQ//n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913EAC4CEF0;
	Mon, 22 Sep 2025 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569564;
	bh=u+EYXCHdbAu5uEdOL4pjngCmeIiWrThj9TwklyORGfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkqjQ//nRAnIpIO6zeLgRiNya1NgBa3dYMGbor9ysH2vTHxCqg6hASRBHu0gpZSZi
	 mBesxJ2puNa5zu8vBfYCt7ksRkUv7EBD1FuH6EgT6Dl/iakLV33dYJRjEMWUFUE1LA
	 V4lITBm1XIr7phsLCLXEoPsK/8oBf8AoYycM+Mc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 30/61] ASoC: qcom: q6apm-lpass-dais: Fix missing set_fmt DAI op for I2S
Date: Mon, 22 Sep 2025 21:29:23 +0200
Message-ID: <20250922192404.381408211@linuxfoundation.org>
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

commit 33b55b94bca904ca25a9585e3cd43d15f0467969 upstream.

The q6i2s_set_fmt() function was defined but never linked into the
I2S DAI operations, resulting DAI format settings is being ignored
during stream setup. This change fixes the issue by properly linking
the .set_fmt handler within the DAI ops.

Fixes: 30ad723b93ade ("ASoC: qdsp6: audioreach: add q6apm lpass dai support")
Cc: stable@vger.kernel.org
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Signed-off-by: Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>
Message-ID: <20250908053631.70978-3-mohammad.rafi.shaik@oss.qualcomm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
+++ b/sound/soc/qcom/qdsp6/q6apm-lpass-dais.c
@@ -204,6 +204,7 @@ static const struct snd_soc_dai_ops q6dm
 	.shutdown	= q6apm_lpass_dai_shutdown,
 	.set_channel_map  = q6dma_set_channel_map,
 	.hw_params        = q6dma_hw_params,
+	.set_fmt	= q6i2s_set_fmt,
 };
 
 static const struct snd_soc_dai_ops q6i2s_ops = {



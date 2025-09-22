Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98E5222590;
	Mon, 22 Sep 2025 19:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569713; cv=none; b=iU0M2quND0FuRgTgE0B/81TRBooFw73IScamC4oAGaIZkK+dsuWavyQJHjB6SrFJGqHVUezTBQlRqmkEFOKRj7TuKPaFbleU/HwgehliG5cCQ6EqNP9SWtKVgAJIJzrJm6J5JmdA0o7TKUYOIUlVTPpubIq99JFyVgopr6BirLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569713; c=relaxed/simple;
	bh=N6UAcAUbYXCJhHLeOkgV1C9FS2gRGU3yFSNHjh5xp4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3kNeGqSisDTkkW5LObU1DMVxTpmM+1cfcUKr5DxElgzkviiMAFK4Gug6BHt8Ij3e+3BiJ/cf74JSxZENiYVpt67BJvUgu8y3N0JCsLMwcR3zysiq5nTcl3PjX8FfleKQJNamx7YGn+jl8mZ/xx9b/6s3CtCvY9zEfJt9fHWRTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QItSH92S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QItSH92S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831F5C4CEF0;
	Mon, 22 Sep 2025 19:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569712;
	bh=N6UAcAUbYXCJhHLeOkgV1C9FS2gRGU3yFSNHjh5xp4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QItSH92SbELLptL7317dcb0i/2Ja7OurdDjzEhhMTSrm+isBJh2/3yfZjI5KSaPQz
	 RYrwdyu8Fmu3p/dkGKpT/XtihyQYsYeZ4xI2zLH5R3qB1NooDXbxhvjiU9gnhONGDD
	 xTOeqz7yKSbkAWK4V61ivDRDPT93/Oy5hyFLj/Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 39/70] ASoC: qcom: q6apm-lpass-dais: Fix missing set_fmt DAI op for I2S
Date: Mon, 22 Sep 2025 21:29:39 +0200
Message-ID: <20250922192405.665856035@linuxfoundation.org>
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
@@ -256,6 +256,7 @@ static const struct snd_soc_dai_ops q6i2
 	.shutdown	= q6apm_lpass_dai_shutdown,
 	.set_channel_map  = q6dma_set_channel_map,
 	.hw_params        = q6dma_hw_params,
+	.set_fmt	= q6i2s_set_fmt,
 };
 
 static const struct snd_soc_dai_ops q6hdmi_ops = {



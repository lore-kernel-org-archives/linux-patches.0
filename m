Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07322820D1;
	Mon, 22 Sep 2025 19:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569958; cv=none; b=pA1Zg+XbIIikEZsY23CyqbAmuSKekhS51VBRfIqncGA84+Tj5sjQ7ez9A5222pC3MzH9IuH10cp/8dKxlXpmjkynhFiCZ5IqkIJb7z8NOSvy8dOuG4hfXybN8fgaEKtWNmjTtYnccpzRpTBWy3I4BLJ7jfr5QIiREV16q+bW3D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569958; c=relaxed/simple;
	bh=Q2izJwUjTd211C2NoG34H43xm7AAH4OmXAK/zUV9rxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5P4aLz/upHnZ6wqhXdjxqoj2aR2k5PkMJfkydzzLWQ6+U3d3C8+Ks5lZWcZeZnkfPViuOMaxhyo7xGs5/BBI+tnVZE5XB1jjbtVEhXjXyOGN05T9SKXIW4k9te8g+EFvWONkNPML61fGC8Tg70pF4+h6nuMFy7c+J1iMJd5DQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaQdlJn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaQdlJn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2CCC4CEF0;
	Mon, 22 Sep 2025 19:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569958;
	bh=Q2izJwUjTd211C2NoG34H43xm7AAH4OmXAK/zUV9rxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaQdlJn5GgaUFZzw+sW1vMCnr3PgVKX9ce6CEJ3AGNkGIudLhJ8cfT/tGSKb8cHkm
	 9KUUwmqdsGNi6P2CCTbrITQaVowKGjvj/YeI0RKuQjEGQGYG88VHy2uqMFxxW8Ed6n
	 jnVdwJ1k0iLfCPy8W9ZkShfkZKaobm2zQA4T9IdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 056/105] ASoC: qcom: q6apm-lpass-dais: Fix missing set_fmt DAI op for I2S
Date: Mon, 22 Sep 2025 21:29:39 +0200
Message-ID: <20250922192410.382789188@linuxfoundation.org>
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
@@ -262,6 +262,7 @@ static const struct snd_soc_dai_ops q6i2
 	.shutdown	= q6apm_lpass_dai_shutdown,
 	.set_channel_map  = q6dma_set_channel_map,
 	.hw_params        = q6dma_hw_params,
+	.set_fmt	= q6i2s_set_fmt,
 };
 
 static const struct snd_soc_dai_ops q6hdmi_ops = {



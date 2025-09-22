Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CD6253B5C;
	Mon, 22 Sep 2025 19:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570315; cv=none; b=n1zLkPoe89naT0tHWpTD7bGxe+fZESg36nsYUW1GuKrGx0sq99QS/t7eZjrhD3J2ZUX0n2udckNSPA+RclBW3Fg0PEJ4AtUMCuNBlYJaCO/SM5DoFkq5Pxevum8eu0DLB3j96P7cY4QIUZVWwRdOrUoJ63VhKUBx1pnWyBS+6Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570315; c=relaxed/simple;
	bh=WDg2Da3X7gw2eU3Lprar6XdhZfISpLyMgU2TaznuIik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9tsBK+UasZupT9GcPvHumC2OxK6dx8Z4rls6vaJuG4uTTl2knBPXVO8FBwLgCgUCSgqbutkN5i6kZo8ICxfDsMWWHPh52Qk8EOfqF6F0S/1lle+rKNxRzvwpPZNp/wV6FF+J5x1u5eAJZ0+WpkbR44eODge/eO0h6pKxNK2PqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6rq/3B0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6rq/3B0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C20C4CEF0;
	Mon, 22 Sep 2025 19:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570315;
	bh=WDg2Da3X7gw2eU3Lprar6XdhZfISpLyMgU2TaznuIik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6rq/3B0fvIEbLKBn1j9NtWEp8znbUNXNGD/am10I8D5lzTpHnxpnm2PmVWVh5JG7
	 QHcz1IqMc5wGdgugMghK8RFQ5SNfS+dZxKXL/c6NXLUHeGnutJfcit7cAM4rc65Qqy
	 TYk7KLagGuE4AS0RS+txiOGW11FZ65eJSSh/DrzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.16 087/149] ASoC: qcom: q6apm-lpass-dais: Fix missing set_fmt DAI op for I2S
Date: Mon, 22 Sep 2025 21:29:47 +0200
Message-ID: <20250922192415.079710566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



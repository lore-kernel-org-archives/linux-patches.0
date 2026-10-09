Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0AD4EE857;
	Fri,  9 Oct 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556923; cv=none; b=hhFXBJjPjEsTFj6Fp0+FEezBIWjJzDnTtGge7nImwjMRHCEs2gxzZFeAP9s/CVtjljWC8/CBXPlQNw1O1VhYUJV98wyHDqLCOHJsDNjglLfzBOAq/7IZBQI+qL0ABN5pvgY/p1eikkBI/V8GusvdlK2eIRO6dLDFcmZNMJYBq7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556923; c=relaxed/simple;
	bh=vLpjG4H0d5XGiZSggY/TLOL+zbIxT2lQ5QuZtsqSCKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkrYgwSIyTwZd/LdntPFKN8vLlWXLTkIsL2BPwyBimBX0Xjc1QrqYeIJ5RAmr9Zeb76d2TqJEzKb/dBjYlGSfFhKIFeFSZTfpP3bkdBvOkT6Krcf8oks6ao044SBg9P65PyWT0an/GdBkX3sHjkmXH5dG9mT9Fi7GZpavtC1Gos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEeOjApe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEeOjApe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F089C1F000FF;
	Fri,  9 Oct 2026 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556922;
	bh=1yEXrtJofwuOHZ182FYf/cpdbEFMoUda/OFJWD2fnms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEeOjApek2nBvSlIE470lAFlSm19gMlBoLfvNPivRBzAUsKKXPQaq5IZ6dSvh6fso
	 VcTwI/W96+JRBkJ6vRE3MO96GcF+/MWq/9b63DSV66N+E9ARutPjTDryPytMmE64UG
	 sgS9udlVGn4X3htuASHUcmozwFHq9+GTiYVN+t30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 264/428] ASoC: codecs: max98363: fix uninitialized stream_config->type
Date: Fri,  9 Oct 2026 16:10:01 +0200
Message-ID: <20261009140951.897504813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit bcd61aa247c28b721ac21dda6e4135f75a2de29f upstream.

stream_config is not initialized before being passed to
sdw_stream_add_slave().  The type field may contain garbage and is
later copied to stream->type by sdw_config_stream().

Zero-initialize stream_config so type defaults to SDW_STREAM_PCM.

Fixes: 18c0af945fa3 ("ASoC: max98363: add soundwire amplifier driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Link: https://patch.msgid.link/20260914104456.376666-1-yijiangshan@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/max98363.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/max98363.c
+++ b/sound/soc/codecs/max98363.c
@@ -195,7 +195,7 @@ static int max98363_sdw_dai_hw_params(st
 	struct max98363_priv *max98363 =
 		snd_soc_component_get_drvdata(component);
 
-	struct sdw_stream_config stream_config;
+	struct sdw_stream_config stream_config = {0};
 	struct sdw_port_config port_config;
 	enum sdw_data_direction direction;
 	struct sdw_stream_runtime *stream;



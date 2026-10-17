Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D83AEF36;
	Sat, 17 Oct 2026 17:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256599; cv=none; b=iUcTz0jTktkwtxxdDMDzN/TABGnTm8kM5M4cab1+t8XzeOdeza1a3E9i37C9l9XIyhdxUz1HGQQepVlyaA2RFKeO6VEXwiVV1dpQQsMD8aE7yjG2Am0Jn90qRGAcUaxlWe3y6ogVI3xWh744Xs/enT1XGRn3l1tx+iw5yh0ImdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256599; c=relaxed/simple;
	bh=y/Uht61g1aUK5Cosne6nO+GQ570ShxgU2B35hN7E5Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0/xK3rJW6ulJYxzURzV1jxdSvX0ij8fX2tyNP8uJ4GbCEgQ4PArNRWQy45DezP9vQd08pJxb7d3/RQniA8aPy0t2+m9+d2fvMc6ZU/mn+xMTzQp76dpYRa5HY5euaMN7+D3A25qqv6Os6z6wHK6h1g27g8m0QgKXDEyRWCSCI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJr0QeHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJr0QeHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C861F000C4;
	Sat, 17 Oct 2026 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256598;
	bh=kJ7Yh3heS0eO6Zo780i9qYIEt9s81LufV5shdzSRWlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJr0QeHTBgavm1F9wpOK/P6vRkBu1MvtewYa8jSYefJsYoJQGOlCFfhT9T5V8vVnf
	 yH0ldOxyqgU1JkFBjArx+jGBANHrsx2TqVy8+6vbaw3ckcycURGJ7TZYWdvgBLUKS3
	 ewKAHS4lyZQ02f84VVgqkZPtlNUeRURPBfO9bj7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0288/1674] ASoC: codecs: max98363: fix uninitialized stream_config->type
Date: Sat, 17 Oct 2026 17:42:40 +0200
Message-ID: <20261017160438.507854011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -205,7 +205,7 @@ static int max98363_sdw_dai_hw_params(st
 	struct max98363_priv *max98363 =
 		snd_soc_component_get_drvdata(component);
 
-	struct sdw_stream_config stream_config;
+	struct sdw_stream_config stream_config = {0};
 	struct sdw_port_config port_config;
 	enum sdw_data_direction direction;
 	struct sdw_stream_runtime *stream;



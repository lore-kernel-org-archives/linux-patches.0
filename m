Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334E01DC9A7;
	Wed, 19 Mar 2025 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395103; cv=none; b=Xh5FcUiAVKLTRvTQ7i1Hi38V+PmVyJ4hgaVhZRSTk7AX7U/oycbYVfjW8+G26QSsENJBp+XiXHHsbrRUfKH1CAFPA5tgnC21ov1xV+5a6qAOAHU9jCR9fdh3zma0REFloO0XIW+JqkfLhUV6tvx0J4ZJmT8D2o0xKRDu3X9Wj5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395103; c=relaxed/simple;
	bh=D0Sd18Ycv7nCo2nHn+XZm3Y/0gETg1hpHupOLEsKgUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLYbsMsvS0wle2dQCMclz+EeXRMvhR0cGkg9d/eTA3MVS6ZXvpZ6SzPNFczqKddHrmr69GuspDQjL8++OLC6XPS/FC2C3b9Ak8nTLtK2joJUuJC0jj8DDs6xItL/PeSpD/Y7ArNxdrEKRPoCv20n9MBzBrIC1C6w2f6WIOMfGVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIHKWgHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIHKWgHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C68C4CEE4;
	Wed, 19 Mar 2025 14:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395103;
	bh=D0Sd18Ycv7nCo2nHn+XZm3Y/0gETg1hpHupOLEsKgUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIHKWgHJYWwxG3KzHkw4v9mAOM4HTwfenNiwdnHbnfL2PMjBNqXPZH6mARMN/sWbl
	 +1sk/yH7S9uTk7t4b7MmCi6snEr/dT55+QeC7aQjTDqUlxH4AioMVlLqnBE4oXp7qA
	 +0RvGwHghmpBbqiIBKtJ+Om0DX9FDB1aOw+jA7yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/231] ASoC: tas2770: Fix volume scale
Date: Wed, 19 Mar 2025 07:30:21 -0700
Message-ID: <20250319143029.999819818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 579cd64b9df8a60284ec3422be919c362de40e41 ]

The scale starts at -100dB, not -128dB.

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2770-v1-1-cf50ff1d59a3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 9f93b230652a5..863c3f672ba98 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -506,7 +506,7 @@ static int tas2770_codec_probe(struct snd_soc_component *component)
 }
 
 static DECLARE_TLV_DB_SCALE(tas2770_digital_tlv, 1100, 50, 0);
-static DECLARE_TLV_DB_SCALE(tas2770_playback_volume, -12750, 50, 0);
+static DECLARE_TLV_DB_SCALE(tas2770_playback_volume, -10050, 50, 0);
 
 static const struct snd_kcontrol_new tas2770_snd_controls[] = {
 	SOC_SINGLE_TLV("Speaker Playback Volume", TAS2770_PLAY_CFG_REG2,
-- 
2.39.5




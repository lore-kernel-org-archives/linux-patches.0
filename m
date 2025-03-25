Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E161290BB4;
	Tue, 25 Mar 2025 12:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905604; cv=none; b=McPR+/cnbmcEBiWdu4a6Xb6yd8g4q7RCwGTPnqF338qONv1OCr5tsBz+pIFKyjtRXHRLxX2T9cn3PbXsvi5fjT8JhNkJ/6LbespSwyDYb/p/i+kBiegRdThdYxBxdDq1/hsMfxsMGPsyYU4yqy+0ZRtB+J6EMQbYyR5VjKWLQDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905604; c=relaxed/simple;
	bh=FCrjv6qTU6QgliBHuC7IHxNz8HjTi6Ma6bwqerhfVQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZZZ7yBe8Tmcha62iQft+YOCOHTpJKvxBxltJNkl6Uufjy8Ml0agJ5T80pHipOmhrk3tKtlVWBKpkwTjxg12ObcSDfwAaGfDjq9mp30qad8hbOr1Bx9qxSrZTYgaGFFu9J8zYG7liD5x37XZE6RxBAdzlfFw7/EZhbL8cDbwiIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKP5Crd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKP5Crd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95BEC4CEEF;
	Tue, 25 Mar 2025 12:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905603;
	bh=FCrjv6qTU6QgliBHuC7IHxNz8HjTi6Ma6bwqerhfVQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKP5Crd/Mzhal+FII/VJjJGcScShx0j959yvja+/8RBsEUJEFiwxpmOXpf9bo3Cav
	 gvQakzUd25/NKPqoFo3XQDuagJLyPqI2lAeZ3wBZdPONzrF/NNrW8VuLRwIC9lx+70
	 6whqevc98nWA8DuBLmj0RUzqp/zlPA4jUrvC0tIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/198] ASoC: tas2770: Fix volume scale
Date: Tue, 25 Mar 2025 08:20:25 -0400
Message-ID: <20250325122158.298164514@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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
index 8557759acb1f2..e284a3a854591 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -508,7 +508,7 @@ static int tas2770_codec_probe(struct snd_soc_component *component)
 }
 
 static DECLARE_TLV_DB_SCALE(tas2770_digital_tlv, 1100, 50, 0);
-static DECLARE_TLV_DB_SCALE(tas2770_playback_volume, -12750, 50, 0);
+static DECLARE_TLV_DB_SCALE(tas2770_playback_volume, -10050, 50, 0);
 
 static const struct snd_kcontrol_new tas2770_snd_controls[] = {
 	SOC_SINGLE_TLV("Speaker Playback Volume", TAS2770_PLAY_CFG_REG2,
-- 
2.39.5




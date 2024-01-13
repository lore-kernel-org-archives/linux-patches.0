Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D501846;
	Sat, 13 Jan 2024 09:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSS3rxW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C88C433F1;
	Sat, 13 Jan 2024 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139868;
	bh=l5fTT+2bzfisZWcyiEJhw+3KZQvW4OyQTEXWeDRXP/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSS3rxW+n8pjQNNTpzmJg241QdYV95TonjWFsQw4npYJJinMqTbsZzRNhhMUdAiX2
	 DAkutsYkDQrutB3T36r8pjpT9ubQvUPCvovupVdYNKt58dYsMV1/DpwRXIcLxzg9Ji
	 nZ0QUtLjEhxnWC1zT6+zYcTCSYa4o6pw2PUq2o+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/43] ASoC: meson: g12a-toacodec: Fix event generation
Date: Sat, 13 Jan 2024 10:49:58 +0100
Message-ID: <20240113094207.531315359@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
References: <20240113094206.930684111@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 172c88244b5f2d3375403ebb504d407be0fded59 ]

When a control changes value the return value from _put() should be 1 so
we get events generated to userspace notifying applications of the change.
We are checking if there has been a change and exiting early if not but we
are not providing the correct return value in the latter case, fix this.

Fixes: af2618a2eee8 ("ASoC: meson: g12a: add internal DAC glue driver")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240103-meson-enum-val-v1-3-424af7a8fb91@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/g12a-toacodec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/meson/g12a-toacodec.c b/sound/soc/meson/g12a-toacodec.c
index 0938f590de226..5ddeb22ac685a 100644
--- a/sound/soc/meson/g12a-toacodec.c
+++ b/sound/soc/meson/g12a-toacodec.c
@@ -85,7 +85,7 @@ static int g12a_toacodec_mux_put_enum(struct snd_kcontrol *kcontrol,
 
 	snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
 
-	return 0;
+	return 1;
 }
 
 static SOC_ENUM_SINGLE_DECL(g12a_toacodec_mux_enum, TOACODEC_CTRL0,
-- 
2.43.0




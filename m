Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAF51FF5EC;
	Wed,  7 May 2025 18:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643906; cv=none; b=kpYhQL7ytQfjTVtfxlIOvGvznhokrOqR41nnho54ajybwyE9LnqP5H3i4qr40k4ejsmQv6v03yUqKloe+lQtHxujWrDSbolQMmtaMsTRs2bUCdLqpmGtVlrpJTp50cAzVGh6/asL7XovbZRCjmVIv+bYaXMKFPNVwXQibBrf4UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643906; c=relaxed/simple;
	bh=Fc1hG6vPymAigVR+KsDZ0ixCdPycpgvi7vb7Gw0L6P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyFrOjUNSCo44tdnKZanh3M9hUv2t7G3Hko899T9Xem8W6jrcWUst6hS+JIEXXKfU5HeqktMVSoFNvnkyAXGGOsphZq7nOdNeeQtdxSMamq78quS9Tf7mFHzLwAjR4frhUYcNFQ4U9ozQQW4BrlzTVfRvYKnPYuuROBTJKkesDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy3pGF3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy3pGF3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECBDC4CEE2;
	Wed,  7 May 2025 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643906;
	bh=Fc1hG6vPymAigVR+KsDZ0ixCdPycpgvi7vb7Gw0L6P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy3pGF3BBe6jPLslZA84Ywz+Vqdl6nCMTMat//GyeGKdwyNWA52g0ZJbv+GMDZBcg
	 1QFjYb+XXltqGh3ydqebksbn8IRu3Gy99e2b6E7EEZcfHNF5EzyiYL1TSSt7ober1Z
	 mZqINFOwajyCCWXil30GkYGOBvv3ENh2jnXIevsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 057/183] ASoC: Intel: sof_sdw: Add NULL check in asoc_sdw_rt_dmic_rtd_init()
Date: Wed,  7 May 2025 20:38:22 +0200
Message-ID: <20250507183826.995608279@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 68715cb5c0e00284d93f976c6368809f64131b0b ]

mic_name returned by devm_kasprintf() could be NULL.
Add a check for it.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: bee2fe44679f ("ASoC: Intel: sof_sdw: use generic rtd_init function for Realtek SDW DMICs")
Link: https://patch.msgid.link/20250415194134.292830-1-chenyuan0y@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_rt_dmic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_rt_dmic.c b/sound/soc/sdw_utils/soc_sdw_rt_dmic.c
index 46d917a99c51d..97be110a59b63 100644
--- a/sound/soc/sdw_utils/soc_sdw_rt_dmic.c
+++ b/sound/soc/sdw_utils/soc_sdw_rt_dmic.c
@@ -29,6 +29,8 @@ int asoc_sdw_rt_dmic_rtd_init(struct snd_soc_pcm_runtime *rtd, struct snd_soc_da
 		mic_name = devm_kasprintf(card->dev, GFP_KERNEL, "rt715-sdca");
 	else
 		mic_name = devm_kasprintf(card->dev, GFP_KERNEL, "%s", component->name_prefix);
+	if (!mic_name)
+		return -ENOMEM;
 
 	card->components = devm_kasprintf(card->dev, GFP_KERNEL,
 					  "%s mic:%s", card->components,
-- 
2.39.5




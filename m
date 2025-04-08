Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2360268C4F;
	Tue,  8 Apr 2025 12:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115504; cv=none; b=PWZSCwOtgso5kjEYAgxJJxivyjDEfN/JQya3o976zgELA2ZswZaMsJsUXTDY4sNOC/uXQnx2ENJBmXdiMTp1RRXMgpRwgq/zu5+dp2Rg8B3o8fevNq3dmMsPvR3pPLQH5FsCCdPFuuzuN8xotaUmVrcGVjWWqrsElSkQhV0OZBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115504; c=relaxed/simple;
	bh=3WGBUHX12fTxQjneKWf59Yet3/fWAIWTusa1SQc/SXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+9u56X5RPaokJDi6iPwbiYPfXEA9xwMtKFQ95lp/HbLXwvK72Y2EuEQbPU3ysp0UA9yvRCpk7sJyr9tqpT2XITVm5M0UrbvI3qKjE69aRZnjQ0GEgNEtCm4Q/zmH+sz96s43r5roquyvi/NW/u8MyZ5DUiLOd116ZJNHGAKTgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlGniaGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlGniaGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83719C4CEE5;
	Tue,  8 Apr 2025 12:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115503;
	bh=3WGBUHX12fTxQjneKWf59Yet3/fWAIWTusa1SQc/SXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlGniaGV0gVJkXVxMewv8Tmqur+6iOIHkwTF9LEE8XCSsuxwH9O2pNkUY5Dm/RBA1
	 N8QdI2uFdFkFP4PR2aJZiw9Xzv4d5TGG3Eva41kvQXy2Nnf3aZ7K2KSSrPehk4boKR
	 cO4jlBb3ZSa4jFlEwB+2S9Wz7ad2G6R6cdY1EMzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 498/499] ASoC: cs42l43: convert to SYSTEM_SLEEP_PM_OPS
Date: Tue,  8 Apr 2025 12:51:50 +0200
Message-ID: <20250408104903.782158762@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 658fb7fe8e7f4014ea17a4da0e0c1d9bc319fa35 upstream.

The custom suspend function causes a build warning when CONFIG_PM_SLEEP
is disabled:

sound/soc/codecs/cs42l43.c:2405:12: error: unused function 'cs42l43_codec_runtime_force_suspend' [-Werror,-Wunused-function]

Change SET_SYSTEM_SLEEP_PM_OPS() to the newer SYSTEM_SLEEP_PM_OPS(),
to avoid this.

Fixes: 164b7dd4546b ("ASoC: cs42l43: Add jack delay debounce after suspend")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250305172738.3437513-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs42l43.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/cs42l43.c
+++ b/sound/soc/codecs/cs42l43.c
@@ -2417,7 +2417,7 @@ static int cs42l43_codec_runtime_force_s
 
 static const struct dev_pm_ops cs42l43_codec_pm_ops = {
 	RUNTIME_PM_OPS(NULL, cs42l43_codec_runtime_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(cs42l43_codec_runtime_force_suspend, pm_runtime_force_resume)
+	SYSTEM_SLEEP_PM_OPS(cs42l43_codec_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 static const struct platform_device_id cs42l43_codec_id_table[] = {



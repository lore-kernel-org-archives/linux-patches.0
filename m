Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F20A183CD7;
	Sun,  1 Sep 2024 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209196; cv=none; b=Ef9/QK+lyxvxv8nUdmRQaRzUl9AjJopFSa+dMtM+TUNBnJFGbp4VtAFcFZaclA/iA7mEJXe6x8+yl+T5DEkSxCEMfSVBifhdGwpyIzPC9IpXU8/7hBLEcPffiGUfzMjACVUSbAqDzq8QNYQ722MxjhdcDJbiefvzJQ9e71CUQs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209196; c=relaxed/simple;
	bh=AUThN5kgPouPnuNvSnVPDq7p1KXovvVAwLMH/upSos4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/tUvoNFfP7WTjo+GnlOXpZ3Ca4HyOhktf+tCJ324FxZ91+SE0K+3+bciduj8+h+wX8Uqv1pHttRDjivqj+jWMhlLoqv4FncVyTJWTFF80ZTDf4g4+hGvKVXXmT996zq3anXSWxw7UziosRfzQ5f7R28RTqJTPKw3MGuVEg/G1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Man1/0Ys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Man1/0Ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181E9C4CEC3;
	Sun,  1 Sep 2024 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209196;
	bh=AUThN5kgPouPnuNvSnVPDq7p1KXovvVAwLMH/upSos4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Man1/0YsBFW3xi2z2fAgBEJEwFPUhFJbSDOIkU33w5KVkAmn6eovAihpwvreiHT3e
	 hM6ih8jzM8SOmW4ywMg5SFuVE9BGO6IZpH0exCAOY9QVbtm91pOGylVUW5ySHitEo0
	 +v7sbSREVrgm4cjnzhKUDPLN83PGiAqC0hpZT8Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/71] ASoC: amd: acp: fix module autoloading
Date: Sun,  1 Sep 2024 18:17:36 +0200
Message-ID: <20240901160803.065873194@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit 164199615ae230ace4519141285f06766d6d8036 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from platform_device_id table.

Fixes: 9d8a7be88b336 ("ASoC: amd: acp: Add legacy sound card support for Chrome audio")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Link: https://patch.msgid.link/20240815084923.756476-1-liuyuntao12@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-legacy-mach.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/acp/acp-legacy-mach.c b/sound/soc/amd/acp/acp-legacy-mach.c
index 1f4878ff7d372..2f98f3da0ad0b 100644
--- a/sound/soc/amd/acp/acp-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-legacy-mach.c
@@ -144,6 +144,8 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
+
 static struct platform_driver acp_asoc_audio = {
 	.driver = {
 		.pm = &snd_soc_pm_ops,
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DBD224AED;
	Mon,  2 Jun 2025 15:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877092; cv=none; b=U3oWXPfdPILdIahoZ9TbnVjf/DZP3J+n6EVn0ZvXQ5t9gwSl3mC3MnCOkA05ubvOG24gl7hWzJKOyjS8Apkv0qboBhg8fAADbCf96mLkWAmabcdqaMM7DuoKR+8Pc9odgOsdqxaLlj4mRfe+VRSnAQSfs/ImpR28/fd8CK4Ax5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877092; c=relaxed/simple;
	bh=uM8N2tBLnSTlaWsiEYKspCrkHBA0KrdlZDhsQCKQCCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTAOwLwpM5emE18+TC4bkhh2Nvi5yZDJiR/yvCffosv7co6oIVV5oJXmGn3VfIYng1Qg6noX2OZ+6YgNQziqA37ShRf+0nZVJNzKt5f8SnY8UycRVwD/xhBF8Ec5HSvkT+ph0GOXQIwDxYzD38NMIQnV996GOWXcdYlxjSTmXuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NpBlyBSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NpBlyBSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0201C4CEEB;
	Mon,  2 Jun 2025 15:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877092;
	bh=uM8N2tBLnSTlaWsiEYKspCrkHBA0KrdlZDhsQCKQCCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpBlyBSXksNxLgZZlRYQ56VV+VAC8aQk4QLVmlWbENujCjsU1UmgmCaf/DOSAjvaE
	 XvJI0ESZJchESIY5R+KC6umCxbggrPzYXJQT7yt55sySL2UD1SBG/G+yWh0uEoRGIB
	 qrTn1GjqJ1qX6YvcTzUjTU4+gQVFa/8vUj3wMsUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/325] ASoC: tas2764: Add reg defaults for TAS2764_INT_CLK_CFG
Date: Mon,  2 Jun 2025 15:47:24 +0200
Message-ID: <20250602134326.642402867@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

[ Upstream commit d64c4c3d1c578f98d70db1c5e2535b47adce9d07 ]

Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20250208-asoc-tas2764-v1-4-dbab892a69b5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index fc8479d3d2852..72db361ac3611 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -636,6 +636,7 @@ static const struct reg_default tas2764_reg_defaults[] = {
 	{ TAS2764_TDM_CFG2, 0x0a },
 	{ TAS2764_TDM_CFG3, 0x10 },
 	{ TAS2764_TDM_CFG5, 0x42 },
+	{ TAS2764_INT_CLK_CFG, 0x19 },
 };
 
 static const struct regmap_range_cfg tas2764_regmap_ranges[] = {
-- 
2.39.5




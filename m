Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D2117E90E;
	Mon, 27 May 2024 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837038; cv=none; b=I9dwu2wPAuadt9hjURuvkVCq8O9PmV0P4sXXrkOT5LdFE8tjEo3ZwvtCCAkLjdB0UzFlJcYEOAuaZ6CajJCoHPCg1+2bbtcq7R23eMEm/xvQSDTzx75pZmJjFqRDXNNPJrGOA09xcbL3x1RvA1utOWcONTRuF74kW6qm3BAH0fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837038; c=relaxed/simple;
	bh=4310eRFM+jHm59xIGJJ1PV/klx3v24uYmCmsHQqmJwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvHxA8eX2iiKsLsLA0pNhFMoQv5I6vVpVpnnAT0FD6GO2pToOJSSEOnMk4oTopnqFIURCBCHbkScK626uPJPue0Ht4g767Tg5YWbdYPgWq8nrJnvkQVaLAvnCxESl1JR4rReATd0C2F5sWvvTfIwKZVePRGi0fnc7GGmTYkUdXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eumjT52/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eumjT52/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4E4C2BBFC;
	Mon, 27 May 2024 19:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837037;
	bh=4310eRFM+jHm59xIGJJ1PV/klx3v24uYmCmsHQqmJwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eumjT52/Iw4xVDBAeeJ+pZ9U+Pbu5PF1jS3KWsqfznHWR2+y+uNX6p8QUGkPcgXhc
	 vq0JVgPzZz37PIO3EI+ok5TVphjVogSv2j+Dl9Ft7QBcogN4QgzKLqa1UzzdYQ5b2i
	 K1uy6qit37KhEjGxCzLvhTPyRc9wOyv7KDDkuJrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 287/427] ASoC: Intel: avs: ssm4567: Do not ignore route checks
Date: Mon, 27 May 2024 20:55:34 +0200
Message-ID: <20240527185629.247598235@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit e6719d48ba6329536c459dcee5a571e535687094 ]

A copy-paste from intel/boards/skl_nau88l25_ssm4567.c made the avs's
equivalent disable route checks as well. Such behavior is not desired.

Fixes: 69ea14efe99b ("ASoC: Intel: avs: Add ssm4567 machine board")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240308090502.2136760-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/ssm4567.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/intel/avs/boards/ssm4567.c b/sound/soc/intel/avs/boards/ssm4567.c
index d6f7f046c24e5..f634261e4f604 100644
--- a/sound/soc/intel/avs/boards/ssm4567.c
+++ b/sound/soc/intel/avs/boards/ssm4567.c
@@ -172,7 +172,6 @@ static int avs_ssm4567_probe(struct platform_device *pdev)
 	card->dapm_routes = card_base_routes;
 	card->num_dapm_routes = ARRAY_SIZE(card_base_routes);
 	card->fully_routed = true;
-	card->disable_route_checks = true;
 
 	ret = snd_soc_fixup_dai_links_platform_name(card, pname);
 	if (ret)
-- 
2.43.0




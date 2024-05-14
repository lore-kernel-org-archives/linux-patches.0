Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4775284D26;
	Tue, 14 May 2024 11:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686987; cv=none; b=tNpiwg1jAQ7IkmcTFalwD2L2yCqRTc+Ga5jRaqp7oEPKiYTGQpw9D7Aq7gXH2NTblhX1INzDqzvqyy8ifARwRHMRVvvA4YIKKclrbrKHPKXTmne4rG/cFyyBB7lv+g9Fbc04HTcSA7Q4VGzKIM95IX9EDXB69hqzywaLoufuIN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686987; c=relaxed/simple;
	bh=N4x6nPQB7Z8sBDNSS7R25K86giBWgQ9VLRUcyQVV+A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cw4gQgw3263r2uDgPSXv8o5A4w3qkck7pzCi6nmwWc84SfMRlaLJALdu+F73MCJQ1w64PQ5ZvRCye4enSk2f9ovLehGR493HkUz+Up4m9PpFUKq2OQpRlTU4ml70rMbi2ECKHuPYFCHOMoOkYTIMRrs4tT43sAHdasYNSECYwLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XkMkFyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XkMkFyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59A6C2BD10;
	Tue, 14 May 2024 11:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686987;
	bh=N4x6nPQB7Z8sBDNSS7R25K86giBWgQ9VLRUcyQVV+A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XkMkFyZl4SeMPF69Tu1JtLMWtxEN0mqlG/rPkngLmsrgSeW9X15e2clQ8M6MeZEy
	 tAsWSZPSlW85ZfZJMwnr5xv94cKtu0l6/BBjtqyaPpsTVb5g1HoNzGGOZN2gDxvDen
	 U41PCtjvYsP8bw4riPZqcSlYzS8u91QM0M6FKaPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/84] ASoC: meson: axg-card: make links nonatomic
Date: Tue, 14 May 2024 12:19:37 +0200
Message-ID: <20240514100952.679705745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit e138233e56e9829e65b6293887063a1a3ccb2d68 ]

Non atomic operations need to be performed in the trigger callback
of the TDM interfaces. Those are BEs but what matters is the nonatomic
flag of the FE in the DPCM context. Just set nonatomic for everything so,
at least, it is clear.

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20211020114217.133153-2-jbrunet@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
index 7126344017fa6..36a004192b562 100644
--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -568,6 +568,7 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
 
 	dai_link->cpus = cpu;
 	dai_link->num_cpus = 1;
+	dai_link->nonatomic = true;
 
 	ret = axg_card_parse_dai(card, np, &dai_link->cpus->of_node,
 				 &dai_link->cpus->dai_name);
-- 
2.43.0




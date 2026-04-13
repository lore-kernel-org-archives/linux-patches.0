Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BC4299929;
	Mon, 13 Apr 2026 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099754; cv=none; b=AXHuW12N1BykRIc8dgKS6PpXvCPjvpny9wNNLj29grOCJ1sUZc6LlFyPtuWkBxC4u10guw5gZH9ZdIyD/88KA1hxnJLi2FkmNrluiOkgtQawQ+Ha3ftzVN2S1qj6P31U/P+X4v6PgExtxNNgvEn+NEmf7J1w8EgyDvZ9ZhLJ+5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099754; c=relaxed/simple;
	bh=knqkcp6pcOHCVJnrhYuQvBKeT7jZHhXpmbL38oZ3ujg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLzotIDpWAllkw4npRsxBlW6m5O/hpgiRg/7xI9OUxYjR+QxpxxT/mkJTKLVQ/6LATHeRCpKGvTHBAzwhbJdbN5+ilfu6eSua3fkTXX9v6wZRlAaCNe0JUYU2kkQ8qy6T4uiyR4ZX8ijnKsmvILTLpg7ly7BogDjs2mbtBL1iHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEfKZs+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEfKZs+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11282C2BCAF;
	Mon, 13 Apr 2026 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099754;
	bh=knqkcp6pcOHCVJnrhYuQvBKeT7jZHhXpmbL38oZ3ujg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEfKZs+Sc6w6zBxskuvKHlfzmXnQjsrDa+CqJ3CQ/mGZ5hsrWG9FImkSm7eaVlZfo
	 p0gibWAOysNQbST8mL5hM3+9Jxo7kWOPYsd1b8Ej+lQAgzAtMArWkizrwmlINJj6x/
	 nB6up1Nuq+qOW214uwFi+df/2Iv0+0gDW37Hmvis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 454/491] ASoC: soc-core: dont use discriminatory terms on snd_soc_runtime_get_dai_fmt()
Date: Mon, 13 Apr 2026 18:01:39 +0200
Message-ID: <20260413155836.033185311@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 640eac4c849d6390f272862ba8db14f28d423670 upstream.

snd_soc_runtime_get_dai_fmt() is using discriminatory terms.
This patch fixup it.

Fixes: ba9e82a1c891 ("ASoC: soc-core: add snd_soc_runtime_get_dai_fmt()")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/874ke9dxkp.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1209,8 +1209,8 @@ found:
 		mask |= SND_SOC_DAIFMT_CLOCK_MASK;
 	if (!(dai_link->dai_fmt & SND_SOC_DAIFMT_INV_MASK))
 		mask |= SND_SOC_DAIFMT_INV_MASK;
-	if (!(dai_link->dai_fmt & SND_SOC_DAIFMT_MASTER_MASK))
-		mask |= SND_SOC_DAIFMT_MASTER_MASK;
+	if (!(dai_link->dai_fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK))
+		mask |= SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK;
 
 	dai_link->dai_fmt |= (dai_fmt & mask);
 }



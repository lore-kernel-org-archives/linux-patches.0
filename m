Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC250151988;
	Wed,  5 Feb 2025 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766193; cv=none; b=hu3z7ZJjSAc94zWa9KYOzAOrx+rjtUTLsoqqQJlvKqUfAEAO4uJ133ZFt8LPkwUxyI9IfzfT4g26ONf0yvQG7bM7e1RCZ/qNfmXpyZmXLagBd4wB6n/nkeIFlfkaBsfXCrbFaOItxu91Xs1O5v6xfkNHy3BvBk8/M32xUlDnivU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766193; c=relaxed/simple;
	bh=J+8jkd3g7FdEKl3lhtdaTvzlnfvl1f0AkNtYP2CXods=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/428T85ArQhqOCNFBfpR0ptKX7XQKtlAYYc1nHso+IsJhxI/DZDUsiWcWx5Aey+l3znyUCvoRkHfShypmJM2GsqA0OjNcg1cN+uPqSSF5PZlFGMI8BwJeCkW0dqYfyn2w4UQBOXWYtQMR8cdYQBCp+n0oWGeIq5LLom+DhNPu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wag64JdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wag64JdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F03C4CED1;
	Wed,  5 Feb 2025 14:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766193;
	bh=J+8jkd3g7FdEKl3lhtdaTvzlnfvl1f0AkNtYP2CXods=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wag64JdS/xavd4zPhjSN0+jLky1ngeb6jVBzazyAF0vTI6Z8rarjfWC5fbWUJkiYa
	 O3tWDM9DU0o+/8v1bLRW99y+qV0OTjhKkfjzain4I8fj+QyehHNYLxcL4YJiPp4Lsc
	 KwCWjHEwsyAudJ8kLpvl20IDDi3BsgmcKSD3EgrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 251/623] ASoC: SDCA: Use *-y for Makefile
Date: Wed,  5 Feb 2025 14:39:53 +0100
Message-ID: <20250205134505.834593234@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f60646d9c3bd5b390728ed1a1caa9ded53d47afc ]

We should use *-y instead of *-objs in Makefile for the module
objects.  *-objs is used rather for host programs.

Fixes: 3a513da1ae33 ("ASoC: SDCA: add initial module")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241203141823.22393-4-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sdca/Makefile b/sound/soc/sdca/Makefile
index c296bd5a0a7cf..5d1ddbbfbf62b 100644
--- a/sound/soc/sdca/Makefile
+++ b/sound/soc/sdca/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-snd-soc-sdca-objs	:= sdca_functions.o sdca_device.o
+snd-soc-sdca-y	:= sdca_functions.o sdca_device.o
 
 obj-$(CONFIG_SND_SOC_SDCA)	+= snd-soc-sdca.o
-- 
2.39.5




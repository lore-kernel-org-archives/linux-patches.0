Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046D77BAF7;
	Wed, 21 Feb 2024 14:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525686; cv=none; b=qOGtjeDPhf7R6C80hRHiADN9UZLAs1XUCm0WV9zEbOlfMXrVtKxNGWzk+VRQhtCDu0LRa8bKyD+FtbL36ydUCYTPGUXEckOojt9Z+N7ZD7LyPMJE7vSZWeOWdN0xJZXUSb8xkBZaTz0ScVkExrxAE01JTc0wHjQLbrbR6B/zP8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525686; c=relaxed/simple;
	bh=5czdQ1ULAy4bFgxgAdcZBPt0vwVEMX9TT446CwlX2FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzL1XMa2KMEnq65J5KL/obaAsJCgBlFdfe3M6/kpCCo8INa0zpbY5lT1CP0CLIfhUHvIURq/3HGCHIPspvqRovAzQkc3jizpRduRCGBYjbjXr3LC+AQJrMcSO5EtQ0FHCCX86akEP85SJjVDuGkJjpimgncD1m7mytQeAgNc+LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BI+Ozcrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BI+Ozcrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B551C433C7;
	Wed, 21 Feb 2024 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525685;
	bh=5czdQ1ULAy4bFgxgAdcZBPt0vwVEMX9TT446CwlX2FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BI+OzcrnU6rpgWcycrB1Ogi3ME4xYSpyDVY/DjB0HZA18nMi+3QwJXSHe8ZCgg5Qz
	 bwhORudXA3G3RXRlofiQaYBxVfMYXZabCylVtc+wNu1jfZg2pBinI32q7254iRI7eB
	 46o4I0R2Ky4uoUDuUN1eVTOHpf14wZxc1y0CJHj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/267] netfilter: nft_ct: reject direction for ct id
Date: Wed, 21 Feb 2024 14:08:54 +0100
Message-ID: <20240221125946.191542878@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 38ed1c7062ada30d7c11e7a7acc749bf27aa14aa ]

Direction attribute is ignored, reject it in case this ever needs to be
supported

Fixes: 3087c3f7c23b ("netfilter: nft_ct: Add ct id support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9507f1e56107..161c4fd715fa 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -481,6 +481,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		break;
 #endif
 	case NFT_CT_ID:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
+
 		len = sizeof(u32);
 		break;
 	default:
-- 
2.43.0




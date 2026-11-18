Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056252;
	b=FMJCaqhNiAOpxATLK4canp4b+yu2y/CSDU8jXReBYzANYWgeojnhwCwnIVhQaUYjcLg4
	 0H9nfESq5agixHuThQSuVyVUF6OeocTZNQ1c/TxsOVe5iDWxsgbIbtZ/bJMCTsobrkLin
	 ugA5Cyo9nCgsuQkd/3fPOUvI/VfMntDE778BcrPDsa+li38gDn8PQfLwZd4uxDi2tdPrX
	 I1gXsELvgqrkCfoiWwBaODvuHVzbgWIR5e3kCr0M8JHcXYbCJqBIdz4QicgZPC0+4wsna
	 auZiTgHcDH4QO9ZLiZA1HYiS0CcDGVELWqQ7t35quAjD8fBkfcFh+blvNd9kx68AEXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wulPjn0DqAo6JUT5OTNy9JNoDn+GyGXy1d6EOE5xqXI=;
	b=dkTc9QzxBKyJbC/+eWJNzw+qY+WYeaM7I9YkJ90gMRNxcuV4IJcj+7NsXjPCOvq063qm
	 2swbjSz9uNpjrzHqm0+0lCX4LTekk8UMF5xkEYc4gFnqj/iqpaNw0JYRMTEgzbW/BYw01
	 pR4umLtVwlPCeOLAdhtg4P360rLjqN7eiU57xPbvXHahsDvR42yswG8ocgURY50+dKARe
	 PjNlidKQ/9D+RVhZXABSU4SZKJiyjeaPxzTYoJ1W911J6it/WZKYntaTqM9u2kehJyUAT
	 0GtM58ngQ9sgxjkgM9VX4OSGHyNpuV4VaNVsGPaDJcSdrwdxrtPROotr2w7kFP7njgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obfDbrZ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37958606A330;
	Thu, 19 Nov 2026 02:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=obfDbrZ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7571F000C8;
	Thu, 19 Nov 2026 02:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056252;
	bh=wulPjn0DqAo6JUT5OTNy9JNoDn+GyGXy1d6EOE5xqXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obfDbrZ6R9CdDi/M9TICoWgV3aIA9MRvXGuITHbhg6xYLdse3dXCKkAI3BCiVOxcJ
	 CD3TyLk3MDRZogqJKSJzEifiuFsMbpqqKwfel0D9GHakUBaTvKnu6GdhhRvXPs52mj
	 0clYODAW+i3vLB7UfUmZsju8zcJaeiDUipicZEAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1921/2214] ASoC: codecs: wm8955: Fix definition of Treble Cutoff control
Date: Wed, 18 Nov 2026 15:59:57 +0100
Message-ID: <20261118150127.896997333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 71911bf5bb3fe97da2124d17fc1dd3dbb9379e03 ]

Treble cutoff (TC) is at bit 6 of Treble Control, not at bit 2, which
is part of the treble volume (TRBL[3:0]).

Fixes: 54db41c116c3 ("ASoC: wm8955: Use SOC_ENUM_SINGLE_DECL()")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/b398bc6dcf8dc2b93504608cdf952823ca238cd5.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8955.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index 513df47bd87d6..2b34a5d1100fb 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -426,7 +426,7 @@ static const char *treble_cutoff_text[] = {
 	"High", "Low"
 };
 
-static SOC_ENUM_SINGLE_DECL(treble_cutoff, WM8955_TREBLE_CONTROL, 2,
+static SOC_ENUM_SINGLE_DECL(treble_cutoff, WM8955_TREBLE_CONTROL, 6,
 			    treble_cutoff_text);
 
 static const DECLARE_TLV_DB_SCALE(digital_tlv, -12750, 50, 1);
-- 
2.53.0




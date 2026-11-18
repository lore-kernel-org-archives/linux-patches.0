Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020166;
	b=tsNLRJNhbhUOYsNlbH1ukwJ6Llx43PR9cw798L+H4ZHAMD75omTruCG30wsM8p8xX0ZO
	 J83a0hOa4Abxjnja0xExLbPwA62X9OANFm4KdM+96SQiUBM7qbdOfkoXi6zHrarDlYNxW
	 U+R1LD1ClTG9DfOcHllCEBBeTMpnO85dJRJP0k15hbpNEYIXsGx8vLODtkM7jl7imz2KU
	 umygDkCd9nGc5wTcfMzT4WdqisBSc5BUIvygEKgKGaMmtRUoOfY1gJVf7f8ZiO+mIxCLo
	 7C++pZ136j1x0xdRs5evmoLq5y+8qTOJ+Pq+xNbvfDp+Per9q1mAL8Vp2L/Aw3ZjFKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsaYvw6/Qa8ra6fzIBRMQ079oA7mBEA9ndYkPuVt4d8=;
	b=UGw43qFCmT9BXItKHrZ65cMF7IB5ytSe/ImNtD5NJ2YSFrYph/uBfkgLClegwWPt0orj
	 mlhbLlYK1bWj9sX65rH4cW/PSm1ywEpWmhmQYpVVeIj5ilj0Q15zlz0ochhRluUxGQmMG
	 +o36O/DqSAbDfYqYoil9QFjyvtm9rawT6QQpJcjgfoIIQBXBfBU6hYzx4RVnF6oAKc5vN
	 lR3XMzlYZGDMQ3IxiDTeZ5NRKjMM/NhilZ8F+ECIb8zRqp9ujtynjlbb/hAc6IRCyijyB
	 YErnf0R6mksmodsqLcOkLOXjDKdVaiCHoVFUyE36CuJHnREp26LmbgEANdnc5eAerQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rUUvtMoq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CA9606A31C;
	Wed, 18 Nov 2026 16:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rUUvtMoq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B091F000C4;
	Wed, 18 Nov 2026 16:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020166;
	bh=IsaYvw6/Qa8ra6fzIBRMQ079oA7mBEA9ndYkPuVt4d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUUvtMoq/0PwFpCS3qob2HWu+jRql0jgAmHLzhOO+z74FauTX7bz87v9w/pDiwesf
	 pzXApOGNXuPx0LvwtvqrZ8zA9Joum8rywo99AvRVS7j/NFHQNvR7/WxcWesInKpWci
	 nmLejztsT/4QXKnvsjS8PVFCT4slSH2e8xV6klNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1855/2651] ASoC: codecs: wm8955: Fix definition of Treble Cutoff control
Date: Wed, 18 Nov 2026 15:51:35 +0100
Message-ID: <20261118150353.806993813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c897a9ab764dd..d872d4e00529e 100644
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




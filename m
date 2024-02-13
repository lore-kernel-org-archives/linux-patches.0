Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF70560277;
	Tue, 13 Feb 2024 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845820; cv=none; b=uG7DcsfW9uNcARC7gH4WIm9st7yNYis1kSpXKqaPRekWrtMVM4v/cbipgFYFOOg6D1lW9AIIPHir4Rc+SWn07B8dVUyk/cy+1qVLGUvZ2+9EID7RundNPYd7+ebq3Xz1xWp3C8dXpKMfeocvAKKhFrhoNFtOqs8dtTkQPCz357M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845820; c=relaxed/simple;
	bh=NtVhvxj1+URZvKrK8uPiykK6ntfQaH5+ms/9qfle6v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhTHnhKjR/DiUHqfIoQLu3AoZIYE3IHaLkDpUa85iJRbRTwPLg95Htm5rYlGFiBsDNfgFicoORpNsbDGDpKVUEXVpzUF6ysWeCJNJpOyAoBN7FoM01hdM4vfQKCq3oICf4Ka6c3a1BryqWfI/6q6zHbIoaIK9C3d1Gm3OsI+qxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS2kQ+7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS2kQ+7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A175C433F1;
	Tue, 13 Feb 2024 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845820;
	bh=NtVhvxj1+URZvKrK8uPiykK6ntfQaH5+ms/9qfle6v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SS2kQ+7iiTHDHoyC7WyPMCphYwlZGWU3Tck9ldqjvEkLi7sQjV1rlPYbEjaGoDLzp
	 pyo4lh1C8fNuwm5DVEaFH2ELBHOjysfYysmplTLsU81I8xQUfVty7SbjukYLRNzCwv
	 lFQXV1sxhTzB8jt19GkqptW8duC07lh3iwCpZOLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 066/124] netfilter: nft_ct: reject direction for ct id
Date: Tue, 13 Feb 2024 18:21:28 +0100
Message-ID: <20240213171855.669257458@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index aac98a3c966e..bfd3e5a14dab 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -476,6 +476,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
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




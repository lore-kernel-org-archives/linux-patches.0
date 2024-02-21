Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB8D1E4B2;
	Wed, 21 Feb 2024 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523038; cv=none; b=pE22LFeqw7PsRzR13QaskSa2vufhVjII+4SY34fhc8IU5t/LCRoEKTT/+ITdggoEbwW7WqEC/gcS90ZH/b3w4LPiIDkqDWMfrhEBZ+8OSOPzP4KxL7LwhVPgQbjMQbQFTANGzm1/KJ6VsiLPQXMmXKGDUH3YLu2KztIop9+1DBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523038; c=relaxed/simple;
	bh=171V7SL++2Xw2CDfntx4WHB7uWFpEE494WTSi45Gw5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7hBAX7xeOL3BscdPl6OFZ1R4gzYRN6/DRP/germL6hUVpk2oAAFzWMyhs0xwL+Qu6XDp5GsUTSDfWiZp/ayzdYPE/bRd4Pu3H11TqXp8/zwBFFJpruLd755KVCrz0GsagYbnJg972UCaTqpb3+ajkdBod1MhwbcGSuIccd2P3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpL4Eo2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpL4Eo2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132A7C43390;
	Wed, 21 Feb 2024 13:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523038;
	bh=171V7SL++2Xw2CDfntx4WHB7uWFpEE494WTSi45Gw5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpL4Eo2kbsxxUFY84y9vZVr6JyRtd49QzsAMLcT3G5PBeq/1ROKcFLArAYM6pIsP2
	 UqymFJ+f0hGc3rA7kkGjDJ7Is9wFMf3J+BvUbX04XIAQoV6dLJLsyFWsGQWLigjkHN
	 XVdMMsZQaE6ncGvANWbf63agaRrecyR4v8DW9J+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 322/476] netfilter: nft_ct: reject direction for ct id
Date: Wed, 21 Feb 2024 14:06:13 +0100
Message-ID: <20240221130019.928555263@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d8fd7e487e47..7c667629c514 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -483,6 +483,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
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




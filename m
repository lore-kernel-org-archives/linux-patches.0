Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774208;
	b=HbjiyuhbocyUMobbJ2njv6Nqe6Ar3sUVmCnmmGVhnc5n49rlTf0rK0OoBeWCMclMhDPD
	 MzZyDTNcsMa0rwVU4EPm9nTlrrzBaooHqM7Fm9G2bFsZhrbJNwSWIh8N13hV5mrF4yZF0
	 /hAWK78zEwSbyBglE32J71Fmzpdcrhy4o3v6tiMho7B17loJVASg2qAj0DL9XQzUurzel
	 cHQX2X9UJFt+4KKD20KtNueJfnc2wPsqvESnOHfF1O2S5j4bVWH2edpyMHTkuq1AFr7sv
	 fxM+i3eo6KRNLwVb6ZCCi0Y8Ta6WAVkgusSAsyODz/zLWElEpu03EIcaAfAxaZr5V5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AbYVyhqva/R30Gmxyg8cpiKi9yqYUEdP3/F/lOahRb8=;
	b=MEOmWoOqJ+7mFMwFovTP02hQRZOc/o4Z8NwEwhkHruaN6jUN5w/EnkE8G8iXFrBR/7ua
	 QZkDOKLwzFxHUwYHRH1LkqoMwFd6HW4Yv7C7WSAUvD7iJ3YoUGIhF2CG3Fq0c8NM+r3YA
	 37WSJhWCqugH0wtNHMyYzqtubePlcKjnumPEdc5LdeW05Be+5h6JhWAHLVADF0INAt8mU
	 sLyWJcLmbSWpbYhTiR0wtwUozm1Xj0YYWWLq/K4bjp8wiEyDyX++ZTHt9FxI+YH4kHR7n
	 B+WKTxzM8dj9YUv9+s8RufL8s4RMhqF5D1ALRP+rgyaZIYuLT/t6G2Jo5/tjw8rUltw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuWnUPgJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FFD606A31A;
	Fri, 23 Oct 2026 16:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuWnUPgJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DCF1F01825;
	Fri, 23 Oct 2026 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774207;
	bh=AbYVyhqva/R30Gmxyg8cpiKi9yqYUEdP3/F/lOahRb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WuWnUPgJEfSsqX5XlFMJZt0MV96RwkXD/WbI+0KLhgyoQ8h1RAk6SY1BTTIR3a/aR
	 PNTWzXB7EfdJKWQjD6OA0yA+cjTCE3tmhSmdC9ebAUoAmRUgAq3rWxZJkiNfifnCiF
	 aSrkSl1sxWSVyCjctsEY5GQjT+gP7yN64qCRkuTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 157/193] net/sched: cls_flower: validate mask pointer after nla_next()
Date: Fri, 23 Oct 2026 18:37:14 +0200
Message-ID: <20261023163717.923704766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

commit fee10655709c5c597e8e9f722f3035d9ea31ff3a upstream.

fl_set_enc_opt() iterates the key's nested tunnel-option attributes
with nla_for_each_attr() while advancing a single mask pointer via
nla_next() at the bottom of each loop, so the mask cursor is driven
by the number of key attributes rather than by the mask's own
attributes.  The nla_ok() added by commit c96adff956191 ("cls_flower:
call nla_ok() before nla_next()") only validates the mask pointer
that was just consumed; the pointer produced by nla_next() is used by
the next iteration (fl_set_geneve_opt() and siblings) without any
validation.

The mask's nested attributes are validated with NL_VALIDATE_LIBERAL,
which merely warns on trailing bytes that do not form a complete
attribute.  A mask carrying one valid attribute plus 1-3 residue
bytes (or a non-aligned attribute length making msk_depth negative)
therefore reaches the next iteration with msk_depth != 0, so neither
the !msk_depth check in fl_set_enc_opt() nor the !depth check in the
per-type helpers fires.  nla_type() then reads past the mask payload
and nla_parse_nested_deprecated() iterates with an nla_len taken
from those bytes, reading well beyond the mask attribute (KASAN:
slab-out-of-bounds read in __nla_validate_parse from fl_change()).

Validate the advanced mask pointer as well: when the mask is not
legitimately exhausted (msk_depth != 0) and the new pointer fails
nla_ok(), reject the filter with -EINVAL.  An exactly exhausted mask
still skips the check, preserving exact-match behaviour for the
remaining key attributes.

Fixes: c96adff95619 ("cls_flower: call nla_ok() before nla_next()")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Link: https://patch.msgid.link/20260826025123.62758-1-ljp1205831794@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_flower.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1707,6 +1707,11 @@ static int fl_set_enc_opt(struct nlattr
 			return -EINVAL;
 		}
 		nla_opt_msk = nla_next(nla_opt_msk, &msk_depth);
+
+		if (msk_depth && !nla_ok(nla_opt_msk, msk_depth)) {
+			NL_SET_ERR_MSG(extack, "A mask attribute is invalid");
+			return -EINVAL;
+		}
 	}
 
 	return 0;



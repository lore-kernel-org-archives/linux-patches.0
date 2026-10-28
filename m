Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207903;
	b=42DE1LWqMAozSzods9lp7UrO3cR9sjmGgGEWmKsfBbuLNndPm2soUUbK7H4JY8bSEFP4
	 02YSQdexcoWj94jtRZx9GD5CaXuOtBWzggtMJuYq0Qn1NnS1ksMJHS1sScjKvuH80Mwaa
	 vrsKqp3sP2nYmxEdrhgHltkTdaio4dh38WHXZNGPdqLhfBemOHCOIxSkwChYQ9mT4qYxa
	 46/wYK1NPZEIgGlG7NXs572dov4dCM9omJbv1YhqslxkuutpzopWANWPolFB0XitIJvyv
	 9OxHhZeWbp+w2Cw4aeiREkERwNT/MiW8lajmy2GDYurEvWGj1rjT5GYOCF+LehHy8Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tCWNXo6llDi4s2Jd/UexJKI+sCdz6s7NrLZatjwovss=;
	b=0UhJIWfHUKrKaw9wYGnpnejyuDbuGOCinwOCQ2sqk52EswIMqrcluQvvWqR4wV0BGqG6
	 AUkQTSFzmQtEV6izEeMlR9zhPGGfAprOFiR/xtLb3rRk16ZM+p0Pjkdl+z2nGRTg2QIFZ
	 +JQ9dT7TC26+ZK8UatxN+v+K6mo2R4Ux1g4yB/++7AxiuVWLdKFKRRMdjxMom74OEk0Vc
	 CKpTYwgiYF1xUTsUoTG44SCwh4uJtUMaq6SjWzG4PnOtI40g1b96xbFdBRAk+62etf13e
	 zWEfnSQA8rz2Q8jTAn8mOfdY6EAAky9ceM6FopZxJ9JvMBEGKuWtIUT3bNDbVKZ3QaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaBg9LG7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB6E606A31D;
	Wed, 28 Oct 2026 17:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaBg9LG7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97131F01825;
	Wed, 28 Oct 2026 17:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207903;
	bh=tCWNXo6llDi4s2Jd/UexJKI+sCdz6s7NrLZatjwovss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zaBg9LG7mQvm7xgiDQSuFr8PLdFUNzV2LxI4ffdNTGblMbT/Pv1TNjx4JXnFig8Mz
	 wDQHbLX/rZ7N93hOXEBFk4xM+Wv+ccgj4eMMnQvgHb31z0Zwur3YGL75We9GLE4wT3
	 ryKO8tqaBTtRkzqlsE1c2b6lI3+Fi8uZ76vnzjCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 127/247] net/sched: cls_flower: validate mask pointer after nla_next()
Date: Wed, 28 Oct 2026 17:58:50 +0100
Message-ID: <20261028165950.412079828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



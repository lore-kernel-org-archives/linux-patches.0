Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211864;
	b=KnxAwdtmJCrK1T+S+tR13UKRJLPj8Z/xexhm6ATcx93EewJw6FrL35YbFl5oXT5S7Krz
	 E8Ln9ueWIQbbsb/TdJap9k5aOSneW/XJneSIWQhBQg0kiKUNfWkVg/f4MMPKpHd1qDoHl
	 i4u9z8bqi38bvFIwhTcdNlNwDZIVD6kc7n/7VWjWGzD9ebrfxFcXGuq/ShGmnsnEwoDic
	 wkfDprPZcCdxzsj3QiR1EAudzMqDssmU8nXE+nWC1tRHY3/NR69/NsUYTWla2TwzLvIfd
	 Lg5jVj3VMHNQYzCyIX8yRwmnpPldfO57AEKZA9NsaRB8ViGZuS+OsFjJF8hiNh1mMQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pGNjedzQ8cmQOQnFFMyCssfpFhnNUd/DjyxI8+XCYXo=;
	b=j5UYPvREahDORMBelLo1010vF/yKkHJ8rkLOZFwntsRpgNpVYvGwzDCjBSHi3yYilQFX
	 bylIcQWHzZ95m3Bb8jeLnjuZxpQGYtbydkz7RHyNQFRwdvmeKHRXmyXz7wNHINoVsP2+R
	 zMpmMHkIf8LwVcpyf76Tcr/Ms1Aqdhqa5iNZYyTl/17DepnLMh7JWdwrTNtvyUxxaTxd7
	 +rCxvhkodhnWE1ESTPw1Buxr9GoL2ne8rzXAP7cz7+gdW0VWLTnhBZv43EigCP+aU8Qbn
	 fdc1jo0nO/gmsMD6hTTvPOj8yKke8/9FZWU+0hNyUGsrYvjhuM5cyO2R2gTgdGgAWvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yvgoLi3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B22606A32E;
	Wed, 28 Oct 2026 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1yvgoLi3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F041F01825;
	Wed, 28 Oct 2026 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211863;
	bh=pGNjedzQ8cmQOQnFFMyCssfpFhnNUd/DjyxI8+XCYXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1yvgoLi35yLqP7WhxCAmwuYt7J4qwZrqNJHEKYHEUidvH6U+qFG8nWJQ4Uz8uRuVD
	 IHiHw8UNuM9nD4JEQ1pBS3JMfbc7t3JmcE+SlmggJADREwVt/yYAnOdSXCYa3dsS5x
	 QvyyzJwuCQP/PgzXZPnXCli6M3q4AL4q949niYug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 528/571] net/sched: cls_flower: validate mask pointer after nla_next()
Date: Wed, 28 Oct 2026 18:01:15 +0100
Message-ID: <20261028170020.559767725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -1412,6 +1412,11 @@ static int fl_set_enc_opt(struct nlattr
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



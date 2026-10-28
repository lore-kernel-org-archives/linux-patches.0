Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210139;
	b=mtDZ1Efa1L+Sqw+tLPCq6KowCb9yCCEWEhS2yMNdHy7+IdKjkZKQsXVPpvy0jeZTVvB/
	 c//TWsQkwAt8QyoOTPAPe3+ROyGa16Fol2OaFpGSwL47cb76Hdr2UBjmJrrIRN+Fe9Pg/
	 usggz/qlB9lRa0PA4RQuVAD/7G37ONBvD/rrITizwfA08nYS45330/Pg13hsLTcSwbmtn
	 OxYe8xiU/vuGy6NB+z9UA0IS6tXGmN/aACYwpC0zGe0DF37QlkFnl2ETXo4DutIr9XRBU
	 vVD+eow+xFOeUmVJc3zWuAmD5WExBEQC72lynqrByp/LYHovkoKVb5wLjg1TwpZyIKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUINRV/msbJphN0gyVjzbiAncDWUK4P+jGagPQojNSg=;
	b=3a4KFAEMH0xh2hPS/lfjS4pxD2BvCa4zVCmBYRNiAtaLYdHhBp4ASMrF593IMm/haEp5
	 Q2bXIG4voSQSGVlwSeyizrrA3ujIVTLzQNb710uDN5zc+JggHv6hGhaJHMYQ52R+mcKKB
	 Orf1c6UIL4tj6BcA10E9Dk0X2hcWojrRW3H9hOzB7Z2S1DURCM4pYEZ8SEYTFh9ggCXdt
	 eaJD+MifR4pXL5B/DUSY81b8UWupMmReZ9AfWKfmS1+hX/9htGG7ShAyyjf52VY8z6DXk
	 zEHpQ1BpSdydi/Rx/X5HEfhYPVGMWoHu1P0t+n7iEYTVat8oZl9J0XPcnhgOi6wl0bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvnJFVYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3509F606A31A;
	Wed, 28 Oct 2026 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvnJFVYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837E51F01825;
	Wed, 28 Oct 2026 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210139;
	bh=HUINRV/msbJphN0gyVjzbiAncDWUK4P+jGagPQojNSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvnJFVYhBFd55jd4CHkHRrbxq9YsvrE9o5MB8D7LUnuuGwnJZplEatbbebSYJpe1L
	 u3TW1me8IzY0nlrZqtMEJR/LX+3HiUeD8vLEdGvDFv2nz1eG90a3xRXnxGkOGjwXQa
	 lHP5OXuH2SJTcIGnRDCHLPuUIiYZzvbG0Ucn7Ebg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 088/168] net/sched: cls_flower: validate mask pointer after nla_next()
Date: Wed, 28 Oct 2026 18:00:24 +0100
Message-ID: <20261028165945.171976961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1589,6 +1589,11 @@ static int fl_set_enc_opt(struct nlattr
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



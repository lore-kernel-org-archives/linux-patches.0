Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209464;
	b=Ff0ZSqC1vr6kLNg05xwUv07GZlFdvXQYfW6HhR1ZRiLQ1F8GJO6mEk7l18gs4G+DDcVW
	 3wlK+HdLsOLtzO5irz/LFAsun7yCIwjsdEwpwn9C3YFWv+JJ7E1fASA1npJFC7mk2Fwdh
	 j6SN01dkKdI3B5O2gGo01hEhv34VlL7u08yqFSu6SgZb5mXJVa5TlDx/IlFf7XbQvd2hO
	 7VmlzkWd3ptzM8Re9MM7sy056twUBtGMKHfAzLPBonpuZzmQ2JjCljtcd/pXCmSKlaiqB
	 CW3RE3VT+fowIXBF3kPa6DB+JfJdWkp60B2li2eWoyzWm5XCmQpv2IA5jql/dlZrp9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kC88VgLItR4wut/PNn+z6ig0q7anDmqnQy9Y7YXgVSM=;
	b=d8Da7Nc27Z1I2Q986Z0DxcRAEgi+yyvmRb3TSoM055kMeOOzfVR333GuLLp4Dg2Qulpd
	 atcBjEs8yIpOQ1+U3Uk/6Z5iUWqENKq4+WjLvUUNPW/ergt/1+CAFpUB0g6HvulWH4UkJ
	 MpSrPk9Hs9rLdzg3lNqsEWvrseYyxOoEzEffKkdtf6XgAsA45zyY7xaDc/9gYUlnkotkO
	 ZNRAWhcvVUVDsEa2ku/01Gs36YwHU7gymnNRmYeRp19VIVddmh6hDPQkIa8fTV8jQrQ5Y
	 R8joVETuMrtlS0rmM3Z254/UTFkzPFQbYwBq+Cl7UzFqzjWZK56uLya4jwjisDAxb1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5O9jq8j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E7D606A31C;
	Wed, 28 Oct 2026 17:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s5O9jq8j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5F61F01825;
	Wed, 28 Oct 2026 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209463;
	bh=kC88VgLItR4wut/PNn+z6ig0q7anDmqnQy9Y7YXgVSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5O9jq8jwV7x7BErh2xeLHtLiq6PfnYIbhrFTyiHCJBL8AakDenhsvRz4oPV9i4hr
	 J0z29ObHiqUjvEOniSNNO6M5snQOASdf0Jn8op8ahXWAX+5wqHRyC+lQcUXrtYmbXY
	 3/wlpVyaoZrn6XMEqBhCeXUyONdQY3aQBaXKhxaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 481/516] net/sched: cls_flower: validate mask pointer after nla_next()
Date: Wed, 28 Oct 2026 18:00:33 +0100
Message-ID: <20261028170014.874516906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1406,6 +1406,11 @@ static int fl_set_enc_opt(struct nlattr
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



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774970;
	b=nkXxcACvSiXXDmfnS87uMtkBffKB+f6gT+cNgkjUQJWReZrn1Px2W/wmjoTx75joDcG6
	 L3knifPjP+QnB8Kew7PFDC2SW/rxNKDZ9FGX2obfG2wcGHj+wdflSRVOpsZ9qakltJmLG
	 jOMHc56N67B1E5QeQ8+WU23m77rgWcAdo5SUxPpw24+Cmk6nlES8p0bvAXsV/40L9zo/U
	 QnbcQYILRU3HqPbmyitVox5H+lRWc4UGPnCz+lnBQCYE72bttq301H5yBkSJ4ZXnj2I/b
	 I0QYnN0SAD5S2pk1TeCudpbDeeHQhROFnhSYAHu3spUrUm94sjsRiH0aB2FOJ9dQ2eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZgOpZ5ifs5YSf4+WoL5DaKFTQS9aMZOy3OnYi+1VbmM=;
	b=cIE1GBZ/B0dLswywZzbBDcANYDobxY7WUgKjuOEw8uZl6awzZ1zGJqQNJjdMAZP0xlxc
	 fOmBS4Rp4/lDcJ+HcG0xQECTW4l+8TGzNuDbvVSMJIlvi77tzqwUWn6pxLIuOmf2F8Zuw
	 KBQ7+bLhskKYGP6jkgti6guxlW+nH26dVvU0TMxF8XD2qbGzl69pU06hisK8MZGYfUb6m
	 3iMWNN2Kiew8N6rTMZmreIcZW27B34hzvQjEJKXD82CApn46Kjq4ADkZkal3y6B5aGfoj
	 fkzZhZKLZ/b5JopCi2/3EWzxQdJfCkAxydqQs0rJ9JhvDmHbpUW/vvQ7LI8USwEdazw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSLknTBq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16245606A31A;
	Fri, 23 Oct 2026 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xSLknTBq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558F81F01825;
	Fri, 23 Oct 2026 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774969;
	bh=ZgOpZ5ifs5YSf4+WoL5DaKFTQS9aMZOy3OnYi+1VbmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSLknTBqK0Qk8NarI6WUruBfN4NjM/PaYpLrAbjqAmkJybGj5fDfqiqeQjcdrEqQu
	 7qs5B2JJnA2tWeESF7f/325o4CERzwE2cfbKSqigIKRJiB7JiJ/2HYwxZQYvwieAsS
	 Uau9CLAm3a32lu9iMrFcwJ7Hc/T2FlVxbKNLHhug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 219/242] net/sched: cls_flower: validate mask pointer after nla_next()
Date: Fri, 23 Oct 2026 18:41:01 +0200
Message-ID: <20261023163718.995980366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 net/sched/cls_flower.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 0e275b58151c..1cefea571efd 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1703,6 +1703,11 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
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
-- 
2.56.0




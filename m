Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217063;
	b=fLQ4S1fkdQB44qXVBrecQAT8ltTYu0xeoOVxsDDNNGpWqg6r5O8+gvK8dAaGMO+hZFyD
	 3dQUnms6mnV7VLRA1bVWKAiBLPhdbqpvibwJojYWTJk5eLwdUlWVJNKuRIEd7lVtB4NMi
	 gKAy+cbU7y/XePislD/wnw7Nuj21tufyccoV3375arVUkL+vaEII6REzkh/E0D15uuWWu
	 Q1ZMEA+ZpXB+nMkwVOkx3nkNyN3ThrIZ9yILm6ilH2btQkmuBOX6zWApK8hZVSNXjlOmC
	 ZQ6BySUaJCW6jevdepYoKyJUiMlji/Pv/ui5QfYZ0AypZSxNW9U6+nTQX2lxu2di0wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M7Af0MUxXv5vC39OTIEpRVYik49OQB/LKpz75sNuGxk=;
	b=mnGXcMHpF8Ryc9MB6BwAlSGjGPKazUg2otIR78We7dQFuMQrt5ID4Si69WVO/pSrIKxD
	 K3Av2WNQ5Q3fw5lyM9YcLU4b3I+UvfoJFHJQt+YWN2LfyoMjLj4I0xNqcwoXYWFWYZx46
	 3NJvz4GWuheRba09GOYEkKlWx6iKQLZn7XbAQNfT+sKkbsqR4KqPjKMRhted6H2dbOYVo
	 2NpLInv+dcN2eYiQcYUgC3FG1SQHuoURmznyGLpJvItJavsSr3eLBPZNwIB2vNm+Y1/d4
	 aZEjLTXShVGF1ABuplQ6SkGyW3CvxhsBeyDvLadZ+LtvDLIu/BMlMl0Ga1nnk14I5Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvq77mb+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F92D606A31E;
	Wed, 28 Oct 2026 19:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yvq77mb+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F091F01825;
	Wed, 28 Oct 2026 19:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217062;
	bh=M7Af0MUxXv5vC39OTIEpRVYik49OQB/LKpz75sNuGxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvq77mb+ZV0YLfbPrbNV+AdAOLJqkYD9d/fLYy1KYTjnoj5hBUMTd5+YZQIjrWt8u
	 OnZfxSkXBsoJmznVSUnKsn+wWMYOuR+gRkvJOUGZEJAJiHgQYE1IBOE3gHoq9ttFYB
	 q6h1QyY/MaA7/uuEgmoKYSlmy/kZvaN44Pm1MyDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 1774/1887] net/sched: cls_flower: validate mask pointer after nla_next()
Date: Wed, 28 Oct 2026 18:04:30 +0100
Message-ID: <20261028170539.821163688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1548,6 +1548,11 @@ static int fl_set_enc_opt(struct nlattr
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



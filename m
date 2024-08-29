Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B30215CD62;
	Thu, 29 Aug 2024 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724951355; cv=none; b=bw6YJSdChGkLHTa46HGqMjJUvjC4TVxlhgzobyGZJe88hbNwhWuFLzdsFSS9Cl3jpxOHyKPwDpnTUF7I2D/wVjLeQctZ2GL6PeleLZO+Ni+MsZhBI8mqJ7al7baNqZXz2gN7l3a0xvrdrTpHNqFPCwGl8EQmViq6yjEnR6RRZls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724951355; c=relaxed/simple;
	bh=RUZQMBxtwYGCRab1iVuO9AG0vpRhJj4TIC4zuP1ZoHE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=i6TbmmEjthgtvZ6tPCDInIDKBPKyCaaEs81fE9M5sVDMloVhSmpENs1xFjyJOW/cEZZEC8ms8knOUBE1+vOLCgRZkQ7Ci2vDdfiJuqahS/qhYzhcVXdAh62QCQWbDVpY57TvwHTTJFZ246rjMczYkzaoMqO4qQlWW/NFqL88IzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOw8++I2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOw8++I2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191DAC4CEC1;
	Thu, 29 Aug 2024 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724951354;
	bh=RUZQMBxtwYGCRab1iVuO9AG0vpRhJj4TIC4zuP1ZoHE=;
	h=From:Date:Subject:To:Cc:From;
	b=mOw8++I20mwTRvietxCWZT+4ltQkFBVg6ZwWr72r1zDev95s72evcXFAmoNJhTB89
	 kTf88Ej6PHzuu7CGJ2vAVOI0TBxB4WOyTJ5aZk4+CGpjJ9LwnMQFbcRw/tObMlj/0B
	 zzdY9lC4GqAwFmwSsPp6sRSb3TXkVV/g8FOUNjD7yNQVaWJWsGy+7kb9L5hqU8HOtM
	 QN5WNzeyBKAAwgdoCbrUYuoJD8yBLvJg7zpTXwM3t79OZzB6FJjOalyMAImRlNH2r/
	 WW/47jYnvM8YGO5etFZ3MBBI5TeVDbA7YyQ/XxmCAD2VPP9s9lNdONLyq0ikOkO6r4
	 88PEPrHYafbZg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 29 Aug 2024 10:09:07 -0700
Subject: [PATCH] xfrm: policy: Restore dir assignment in
 xfrm_hash_rebuild()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-v1-1-a200865497b1@kernel.org>
X-B4-Tracking: v=1; b=H4sIADKr0GYC/x2NQQqDQAwAvyI5N6Bh22q/UkS2bnQDupZEiyD+v
 YvHmcPMAcYqbPAqDlD+icmSMlS3Avro08goITNQSa6sqcF90BmVbV2UMYiiN5MxXb6L3mKn/Nl
 kCvh0Te+JHu5eV5B7X+VB9uv1bs/zD2DBehZ7AAAA
To: Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1623; i=nathan@kernel.org;
 h=from:subject:message-id; bh=RUZQMBxtwYGCRab1iVuO9AG0vpRhJj4TIC4zuP1ZoHE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkXVlsejfFJXu+2zLJPYc7G+RPn93yvK7x3yHfNTrfTN
 Sqiczbu6ChlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQATeeXOyHAwsO7mLS+xZ4lC
 N5YqPQox85Z5cV0s4spm49Ovow2jauIYGW6ucP773bsrdkf+W3vfTxtfHfn46p+t1dZz9hu2r+t
 el8cKAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR):

  net/xfrm/xfrm_policy.c:1286:8: error: variable 'dir' is uninitialized when used here [-Werror,-Wuninitialized]
   1286 |                 if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
        |                      ^~~
  net/xfrm/xfrm_policy.c:1257:9: note: initialize the variable 'dir' to silence this warning
   1257 |         int dir;
        |                ^
        |                 = 0
  1 error generated.

A recent refactoring removed the assignment of dir because
xfrm_policy_is_dead_or_sk() has a dir assignment in it. However, dir is
used elsewhere in xfrm_hash_rebuild(), so restore the assignment to fix
the warning and ensure dir is initialized throughout the function.

Fixes: 08c2182cf0b4 ("xfrm: policy: use recently added helper in more places")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 net/xfrm/xfrm_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 6336baa8a93c..02eb4bd0fde6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1283,6 +1283,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 		if (xfrm_policy_is_dead_or_sk(policy))
 			continue;
 
+		dir = xfrm_policy_id2dir(policy->index);
 		if ((dir & XFRM_POLICY_MASK) == XFRM_POLICY_OUT) {
 			if (policy->family == AF_INET) {
 				dbits = rbits4;

---
base-commit: 17163f23678c7599e40758d7b96f68e3f3f2ea15
change-id: 20240829-xfrm-restore-dir-assign-xfrm_hash_rebuild-749ca2264581

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>


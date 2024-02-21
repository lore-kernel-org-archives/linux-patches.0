Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7B14A1D;
	Wed, 21 Feb 2024 21:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708551987; cv=none; b=Hw1x8YtKJrgkkls6xRuLVVUc9fjmK0FB9R7/g+MP4MIjt6p/zoTtLLtI+QxME+LVdjtqSgUeHEcNXXKRqjm40HpCGaJJ8Di+iZnXPYt5FZ5QylTcOp9UVekuAvwpcMF+2Hx0OhEFeds9u0GvDA/8f6JOPIu11z6sU/LW/JcVff0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708551987; c=relaxed/simple;
	bh=leo9okhKBaTR0GDpOuoa10LU3SThMLpEnLrULNmIs+o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KPNfmdfYJyyW5jE6A8Egath8ryodQrHlRPrEw567k7qAmrkrF1nAj1Zql3xMvDJ2LgLXriqHBqpgulsn2EnTFVBodR38w6Ua+tsiY6Lre9h4rG0Jo3Zja/coboybD5h+eNEbqt0kMljk6s7NfPJYJK34iQhSg3nAHxuC7++1Qos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BrML/Wl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BrML/Wl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A29C433F1;
	Wed, 21 Feb 2024 21:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708551986;
	bh=leo9okhKBaTR0GDpOuoa10LU3SThMLpEnLrULNmIs+o=;
	h=From:Date:Subject:To:Cc:From;
	b=BrML/Wl7vTXK6gRt5ngkvHhM8Zu5In5gYTawYmzzns0JtFYCQoQm6prGPimEGlTp6
	 AD6gVp0I4wt+lNjotFMN+N0pD95H9/hSCNDFG2/eTD3gM67CD5Yeio3JO5fMPP4knz
	 OF5bBC8ZIIFjqa4WcanSlNx7zicYxhQPfrYdmhb8veg+Hpa7ZjmC3Mhcj8OO8q1ufi
	 UwnambY1azv1Xb28D9wsIlEfALgl1GwY/wyuISdHUximCv42eHAqyHB5wIgQC9zZLn
	 lWaz5ltfSle+i0QDLvBDBZR0BmESIl4zC9rHBzkV9QKgjBzv+S90inJBkIhv4Q/dQD
	 zVIXMqrsTh3gw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 21 Feb 2024 14:46:21 -0700
Subject: [PATCH net] xfrm: Avoid clang fortify warning in
 copy_to_user_tmpl()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240221-xfrm-avoid-clang-fortify-warning-copy_to_user_tmpl-v1-1-254a788ab8ba@kernel.org>
X-B4-Tracking: v=1; b=H4sIACxv1mUC/x3NQQqDMBCF4avIrDswia56lVKCxkk7oElIUquId
 +/Q5QeP/51QuQhXuHcnFN6kSooKc+vAv8f4YpRZDZbsQNYa3ENZcdySzOgXHWBIpUk48DuWKGq
 f8uFach8tu7bmBQfyk6GJqOceNJwLB9n/pw+I3OB5XT/6XTGmiQAAAA==
To: steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
 davem@davemloft.net
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
 morbo@google.com, justinstitt@google.com, keescook@chromium.org, 
 netdev@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2264; i=nathan@kernel.org;
 h=from:subject:message-id; bh=leo9okhKBaTR0GDpOuoa10LU3SThMLpEnLrULNmIs+o=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKnX8g39NsbKLClpzlhxvdGKaVqfjcSDSU/O5udu28Sy3
 +oNa/fVjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRJfcZGc69fpYy54us44cZ
 RwIvvtD8rMKdd0gsdIX36sKM1GKTbHOGP3y3v3od2+m5LV2Za83SVq6L7owTnj/rNHq9MZ7/8Vm
 TOnYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a couple recent changes in LLVM, there is a warning (or error with
CONFIG_WERROR=y or W=e) from the compile time fortify source routines,
specifically the memset() in copy_to_user_tmpl().

  In file included from net/xfrm/xfrm_user.c:14:
  ...
  include/linux/fortify-string.h:438:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
    438 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  1 error generated.

While ->xfrm_nr has been validated against XFRM_MAX_DEPTH when its value
is first assigned in copy_templates() by calling validate_tmpl() first
(so there should not be any issue in practice), LLVM/clang cannot really
deduce that across the boundaries of these functions. Without that
knowledge, it cannot assume that the loop stops before i is greater than
XFRM_MAX_DEPTH, which would indeed result a stack buffer overflow in the
memset().

To make the bounds of ->xfrm_nr clear to the compiler and add additional
defense in case copy_to_user_tmpl() is ever used in a path where
->xfrm_nr has not been properly validated against XFRM_MAX_DEPTH first,
add an explicit bound check and early return, which clears up the
warning.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1985
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 net/xfrm/xfrm_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index f037be190bae..912c1189ba41 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2017,6 +2017,9 @@ static int copy_to_user_tmpl(struct xfrm_policy *xp, struct sk_buff *skb)
 	if (xp->xfrm_nr == 0)
 		return 0;
 
+	if (xp->xfrm_nr > XFRM_MAX_DEPTH)
+		return -ENOBUFS;
+
 	for (i = 0; i < xp->xfrm_nr; i++) {
 		struct xfrm_user_tmpl *up = &vec[i];
 		struct xfrm_tmpl *kp = &xp->xfrm_vec[i];

---
base-commit: 14dec56fdd4c70a0ebe40077368e367421ea6fef
change-id: 20240221-xfrm-avoid-clang-fortify-warning-copy_to_user_tmpl-40cb10b003e3

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>


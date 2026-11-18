Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038312;
	b=tUF5RzD7yjExP6bb/JtLJWtkZ9307uuaOAtxU4SfUfA9gnO06lZPaCV8FosrGAVqP/OE
	 ItgHydIqa3xWz3dmedGZ59tw7ufXEZYlGAovFkeW5IpVlWS0SZ5Yp8ugdBNyrvEAIDHmk
	 EyFwX5cljzDfpQsWNeuyC52FQ6vYZNZUVlssKzWsJNkyJ8TK/dFxGOPFTRq4100Y36d2u
	 zNxVy02ydZfrc/4e6ycP8jnc7x6djddqGhdunhfsRA2NLZOBPhep3n8IZgVKpfoAKrHnC
	 xYl9IIme/g5ymMtEnpdiaeJKyGcsvY0TxvgwBkCFWfIw8sPSYqmIPTpc2nAc9lU7JiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=keZ189r30EqB2PBnryMRe+EFUDk6sY7MMzDMjI3Cbg0=;
	b=FPv7bksK40TW7FJ0GRAjkrnI3w69v8whGoeys9838qW4iTlMYwHe3+L+y2CMK1HG7Aa8
	 jjuhBuDDGuNzuo2oQuQepvYTPh/Q5tdJwytMD/hJ4fp8i5FsEMD3/7GHf12+cy5A0B2ZS
	 yxL8bW2OEjkN76D1Ja2psDyTR56rUTAFMVliR+Dc8aAAGLw18cylTi0riLLDSfr4Go+19
	 2mK/eqmHIC9YFIVwiw4d688W7VUku0dHK7SOqOscdj+AA8h6CBhFAitM/FNpfUewyHv3u
	 algmgKqvLoDI1RUHE//t2XKVazwVYU+DbocUN6chswHOyre7RgbMmvlrkI/uyGk4cbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojAaxnM2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9638606A32A;
	Wed, 18 Nov 2026 21:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojAaxnM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F991F000C4;
	Wed, 18 Nov 2026 21:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038312;
	bh=keZ189r30EqB2PBnryMRe+EFUDk6sY7MMzDMjI3Cbg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojAaxnM2AijLWq7hrWv8twhr1m7FKwdnEceGExWj6huiaP5a40yyicXltSRUw2Gqd
	 mV+GGW8Z4U8tussIr185QWNO8Xl4vXseAdnaRVau190srLZ3G08Smk2FI2QsG9sgn2
	 cE2HSjTvi9Og8asWQcVrJJgR5nHbOTeOn2jP+LjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1693/3318] init/version.c: Replace strlcpy with strscpy
Date: Wed, 18 Nov 2026 15:38:35 +0100
Message-ID: <20261118150412.620627898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

From: Azeem Shaikh <azeemshaikh38@gmail.com>

[ Upstream commit 8ebab155ea18a6d6c47b17287a0ab4633334f6eb ]

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().

Direct replacement is safe here since return value of -errno
is used to check for truncation instead of sizeof(dest).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230830160806.3821893-1-azeemshaikh38@gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: b6bec5b63a5b ("init: fix early boot crash with bare hostname parameter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/version.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/init/version.c b/init/version.c
index f117921811b45..94c96f6fbfe6a 100644
--- a/init/version.c
+++ b/init/version.c
@@ -21,10 +21,10 @@ static int __init early_hostname(char *arg)
 {
 	size_t bufsize = sizeof(init_uts_ns.name.nodename);
 	size_t maxlen  = bufsize - 1;
-	size_t arglen;
+	ssize_t arglen;
 
-	arglen = strlcpy(init_uts_ns.name.nodename, arg, bufsize);
-	if (arglen > maxlen) {
+	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
+	if (arglen < 0) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
 			maxlen);
 	}
-- 
2.53.0




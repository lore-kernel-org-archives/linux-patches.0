Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831545;
	b=PjSnSeAiu/IhA9V3DIJFxhN2AztmIaMg9StzdkcyI3e6XvG3jJ9y0jXYunQISNIyn/9i
	 s0qQWuGuMXH4IdGBidZVIh1XAHs/PU9+BEEHFx5SfgSZaV7IivOA91DKL4q4Rb62ixEsu
	 grQ98DKofbbUyqk8VX8tbNYjV16fTXAabrxhTXUCxpsfruAtGjwk08KQPys6chmMHh2/z
	 F7kG+s02QRNfU2BUjXaZxFpFxciKOOohu7j3AfG7F8ZNZXflbkLqen5wp6w/keq6zH+1a
	 UBRoZXtCOraCq1zdfjchgKZE2gMG2b5/JcVw7zu9Gu19TQZfKBE0IlG9o8erwCDZAvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1e/8JQ5jOxYCNdG7n8EqlZjU1yIjgAFtT9HDlZYCjkA=;
	b=PBn7AuajejuZ/Tl5+t4jf+YkO8h1v9DK1tiGJjwmvQMSBkNA/jH2Qw4Iei6sse3sotqe
	 E4kUsAWr4sEZvxLRWUctLlvUpv9FN4jGzNXryNTsJMgnEo3uU+9JCLR+x5cfoCoAe2qCn
	 ARdxgqObMtlOtlGC+8soxz/SfCU11n9fgA8pdmnWh0IF/t+VBNODoJ8ll9ZYyKEwOcR2z
	 yXxWnXF46tH/v0VkGPJUcdCoa3MTSCkLb+KHsQ8mxbIpQ7bYNW9op2QM42XQoOKw8gsHM
	 yY3/3NgWvrq9Gsg/0dd5QGfUQgfDk5UO0uplFOmQ29e0eT/4XdOP/xs1kbtM2S9xnMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yazZ4Tkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FDE606E821;
	Wed,  4 Nov 2026 22:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yazZ4Tkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CD01F000C1;
	Wed,  4 Nov 2026 22:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831544;
	bh=1e/8JQ5jOxYCNdG7n8EqlZjU1yIjgAFtT9HDlZYCjkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yazZ4TkgBVsuesy9JSRH0OrlHgkJ2mZUx0Kct0dnGSiTGQyQ3/nAe68KswRcp9S63
	 IpsslARaByXVSrXwoPrhYFS3C0aJy+zy6lUyBF9JJBk3TEITAI+HLz9r2glGocnE12
	 qYRdX8HUbGCYiAPyHK2H9hb1O8IVrWCoBMvrIYxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0770/1005] ovl: reserve space for the casefolded name terminator
Date: Wed,  4 Nov 2026 16:08:23 -0500
Message-ID: <20261104211104.959317819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

commit a65eb1808177a4381718abe563dddebf840598f9 upstream.

ovl_casefold() allocates NAME_MAX bytes and passes that capacity to
utf8_casefold(), which also needs room for a terminating NUL. A valid
name whose folded form is exactly NAME_MAX bytes therefore fails to
fold, and ovl_fill_merge() falls back to comparing the original bytes.

For example, when two casefolded layers contain directories named with
255 uppercase and lowercase ASCII letters respectively, readdir lists
both names even though lookup treats them as the same directory. The
same names merge correctly at 254 bytes.

Reserve one additional byte in both the allocation and the folding
capacity so that NAME_MAX-byte folded names use the canonical merge key.

Fixes: ee95c5fc86dd ("ovl: Create ovl_casefold() to support casefolded strncmp()")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/readdir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -79,13 +79,13 @@ static int ovl_casefold(struct ovl_readd
 	if (!IS_ENABLED(CONFIG_UNICODE) || !rdd->map || is_dot_dotdot(str, len))
 		return 0;
 
-	cf_name = kmalloc(NAME_MAX, GFP_KERNEL);
+	cf_name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!cf_name) {
 		rdd->err = -ENOMEM;
 		return -ENOMEM;
 	}
 
-	cf_len = utf8_casefold(rdd->map, &qstr, cf_name, NAME_MAX);
+	cf_len = utf8_casefold(rdd->map, &qstr, cf_name, NAME_MAX + 1);
 	if (cf_len > 0)
 		*dst = cf_name;
 	else



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620143;
	b=qfh/NDHDCpW5FWlKP+F9VHD4cd8pLR7ILSqx9Kt0qKXnibVDMYDcbjhldhK472GE9Zss
	 CByFn4DZXoq6ADlX2Yl6uW+5n0oZO9KoZfImsJX8dx1MHb0kVUVLhiDdIlqUdk2ULv5RV
	 2IUjMp8bhu/EfqOU+h1sf8AcFGd4nI/iMrqsfYKe0m122OXsPUMbH2KRdnC5kYkoqxDpU
	 8/0ZtuCfkiKEm/SyoDrunh9a341s017qFksxq2qbNc+s5Z04pX7uxQuVde4cJyI4T0IP2
	 mUAx1sDqTmFot/zM5/MMmTUpaVfSwWJJi4YYH2V9Z8bKaSMr6cVTvLnxgsWJWTDieiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ToeZaJKhK9Y3sMKLAvIIbwqQfUrvGDLe6nj1jtO+98I=;
	b=Os/r2IG9wjPlSbU7uGQkV/TyzymOswi1JinTSjqzZE6WZ0vb75emmpRXYGHEPusM0PRO
	 hNpkXkJ1wfu5lzam2v8iRiXs6hwa12zoOrD9w1PQFrfgaZDrVVs5iXqSZ/kA4Pq/5cC+D
	 lJgS/P9Xqj9puTy0c92H8GxV2OpynuXSOgYZC/EVnYDqmOerRdMfUZ8rScMQhInQZVbCF
	 SOeGm64veQaAO02Leb0/qYXqjg6tYY8mIzV1E09H9vD2uD7iLFWsRPxPKPd/Yl4MjZqyt
	 Ad8/Y3rKNiQv0lS1hNTKc0a/FrTj9bVgDbpjP8Id81hiMrnp4ADycj2JrsvyXheaFLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Opag4Pm3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E63606A31E;
	Wed, 25 Nov 2026 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Opag4Pm3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586B31F000C4;
	Wed, 25 Nov 2026 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620142;
	bh=ToeZaJKhK9Y3sMKLAvIIbwqQfUrvGDLe6nj1jtO+98I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Opag4Pm3EXd3N67hMbUO8ooGovEpyb6jd7GYcrXmfbfYqzF0rfpiEUxsr20GOUx8g
	 Rjt8ji4jQ6bc8Zw+hZvUB4i8VerxGry+Ppmb8vXbzUnPrfgu+VsNIU1sYIQxdWLHBo
	 A8NV01V7KMKEWXZY1RLKxWYbA7YQqjZeThoBSiYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 0822/1005] ovl: do not always clear absolute_redirect
Date: Wed, 25 Nov 2026 15:36:00 +0100
Message-ID: <20261125143840.981306315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giuseppe Scrivano <giuseppe@scrivano.org>

commit 477449a7a5fd1b2fe973fe2978b0c921115a65f3 upstream.

ovl_check_redirect() clears d->absolute_redirect before it checks that
the path element has a redirect xattr.  An element without one, such as
an intermediate directory in a lower layer, then clears the flag set by
the absolute redirect of a metacopy file found in a higher layer.  The
lookup of the data in the data-only layers is not deferred any more and
the lookup fails with -EIO:

  # l2/f: metacopy, redirect "/dir/file"; l1/dir/ exists, no "file"
  mount -t overlay none -o metacopy=on,redirect_dir=on,\
        lowerdir+=l2,lowerdir+=l1,datadir+=data m
  cat m/f   # Input/output error

Set d->absolute_redirect only when a redirect xattr was read.

Fixes: 5436ab0a864e ("ovl: implement lookup in data-only layers")
Closes: https://sashiko.dev/#/bug/linux-2cc24e0b-fbdc-4cf1-aded-cfd19c2918ee
Cc: stable@vger.kernel.org
Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -39,13 +39,12 @@ static int ovl_check_redirect(const stru
 	char *buf;
 	struct ovl_fs *ofs = OVL_FS(d->sb);
 
-	d->absolute_redirect = false;
 	buf = ovl_get_redirect_xattr(ofs, path, prelen + strlen(post));
 	if (IS_ERR_OR_NULL(buf))
 		return PTR_ERR(buf);
 
-	if (buf[0] == '/') {
-		d->absolute_redirect = true;
+	d->absolute_redirect = buf[0] == '/';
+	if (d->absolute_redirect) {
 		/*
 		 * One of the ancestor path elements in an absolute path
 		 * lookup in ovl_lookup_layer() could have been opaque and



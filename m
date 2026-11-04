Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828875;
	b=l2poFIFEXEmhzC2wDYZ3iuN++BWxiJ4m+fcdvaJUBoW/gTpCouOQzkRbHOzQ1SMRqFlx
	 GCiLdUdTmWi6Rsx3tEpyWBPDvx+KKFBHQJZpXjfN07qY8POr4vusZPTi6loguZAz4fghJ
	 B8K5LNlMhdmTrm714OtDBMT+eP7rAcYHBE0EWHFIUivyFNpGK7cUdk33T1j8xr5Q+TEDm
	 MWlyBrUgZC0iT0ym8InjVyY0/GjSA5Prcau0jYd5AosCF+JuAqCXK0IgfgHCfqKB1U5rS
	 2+3ypA2FFLXOf9UuapTdASwUraqFTAw0IP1GYkpeYPy0JUy9bw4IuEqFEZNnIggsVYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jbys545lSmEUMuemql4YLGs2oslxdF/ohm3tQQVm4lg=;
	b=e4vG0y9Tg8FHBp+rHgMwIgrrTBoLsGq2JorgOUqEqRaGpdGbB390eaKMf3nGeh+W/9z5
	 3qMj4g92OfK70/WjxnkjJBi+B5gTXjIdOZMd8Tm1DeZ9gChu/HkxL5cp7oR48hsz79evN
	 XP4zcHquBevoWhx2c+XF+La/YpOJI1ErCggNnxCsXk8ptJ7LypLz/SVaDF5JPGUSNhmpP
	 jeD7b91FEhS1aYhHmKgpmROZHQiH6hzJgl8AoVG5DSn0HdRNQxyDf7WXwJ5H6CWStXZhE
	 7pH+XJZaTAoApk3zOTHKsmDbWf+Ypg+LicyulW49kGqO03TZMZQPUWLrBRtuNQidCrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DGlv/wHh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2586070F3C;
	Wed,  4 Nov 2026 21:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGlv/wHh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1241F00A02;
	Wed,  4 Nov 2026 21:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828875;
	bh=Jbys545lSmEUMuemql4YLGs2oslxdF/ohm3tQQVm4lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGlv/wHhZ89YmNOJRfPKhc0y9xUF9yVlcC4Wiku36IzDAD4IVTn5qIbAYknnpBvbI
	 pqxn/+GpbrtuGLpXIZPPQvMjrCK67XURSdkDXoEBNjOU5ucbEb9+Y+kq2Ar+80bKDh
	 aRpZ0nEo4UR4OtnIMwrZ8CcA1SH5GpPsrWrg+x3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 295/547] ovl: reserve space for the casefolded name terminator
Date: Wed,  4 Nov 2026 16:07:59 -0500
Message-ID: <20261104211046.582015217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -81,13 +81,13 @@ static int ovl_casefold(struct ovl_readd
 	    name_is_dot_dotdot(str, len))
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



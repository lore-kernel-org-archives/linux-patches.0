Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5527E2609E3;
	Tue, 28 Apr 2026 19:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777404108; cv=none; b=hXJh1mL9FP5abv1mxD2+KbEd7SrFFEfD8q7/XcitIaNfrenhekMIt7CxYdjtoUnX41WHU+oA3ZJv9a5ROSKrjPLTGJyO0zkaeLoajb+O9RNfyJx1IP6dINv8HnlwgIWFnzNeeYF3/MHMypXiMYszaQGYoBo1v3qCDmJcQRpy9mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777404108; c=relaxed/simple;
	bh=LYZwA0s9iRaZA7jjYIJdac6Iy4NFXy00xkbDair5cuk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Rxc8XkNgpHt7X8gxgqx49Gqy9B7ApL7cNWR6aHOKCRxKuLCxGTuai4tO0GopGEdCEHKBW6wHdJT4HC6Xo3q4v//2bR1n/PA2I0gjVMR7LRikbFqHGfF2uXRaQ1AQNwhWPBdc5PHxMhiPgveGyyyO+fJc/SK2esXtgs6zjdZyfBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTDPYQce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTDPYQce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E288C2BCAF;
	Tue, 28 Apr 2026 19:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777404108;
	bh=LYZwA0s9iRaZA7jjYIJdac6Iy4NFXy00xkbDair5cuk=;
	h=From:Date:Subject:To:Cc:From;
	b=WTDPYQceCLvbyqAaEiBJeW7PZiPh1kDlYFCh2xdtjX4rWDw5XPT5cl+z4hC4eJsyp
	 MLYFV3839ZGzaAXkWwYLYdZT6hhrJilWL5C8bjXPeUbhETXRbN+JDMOKm3HIExhjJn
	 8ExubPYFrvhIV6Izkmks3WeAQKzEIBxKBqsa+6Msqp7+Gn41hLhcHKibzOr9zmYtYD
	 ZoGAIjHeBHOxe+RhYG5LsNskdnwqWwmrIMSU3Kv6fM3bDsZO9LfPxfLz+F8a/7uYkS
	 /MZ9XTj3C34fOMkuTi57GL7MySMgJMNRFze1x6rXp2v5P2guvAd0M+4/iQ4F50hKMK
	 p8rPA7KZPMB9g==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 28 Apr 2026 15:21:38 -0400
Subject: [PATCH] ntfs: Use return instead of goto in
 ntfs_mapping_pairs_decompress()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-ntfs-fix-sometimes-uninit-rl-v1-1-31e0c8025430@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM0QqCQBBG4VeRuW7AVpHqVaILm/6tiRxjZ41Af
 Pc2vfzgcGZyJIXTqZop4aOuoxXsdxXJo7c7WG/FFOrQ1W04sOXoHPXLPg7IOsB5MjXNnF4sEY1
 0/VGaFlQW74SSrvvzZbNP1yck/5+0LD9m4raagAAAAA==
X-Change-ID: 20260428-ntfs-fix-sometimes-uninit-rl-cfe3c6a9c34e
To: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>, linux-fsdevel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1518; i=nathan@kernel.org;
 h=from:subject:message-id; bh=LYZwA0s9iRaZA7jjYIJdac6Iy4NFXy00xkbDair5cuk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJkfOU7tnsFe3JBT6XJ9sv9euRszny7z7YlJmuN3zDPYZ
 LmHoo1YRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIrH5Ghn/5mnrG13z3nVi9
 +mwf06fgpzauHt1+h1UjZE5oL2DY18LIMCdrosXunrxbfhMCLv0TrP7k7sI2u2zZ5xczz3lfzbU
 0ZAcA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y / W=e):

  fs/ntfs/runlist.c:755:6: error: variable 'rl' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
    755 |         if (overflows_type(lowest_vcn, vcn)) {
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...
  fs/ntfs/runlist.c:971:9: note: uninitialized use occurs here
    971 |         kvfree(rl);
        |                ^~
  ...

rl has not been allocated at this point so the 'goto err_out' should
really just be a return of the error pointer -EIO.

Fixes: cad7c6f0a514 ("ntfs: fix VCN overflow in ntfs_mapping_pairs_decompress()")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/ntfs/runlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/runlist.c b/fs/ntfs/runlist.c
index be6ca3d374bb..da21dbeaaf66 100644
--- a/fs/ntfs/runlist.c
+++ b/fs/ntfs/runlist.c
@@ -754,7 +754,7 @@ struct runlist_element *ntfs_mapping_pairs_decompress(const struct ntfs_volume *
 	/* Validate lowest_vcn from on-disk metadata to ensure it is sane. */
 	if (overflows_type(lowest_vcn, vcn)) {
 		ntfs_error(vol->sb, "Invalid lowest_vcn in mapping pairs.");
-		goto err_out;
+		return ERR_PTR(-EIO);
 	}
 	/* Start at vcn = lowest_vcn and lcn 0. */
 	vcn = lowest_vcn;

---
base-commit: d986ba0329dcca102e227995371135c9bbcefb6b
change-id: 20260428-ntfs-fix-sometimes-uninit-rl-cfe3c6a9c34e

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>


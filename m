Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B574A161B74;
	Mon, 29 Jan 2024 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548355; cv=none; b=M5oaEAMqFKZkyoOpbxAO/IO7zTzhyiMF98RHEqANHQ2ErmhIcyw0EJR/5+bwOp54lw/HnmTQmiJRehNMeK379tUkEOchhkwUGsjjjtSOdxNhgoMoo8H63P3VqEzxNj275cCXf9Y3A2cQKaHQNDdggChJnvTcEJshevL42umX6Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548355; c=relaxed/simple;
	bh=YF3p+RZV03HIqk3lG/ivEM6+Xddxc3MirsxEQ8XibX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pP//WkSm1hWRUC5LCTW5s/UEScMSKpRCfQwYGsfO0bSJF5h+BfpLokIVEZwh7hXDGd27Tf23T9WlGm+pxpbbYGMRc9fgN18HYDfonOcw2DAHY8hTvI3eOE1eXySG8Y/4LB3C8zDMD5U4p51e93ThVvbcUBcFO2Eq+QTPPT9yNpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IG836yQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IG836yQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA38C433C7;
	Mon, 29 Jan 2024 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548355;
	bh=YF3p+RZV03HIqk3lG/ivEM6+Xddxc3MirsxEQ8XibX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IG836yQiF8ZWehKBNqMvy1OaCrkMf7lcHhrwahckZYqatBglK9nALRMljwQv517VW
	 eWYL4aLyzRdgu6A0h4r/8mzykvC22yayi8CEvELNLhIyVcplp+9Ii1QcHrzBRjXkdf
	 kklMaWbaKv4pdqeN7KN5WgiuzIgkcuoeKq+0Ylyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Chung-Chiang Cheng <cccheng@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 117/185] btrfs: tree-checker: fix inline ref size in error messages
Date: Mon, 29 Jan 2024 09:05:17 -0800
Message-ID: <20240129170002.354680888@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chung-Chiang Cheng <cccheng@synology.com>

commit f398e70dd69e6ceea71463a5380e6118f219197e upstream.

The error message should accurately reflect the size rather than the
type.

Fixes: f82d1c7ca8ae ("btrfs: tree-checker: Add EXTENT_ITEM and METADATA_ITEM check")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1399,7 +1399,7 @@ static int check_extent_item(struct exte
 		if (unlikely(ptr + btrfs_extent_inline_ref_size(inline_type) > end)) {
 			extent_err(leaf, slot,
 "inline ref item overflows extent item, ptr %lu iref size %u end %lu",
-				   ptr, inline_type, end);
+				   ptr, btrfs_extent_inline_ref_size(inline_type), end);
 			return -EUCLEAN;
 		}
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29053D981;
	Wed, 21 Feb 2024 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525137; cv=none; b=M/NcLuCEb9K/p1IZ5LNwQsj7RI1YhOFsOIG61boru+hSGx6VpKAl1AW2/uge6bSrt1yhiajmU7EPcB4wK7m/y9xyGCy4w14TPcoK33TdRI2+/U+ed8ahJT2cdzSX0/7Uk/+9R4sRAE5VwhtsCxS9EaradWbGrItBgrM3oQR6ot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525137; c=relaxed/simple;
	bh=uYP6ShDtyna7wYsx2SonbMgg1GjrbOk/q2MA0yIxZqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qi5fabGO7UeC1QCazCqRX3jhUzi8ad+YhRFMEzR2/HDo37b5ckh+EADcH26hd2n02aWootqmK1QMOE6GWKwZJy6ZOHzfmVjvqLQbbbHB7v8oGeM/SgMo27O1BtF9pCBxqSQqxmyOe9BX3xtGgH2mtQrKlRE8eOz3c/1zeLhyfsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG3eX3b4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG3eX3b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB86C433C7;
	Wed, 21 Feb 2024 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525136;
	bh=uYP6ShDtyna7wYsx2SonbMgg1GjrbOk/q2MA0yIxZqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WG3eX3b4K81FWV+adZaFDYM7yEonstJQMc/nKPjVH8pUtozL8TaGICy1cpT+CDCzY
	 r7P4hYFsU1+cvO8ItgwUh52ti2BmpkjpwRC//M8UlKM27K0ZleqI73bAlzeF2Fy9vR
	 31HnUPnbFcO/uQQS3Xfzt8fKm7EqQjI4jIsCgiwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Chung-Chiang Cheng <cccheng@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 043/267] btrfs: tree-checker: fix inline ref size in error messages
Date: Wed, 21 Feb 2024 14:06:24 +0100
Message-ID: <20240221125941.368388512@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1165,7 +1165,7 @@ static int check_extent_item(struct exte
 		if (ptr + btrfs_extent_inline_ref_size(inline_type) > end) {
 			extent_err(leaf, slot,
 "inline ref item overflows extent item, ptr %lu iref size %u end %lu",
-				   ptr, inline_type, end);
+				   ptr, btrfs_extent_inline_ref_size(inline_type), end);
 			return -EUCLEAN;
 		}
 



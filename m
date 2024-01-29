Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE3215AAC0;
	Mon, 29 Jan 2024 17:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548179; cv=none; b=NEwTgiks90U+yCBsOI3C1vLzKhjquos1/x/F0GNRPuTxbRW25DRCvNeldOZ4PCf8pqCNtRh/TCCZA2+DA5WlTmiURBIy1wI2nZvFp5RAtGMTzyYbVqQasmiv2WJtft3tdJ7ze6roMsvlKJz5rqthUnp4WsihT0Cd9Wm4jcV028E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548179; c=relaxed/simple;
	bh=bK0la6wljkP+zxkssvTdeyjFoGqEG41A1GCRiSrhBLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0V3414IGwsUQsX3gYQPARS908UOsb46AcIHdhyyADr+OUUvkM/gKh70iCUjDJGcwl8O1UvWoECUFcdEruwW0woy/21O8RQcsoO7Wz1vxCDQRfRvKQ8GCwirC5WhzBRxE7XZRTs1WY5ogFfO3KUUX5js9r1U3NfL5Bvei4RG9zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJ+bkDh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJ+bkDh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92E0C433F1;
	Mon, 29 Jan 2024 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548178;
	bh=bK0la6wljkP+zxkssvTdeyjFoGqEG41A1GCRiSrhBLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ+bkDh/DFCFIFJLe9xpJVPEBxealr+Ol/5LtQHL2369+lLFkJK4kajid+iNMqs7F
	 d4SiK5kfB2ACXzCRwn+GGhFkDPlv1MUFGnp9vO5fuPS682IHR3qmR5a4DBfUI1X7wU
	 JdX84KbQUuJBOMhjZ48lH2Lf45D92PKfxXW5MlMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Chung-Chiang Cheng <cccheng@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.7 225/346] btrfs: tree-checker: fix inline ref size in error messages
Date: Mon, 29 Jan 2024 09:04:16 -0800
Message-ID: <20240129170023.013011431@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1436,7 +1436,7 @@ static int check_extent_item(struct exte
 		if (unlikely(ptr + btrfs_extent_inline_ref_size(inline_type) > end)) {
 			extent_err(leaf, slot,
 "inline ref item overflows extent item, ptr %lu iref size %u end %lu",
-				   ptr, inline_type, end);
+				   ptr, btrfs_extent_inline_ref_size(inline_type), end);
 			return -EUCLEAN;
 		}
 



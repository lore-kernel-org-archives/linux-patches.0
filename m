Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CD13B0AEF;
	Mon, 23 Mar 2026 14:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274761; cv=none; b=Hffb445LD/dI95n7TFL+KLovQaRpsRCr6WM1mRanhHZiW9lyxNAyp2NCC/GQP4WerY6/yR8Sp3tXkJT5bzFuF34RQWcmevkXUrJepNoQbTPYcunEg3G5sne+xCXCnQs/BuTqgbk8ijmTKMR0j4kSrjlXVl9UASC/gXJkBd1ZhOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274761; c=relaxed/simple;
	bh=piEEBoTDdC6p4jnWQRQSFCKj/N8V5uJBt3rOJjkt0+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3j4f9rEGv3vRYYfzIbnYLQ7aFjL0KdgQ7UWkJuQ42/MHxBFDzcwQs1ikaIi47AyL9uQ2vJ21tTXoGOT+6okJXQf1MxGrz+F1ixDGlGjfHVnCh++zRc31vUn7oyPR845ct6LaHc+Glelp5MIV1fCCGE8q4OHDodEltF63ERpJy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2DRhai9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2DRhai9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F39C4CEF7;
	Mon, 23 Mar 2026 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274761;
	bh=piEEBoTDdC6p4jnWQRQSFCKj/N8V5uJBt3rOJjkt0+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2DRhai9lCKHGRCGbiXfiDhVmvkc9MRIaee0a54gzVqV3VGwMuGk26AaTgHeXKXD7
	 BQKFK8J0rJjp7tmLbY4TQbaRel3ceS3Hh2Bmzqubjl+sclFXIxwYGguBm8qZ13XChs
	 yc3xUj6RvvK52vN7vCSFN7QKekpvB5XhS+48z2Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/212] btrfs: tree-checker: fix misleading root drop_level error message
Date: Mon, 23 Mar 2026 14:45:21 +0100
Message-ID: <20260323134506.939970323@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit fc1cd1f18c34f91e78362f9629ab9fd43b9dcab9 ]

Fix tree-checker error message to report "invalid root drop_level"
instead of the misleading "invalid root level".

Fixes: 259ee7754b67 ("btrfs: tree-checker: Add ROOT_ITEM check")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 420c0f0e17c85..9b11b0a529dba 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1256,7 +1256,7 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 	}
 	if (unlikely(btrfs_root_drop_level(&ri) >= BTRFS_MAX_LEVEL)) {
 		generic_err(leaf, slot,
-			    "invalid root level, have %u expect [0, %u]",
+			    "invalid root drop_level, have %u expect [0, %u]",
 			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
 	}
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3184029ACD7;
	Mon, 13 Apr 2026 16:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096710; cv=none; b=Hp53mIoPi7dVe0ihlPAKl2K6pzKyhlFgJnrC8Gqt8k8bzAAEb/Lbu81tQGxMNSPFUH6qymaIbVEGJxbXST6xLMm1CJZ+YNs9sq9+fmqTXA9ANwd+zCeQCUiRjSn7tHpLe3Ncnhci2urdaBGSyRSGEor+znmqIJDd+Svs/mEqaek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096710; c=relaxed/simple;
	bh=03Dtu5lWmCQrI9jC00Q6z4V9tYUGXXxIkAkhTW/YTx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKtD/ZTObIBl70nGD1QLfo1RVa8Jft9COitWdVY8/VQZJry53SXUsKKvF7WRXC8TTELmusPBKszwLqjui/K4aQZ3qojjSTKn8Ss8RW8QPf3nmAjLDRUrD357koMPWFYoK27hL2uxPy0o4OJAlUkBYgK+Kpae8BNV3lzh8phyVoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0nEwHBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0nEwHBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3EEC2BCAF;
	Mon, 13 Apr 2026 16:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096710;
	bh=03Dtu5lWmCQrI9jC00Q6z4V9tYUGXXxIkAkhTW/YTx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0nEwHBWmFgveKOwIVdvfHkjVO0BzdvEJtYTDTb5KVoSBXJOlQE2KVElj+Lzeh9YE
	 79WAWAGcDYHaGLzYigeFoqyZb69E1CLe1+r93CMnyh370U1PVSpAbLZ/waREKO0awc
	 Brcx3HCGRn9W5+PzNDlNdHMhJXI+QuHeMt+izCnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 15/70] btrfs: remove unused define WAIT_PAGE_LOCK for extent io
Date: Mon, 13 Apr 2026 18:00:10 +0200
Message-ID: <20260413155728.756421987@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit db9eef2ea8633714ccdcb224f13ca3f3b5ed62cc ]

Last use was in the readahead code that got removed by f26c9238602856
("btrfs: remove reada infrastructure").

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 316fb1b3169e ("btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e22c4abefb9b4..efface292a595 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -263,7 +263,6 @@ void free_extent_buffer(struct extent_buffer *eb);
 void free_extent_buffer_stale(struct extent_buffer *eb);
 #define WAIT_NONE	0
 #define WAIT_COMPLETE	1
-#define WAIT_PAGE_LOCK	2
 int read_extent_buffer_pages(struct extent_buffer *eb, int wait, int mirror_num,
 			     const struct btrfs_tree_parent_check *parent_check);
 static inline void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
-- 
2.53.0




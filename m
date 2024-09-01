Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B802C1B4;
	Sun,  1 Sep 2024 16:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207574; cv=none; b=hTbwWYTfOD/8LqbgWgBBrDDDvuKcAQhjTGAzCdcehE8cqN5WC3S6rUYJqPb5DQPzcCoHXTG+yLMC3S7JO9ofGPBIdKRVLQzICei9qLI7T8fUEie0hyX7qTk/ieBwbxjJrGtpf7qbGnGmL0kvXd48lRMisbX7fRSED4ql50/LHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207574; c=relaxed/simple;
	bh=i7zWUtKms9qUcWFQ75m4H0gaPWVQVdPavvTxsxFhiog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDePCQ9PAJkQUFqbYSUZikISvhdEWtOrC2lqCs3kqZNbnvjWQKtPuGmyXdfH3G532yyxgdV/4PJbrS9gJBWgGCvay0lYHU1J2sSyX9TeRyOUBazUEYN7j2dxf7c+EcLpGUWZqHYYMOd89XcrVjU7tkxpTmxt4YEK81hTZU+O+T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRIOA9iT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRIOA9iT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7615AC4CEC3;
	Sun,  1 Sep 2024 16:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207573;
	bh=i7zWUtKms9qUcWFQ75m4H0gaPWVQVdPavvTxsxFhiog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRIOA9iT6PgYMozlUSemtdO+XMGA2nzj13rqKcRnNZiBFvOVAgDXOocnOlVMDAEKG
	 dQZP86NRdk86d2cQWYepLD4geyCbi+6/X5iwnFT17EiOopxG5swauNpquIDzbqBGPt
	 O7aRKCyq0D2ExoF96EaPSFbZzkOrWIbEsMfoeKQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Sterba <dsterba@suse.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 13/98] btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()
Date: Sun,  1 Sep 2024 18:15:43 +0200
Message-ID: <20240901160804.187033925@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

commit 4ca532d64648d4776d15512caed3efea05ca7195 upstream.

bitmap_set_bits() does not start with the FS' prefix and may collide
with a new generic helper one day. It operates with the FS-specific
types, so there's no change those two could do the same thing.
Just add the prefix to exclude such possible conflict.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/free-space-cache.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1732,9 +1732,9 @@ static void bitmap_clear_bits(struct btr
 	ctl->free_space -= bytes;
 }
 
-static void bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
-			    struct btrfs_free_space *info, u64 offset,
-			    u64 bytes)
+static void btrfs_bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
+				  struct btrfs_free_space *info, u64 offset,
+				  u64 bytes)
 {
 	unsigned long start, count;
 
@@ -1991,7 +1991,7 @@ static u64 add_bytes_to_bitmap(struct bt
 
 	bytes_to_set = min(end - offset, bytes);
 
-	bitmap_set_bits(ctl, info, offset, bytes_to_set);
+	btrfs_bitmap_set_bits(ctl, info, offset, bytes_to_set);
 
 	/*
 	 * We set some bytes, we have no idea what the max extent size is



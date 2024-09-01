Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A5183CA9;
	Sun,  1 Sep 2024 16:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209380; cv=none; b=p/44J27lOm9hugjc1JVfU7JQ7lcePavNHvGJWpIVXJ99HOHBP0PwzIygp2VLfEF/XgKUvh1GhXNBZ25stgoKbwwZpb763Wo4hZo1/IChFK0rodZnabOoacF2GN3k1qpmX6or5XItlvn+VFbFQAnIsC7ZCcaW8SWUBPORiT96Fu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209380; c=relaxed/simple;
	bh=Bt1f60IIuKxVdTdVNSp/lQWwduFU2bWnJHzKzxEWvew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8h6Ba7wu1Az/49aYJvTSHaIjuvsvm4xQeQws5cdjtLBFhW+qyJMn9iecBR9LY5zaLVZLfeAnbghufXJ4C7D6GBY3WeoVDrZTpXEYWslZk7uBFuB63a7IjIE898JDbKUDGQ/wAlRQd48sU5ZWSUXDBnvwIPsX3+woAXX0FByVvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XRYzzmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XRYzzmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51774C4CEC4;
	Sun,  1 Sep 2024 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209379;
	bh=Bt1f60IIuKxVdTdVNSp/lQWwduFU2bWnJHzKzxEWvew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XRYzzmj5OdVGP0Dm8bnxCGT/nBsk07430FnnUoR83bkY7/+e0uBv35ulPsOEsmuP
	 l91vW2oEoYqNdRivkNn0gAZhNAFBTifV21bHkGPxDVIXXiEvV0bxHDwmGArXeD1vM3
	 m2kCYLsMThtvMM4esDDUEZRM+2Y0eLvurVzZNuNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Sterba <dsterba@suse.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 018/151] btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()
Date: Sun,  1 Sep 2024 18:16:18 +0200
Message-ID: <20240901160814.786021163@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1755,9 +1755,9 @@ static void bitmap_clear_bits(struct btr
 	ctl->free_space -= bytes;
 }
 
-static void bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
-			    struct btrfs_free_space *info, u64 offset,
-			    u64 bytes)
+static void btrfs_bitmap_set_bits(struct btrfs_free_space_ctl *ctl,
+				  struct btrfs_free_space *info, u64 offset,
+				  u64 bytes)
 {
 	unsigned long start, count, end;
 	int extent_delta = 1;
@@ -2077,7 +2077,7 @@ static u64 add_bytes_to_bitmap(struct bt
 
 	bytes_to_set = min(end - offset, bytes);
 
-	bitmap_set_bits(ctl, info, offset, bytes_to_set);
+	btrfs_bitmap_set_bits(ctl, info, offset, bytes_to_set);
 
 	/*
 	 * We set some bytes, we have no idea what the max extent size is



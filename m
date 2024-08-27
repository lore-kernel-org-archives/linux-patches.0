Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A714A4C634;
	Tue, 27 Aug 2024 15:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771777; cv=none; b=enAxoQysVOsP8CJH67fyWK5ib8UVG6k76IINUCaj0iyoK5pBlT7iEO3b85zWErvEFdeKYX9DZC2uqMSDTnzivMSJh5GozCsJSZ0ZdnipuK7WGCDmOUj4Er+FRV+MeSOaE54SBkH7vLQaH9z7xvGQBZNKXmSxpogz73OLob5rdAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771777; c=relaxed/simple;
	bh=aL5/FEYDpAd1RybFEKMqEGhMyFwzef8ZfYCDP+Dd2ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rar/wiMpso44j5d0R3S7Cwpesx6Gv0erfQr3kOURZSzWZDTvEXT9dH7LRoRmAtnsdgW2UUfMeJQ0oVd4hAJX+I/wi0AkfcTCjXGV9thmGZ1GHm8cj0RLQvPOBUPei0zQWcGDJhmvD94ixh+x7tj24siTt8gsBl9Wehqg3NRUIVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vs4uK6Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vs4uK6Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1229EC4AF50;
	Tue, 27 Aug 2024 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771777;
	bh=aL5/FEYDpAd1RybFEKMqEGhMyFwzef8ZfYCDP+Dd2ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vs4uK6YeND7Bf5EAlZU5wfhXvoqkWl74PjKZLkyursdQe+kU+dyP3RhT3V304TkN9
	 1qjcRgMO81rN5uZuA8Nq0Y/NuF8xTGGw8WyUDCkcW3XXcI3Hlezw2Iwf8dhHRnnSgC
	 3vx1iN1+KbvFbnvtvXId/Apifr1wbqNgF2VyyEEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Sterba <dsterba@suse.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 018/321] btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()
Date: Tue, 27 Aug 2024 16:35:26 +0200
Message-ID: <20240827143838.902786770@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
@@ -1894,9 +1894,9 @@ static inline void bitmap_clear_bits(str
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
@@ -2232,7 +2232,7 @@ static u64 add_bytes_to_bitmap(struct bt
 
 	bytes_to_set = min(end - offset, bytes);
 
-	bitmap_set_bits(ctl, info, offset, bytes_to_set);
+	btrfs_bitmap_set_bits(ctl, info, offset, bytes_to_set);
 
 	return bytes_to_set;
 



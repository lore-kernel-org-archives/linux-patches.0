Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0102B17E00C;
	Sun,  1 Sep 2024 16:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208706; cv=none; b=NHvdYj7VEoUpJtJlBl48Un7KkQOAir8PJ8IW6GaeHmhG+2mXCD1dBrddVFTm57+1tZmW+WD+mbDQ1ArIrMMpOA4mcJ/u1eyV5jDCMOL+fzeogRs2z2u28XrFRKf7IQxpfXWHEgGYNpSuXvMu1LbBvGpnK+ZD8HZbumdMf42SuB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208706; c=relaxed/simple;
	bh=OkWDAFe3J9I6MDdRG5roGXQoIB/yLeZjoIychJFmbjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apyMcxppsPHPRD/wWRwXNXYKleLtGyI9ehzJWS1uVQ8EROiXJHQFc8uHwiYXPo2rTJltzTW3bfPF238p5b1FHM2GhufP2dx7ybQy/24W4xNssuERVAi6q5v29Rci+ETPiNh+Cwpi8c/SOljgOMvuhmNHcNKD3EoTgdZ7T8L0kAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgFVYZtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgFVYZtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C24C4CEC3;
	Sun,  1 Sep 2024 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208705;
	bh=OkWDAFe3J9I6MDdRG5roGXQoIB/yLeZjoIychJFmbjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgFVYZtDy+uFsIm86v6oduuKlCbU6NYwix7lwvUscJ3zcOhOGh8sPfGYLEcABAOtC
	 gOhP576qdVDXsnjxHvPFPqp3h1KbUX4Cik9q+6qbVRcvTFbiwx+Qa/smjxhMKxwIVS
	 x8SKx+krZ3hrujl2E8we5UZVc80oNR83CYSIoPFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Sterba <dsterba@suse.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 015/134] btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()
Date: Sun,  1 Sep 2024 18:16:01 +0200
Message-ID: <20240901160810.686530132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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
@@ -1729,9 +1729,9 @@ static void bitmap_clear_bits(struct btr
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
 
@@ -1988,7 +1988,7 @@ static u64 add_bytes_to_bitmap(struct bt
 
 	bytes_to_set = min(end - offset, bytes);
 
-	bitmap_set_bits(ctl, info, offset, bytes_to_set);
+	btrfs_bitmap_set_bits(ctl, info, offset, bytes_to_set);
 
 	/*
 	 * We set some bytes, we have no idea what the max extent size is



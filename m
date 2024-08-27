Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65AF1C57BD;
	Tue, 27 Aug 2024 14:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769759; cv=none; b=GPDZE1joXUoQjHuhf0cD3pdHXAwSqYCCCPMUN722iSZFjdB+A1K1i8EgiNa87ONP/Pv6TmvdBUe5uwXfKF/KJ1ZKvR9rbYh9Uqtkk5gXOrAnW7HdLAUOpqBjd6EUNC6zCmH89G24h/e5pcUOQ11L2zVJHFjLUGXcoO+A4phpUyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769759; c=relaxed/simple;
	bh=0PmGekjgNpUM53xoKHkiY3dFm0Yb2PD38nx/4wnS6ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slbKX0udqgR/FzEcjxwO4wmtOGJo2qwHCp1lFOPwZU6K8lflcwOdlXEzO87NXoQy6weOoVZOYjISWCJiEw3neGUC22LDsldMgLZ2P5wNseqnY0GJ+mSau8inBFZ5If1454LuSGe+j1LmMW2uCVUYKcrJDcorVQxpB9/kt3L2VJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oRhTR/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oRhTR/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBBBC6104B;
	Tue, 27 Aug 2024 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769759;
	bh=0PmGekjgNpUM53xoKHkiY3dFm0Yb2PD38nx/4wnS6ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oRhTR/StHOQLkaYY1Jf+LpA85LPiKaRUtfZx3aHf71CRs+H/SI2xT+LzU4jzfCRv
	 wEU38wDKYkwysrMO7iecN7qN5W3mHMPj2p+Hn4U1V1qLLMFThjaZcqqTGaOcz9n6bA
	 w0E4UTH2uYFT0Fx9lMy12FHf5xkXr5136FeC/u1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Sterba <dsterba@suse.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 028/341] btrfs: rename bitmap_set_bits() -> btrfs_bitmap_set_bits()
Date: Tue, 27 Aug 2024 16:34:19 +0200
Message-ID: <20240827143844.480362058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1910,9 +1910,9 @@ static inline void bitmap_clear_bits(str
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
@@ -2248,7 +2248,7 @@ static u64 add_bytes_to_bitmap(struct bt
 
 	bytes_to_set = min(end - offset, bytes);
 
-	bitmap_set_bits(ctl, info, offset, bytes_to_set);
+	btrfs_bitmap_set_bits(ctl, info, offset, bytes_to_set);
 
 	return bytes_to_set;
 



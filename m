Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC7F3375D9;
	Tue, 26 Aug 2025 11:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207162; cv=none; b=o0JW2strCXNeKi1IVb4Wi+BUm9xva5TAqKZoUMXGlu3dnIIdqHQ8384WVxxj50coiAjditdu+mTKsk/g90Luv9DUto+xTiDfu0ue5Z8h1vzo2iuaB/c7vfteP3epEnVa3ZkSbLe7Vg7E6Cl4dUu5AwtHZFhw6oVAftprXChCjUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207162; c=relaxed/simple;
	bh=3F3GeHFfhmGLNyDK7oqixUTxWJYc4aojTsIsYlMsPfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHSkVXgn+SSgfC16Wq7mlTuesutp5CqZxHRmIydUy6ul2uVovQiHBbM9g/Av45qwYWWqJvzBeLqPEX9X8rjZXQf52lXY34Tu659zpjfPX6sd9fpLw1i/QvZ8jWIErLHJlOBnNGMkA+LH99JkEU1AG2yAjEQWoBUuqviiywZGCYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fX4j85r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fX4j85r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05900C4CEF1;
	Tue, 26 Aug 2025 11:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207162;
	bh=3F3GeHFfhmGLNyDK7oqixUTxWJYc4aojTsIsYlMsPfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fX4j85r1W2jwHsakmBYXcztk6OVIlN8YYK+mKD2eGapB5ngO7SDf0dmdkIZoj+ET
	 58up9iYe3SjKsoxp367SzhgVc2J5lH6sOgqY8uMqJxT73yf4cuGwsixWzmaxvO5the
	 rMiyw2tGabFDgmsJ4RnS/3cUZ5e73wQcAYqLaaBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Kyoji Ogasawara <sawara04.o@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 047/457] btrfs: fix printing of mount info messages for NODATACOW/NODATASUM
Date: Tue, 26 Aug 2025 13:05:31 +0200
Message-ID: <20250826110938.510552873@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyoji Ogasawara <sawara04.o@gmail.com>

commit 74857fdc5dd2cdcdeb6e99bdf26976fd9299d2bb upstream.

The NODATASUM message was printed twice by mistake and the NODATACOW was
missing from the 'unset' part.  Fix the duplication and make the output
look the same.

Fixes: eddb1a433f26 ("btrfs: add reconfigure callback for fs_context")
CC: stable@vger.kernel.org # 6.8+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Kyoji Ogasawara <sawara04.o@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1430,7 +1430,7 @@ static void btrfs_emit_options(struct bt
 {
 	btrfs_info_if_set(info, old, NODATASUM, "setting nodatasum");
 	btrfs_info_if_set(info, old, DEGRADED, "allowing degraded mounts");
-	btrfs_info_if_set(info, old, NODATASUM, "setting nodatasum");
+	btrfs_info_if_set(info, old, NODATACOW, "setting nodatacow");
 	btrfs_info_if_set(info, old, SSD, "enabling ssd optimizations");
 	btrfs_info_if_set(info, old, SSD_SPREAD, "using spread ssd allocation scheme");
 	btrfs_info_if_set(info, old, NOBARRIER, "turning off barriers");
@@ -1452,6 +1452,7 @@ static void btrfs_emit_options(struct bt
 	btrfs_info_if_set(info, old, IGNOREMETACSUMS, "ignoring meta csums");
 	btrfs_info_if_set(info, old, IGNORESUPERFLAGS, "ignoring unknown super block flags");
 
+	btrfs_info_if_unset(info, old, NODATASUM, "setting datasum");
 	btrfs_info_if_unset(info, old, NODATACOW, "setting datacow");
 	btrfs_info_if_unset(info, old, SSD, "not using ssd optimizations");
 	btrfs_info_if_unset(info, old, SSD_SPREAD, "not using spread ssd allocation scheme");



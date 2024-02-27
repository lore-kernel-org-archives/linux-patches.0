Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DED54BD4;
	Tue, 27 Feb 2024 13:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042317; cv=none; b=MmCgoqXpFJPQO2dVu/j0kz8pVVlAso0euMetZijk1B7IBV1iRDHuLgzfVCdqO1lHwn5kvq1tExGvNjR89VkAr8cEIPBoKSvULIVoMlY0z6JtyHfkYS/HqjIeGvEhdsXOdj2fHemDmaWttLcrbatb09HcU6/QYp83dVU2mz4KGJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042317; c=relaxed/simple;
	bh=p5BY23UAA2K9iSlGg7j7vfB91uQ1bWSy42eiLS1Vg78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGs2uQjwJ78byG11DEGaxe6n3WUi89D6nnot3P/J5warL210bz995My2bXKvNsX6o+bOWqXmWAw7yxcTPHMcUvyGuk6bhV8KB8fvH4tTsU5Q1uxdFyQ83OWWxRJMVRvKuZM+xw7ycjkIYPiajDKWxBQCM9XcaV3GgUbn9nSxrVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l45CHpMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l45CHpMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC677C433F1;
	Tue, 27 Feb 2024 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042317;
	bh=p5BY23UAA2K9iSlGg7j7vfB91uQ1bWSy42eiLS1Vg78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l45CHpMqtrJoZOl1IGMg2PGiTWWSCDMLdNwUCblmzHZQ+6ZmNvp5NjOw7L0lhLjvJ
	 rXye7WvDM2mk2VXZbPyT3NFi27jF1l4qhmeB86DBtsFciotyGF5FulhYNYhU5OeLAj
	 NjtibF2LKpCcLpCC4pBuqcLKoqs6Qe0n3OGCMsrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/299] afs: Increase buffer size in afs_update_volume_status()
Date: Tue, 27 Feb 2024 14:26:05 +0100
Message-ID: <20240227131633.891423371@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 6ea38e2aeb72349cad50e38899b0ba6fbcb2af3d ]

The max length of volume->vid value is 20 characters.
So increase idbuf[] size up to 24 to avoid overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

[DH: Actually, it's 20 + NUL, so increase it to 24 and use snprintf()]

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20240211150442.3416-1-d.dulov@aladdin.ru/ # v1
Link: https://lore.kernel.org/r/20240212083347.10742-1-d.dulov@aladdin.ru/ # v2
Link: https://lore.kernel.org/r/20240219143906.138346-3-dhowells@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/volume.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 115c081a8e2ce..c028598a903c9 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -337,7 +337,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 {
 	struct afs_server_list *new, *old, *discard;
 	struct afs_vldb_entry *vldb;
-	char idbuf[16];
+	char idbuf[24];
 	int ret, idsz;
 
 	_enter("");
@@ -345,7 +345,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 	/* We look up an ID by passing it as a decimal string in the
 	 * operation's name parameter.
 	 */
-	idsz = sprintf(idbuf, "%llu", volume->vid);
+	idsz = snprintf(idbuf, sizeof(idbuf), "%llu", volume->vid);
 
 	vldb = afs_vl_lookup_vldb(volume->cell, key, idbuf, idsz);
 	if (IS_ERR(vldb)) {
-- 
2.43.0




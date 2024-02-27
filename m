Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7805513EFE9;
	Tue, 27 Feb 2024 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043140; cv=none; b=bCUwFBEEHV5QuVgivRddkCEl26d9+9brHY+Bvy8Dt1opjMkSqnsfBgXIYAeUoE2ji3Hu7byP/EkeA7/eJoxwxpkB4Q16+ZctSCxjioZGBsq/FixaA27IvK+g9dgGZxVP+E2rkd/3ffjSNPfQVZsb1IbTFmdP/A7cKYkAoNlMJDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043140; c=relaxed/simple;
	bh=xUkwcD1F9qpmHR5Ceeg8rvPo0oBppN817Yeg8jlCSqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0CQCTVLUjVm2UBG4WRy0j4V5VEMUIjlvCdA2+YvkbeGlRMSilN8AgWMwMr04T2AvfS1BXIlZcykIxnsG2FRdWIflFMVaHkXhggQUfnorDTk8TdA2wCoz3CBNgFsxaYZRphCPvOaQyiw75buXXlxU4sjyS0+UhtK60Wbxubx39s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpDANVjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpDANVjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0454DC433F1;
	Tue, 27 Feb 2024 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043140;
	bh=xUkwcD1F9qpmHR5Ceeg8rvPo0oBppN817Yeg8jlCSqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpDANVjVakZki/EWMZTEF3BMN5DoB9QPia5F1q07UlRFx76cRTajGqgURxmhUs9/0
	 /u0OrBHFZt+Jhl5LmXPSfkoWyBxtcinVJRU2NNKZJj9oEhSuIormkA6bS3XLG5LfSv
	 eVyRZKk96R0zgZWMuYBGJ2f3tDGJB9nr5+EQFRys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/245] afs: Increase buffer size in afs_update_volume_status()
Date: Tue, 27 Feb 2024 14:26:49 +0100
Message-ID: <20240227131622.378220623@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 137a970c19fb3..3d39ce5a23f22 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -327,7 +327,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 {
 	struct afs_server_list *new, *old, *discard;
 	struct afs_vldb_entry *vldb;
-	char idbuf[16];
+	char idbuf[24];
 	int ret, idsz;
 
 	_enter("");
@@ -335,7 +335,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 	/* We look up an ID by passing it as a decimal string in the
 	 * operation's name parameter.
 	 */
-	idsz = sprintf(idbuf, "%llu", volume->vid);
+	idsz = snprintf(idbuf, sizeof(idbuf), "%llu", volume->vid);
 
 	vldb = afs_vl_lookup_vldb(volume->cell, key, idbuf, idsz);
 	if (IS_ERR(vldb)) {
-- 
2.43.0




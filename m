Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45793876AA;
	Tue, 10 Mar 2026 11:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141932; cv=none; b=ScU/gdArlefmqdsNbVuEkcE1Wxw3XT1ofdGDa/6y2yfAEGYyKzXzBkjKdTy37XXEM7wu/oK3ZjAauCsC7GnDkf06i8j4gLfTe1Au9upyNabx1aZBrt2diVRMHy9b3UJJfoAQcijpN11qbFiiwUuYrdXXiaqROEEtdbk/hlXkXsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141932; c=relaxed/simple;
	bh=fYQYazVTg2EREslTEu39Q3F5Whf/QjC9eoeQS4aZJdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqt40kAL0MP+bJQNP09x+kxFugPruy+BkI7HrscgBoydjF+L1uhSX9+VFwtb1JWY9wBAPGl9gDuKQEWPkxE1pNtmSYyf/mKyotoYJ/JvTS0K98ZXB0tx4f69hLiRPs5mHimb2n8vaTAeCXyyQnR7ofDpDGlApmqE7CJT0tE4iyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSjL6LKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSjL6LKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083C4C2BC86;
	Tue, 10 Mar 2026 11:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141932;
	bh=fYQYazVTg2EREslTEu39Q3F5Whf/QjC9eoeQS4aZJdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSjL6LKfX1+UBOSbPmhiOWLKEAi5jkTwRdvoDHPWghKsZsPK08OfbvMChe+TWv3ca
	 EMSD8a7DmmTigUa9GS4C6I5IwKgoh0bsmtK12ArA6WXnRN4/tCMUddFDxFr5q+IGu9
	 JLzIz9cRarn/ek1A+uJ32YwlOoTmKZfEAl6hybVLDPp1IkXJNl6oIhIQT2F+HE9Fr+
	 UZmkTIrbop48NG2z7fKcFQJrO9Ii460YTaSw8b6hFb52UU8q72lxyI+9VVzMj/ZdT0
	 jEvpUgF/GVl2CBQqfbPnlYeELE00iZtUmcMLV9cECIBZf6NtOy1LVBOa3FCGbbB2v/
	 NTUaljsB3sjxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/314] btrfs: fix objectid value in error message in check_extent_data_ref()
Date: Tue, 10 Mar 2026 07:15:15 -0400
Message-ID: <ee4e875f76d399d57b729e42ca20eef8d606d9d9.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit a10172780526c2002e062102ad4f2aabac495889 ]

Fix a copy-paste error in check_extent_data_ref(): we're printing root
as in the message above, we should be printing objectid.

Fixes: f333a3c7e832 ("btrfs: tree-checker: validate dref root and objectid")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 7bc758ec64a11..420c0f0e17c85 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1713,7 +1713,7 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 			     objectid > BTRFS_LAST_FREE_OBJECTID)) {
 			extent_err(leaf, slot,
 				   "invalid extent data backref objectid value %llu",
-				   root);
+				   objectid);
 			return -EUCLEAN;
 		}
 		if (unlikely(!IS_ALIGNED(offset, leaf->fs_info->sectorsize))) {
-- 
2.51.0


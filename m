Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BE61C57AB;
	Tue, 27 Aug 2024 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771942; cv=none; b=bNtDKGKIzH6kCJQ1oBrGvdqp4UJzunuMXqRhVS6b3yXtEHQE5N1EC/CjRX7wCYEUo0sGMTUZOq/ijXw15QiGAGqO3RJ5W7xlZcCR9/JULTb7DCnMIctI3EYT72F1Mp5yxlN3DrRa6LiH0O+t2coQF2yEHUHaiFoPXyB1awh/jlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771942; c=relaxed/simple;
	bh=8VCkeZyD+YO9FU0uzWVTdOEooiXoUmOxZ9sEUCpeLmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgN89ThSeYRIvzVchd27EwW5FrzP7sSDvrMK64sVEKTr5B2piBZzVJ17aTctFaxHfFLOaTuo6VBEVAsZhwgsrIYFzBNek9a7pSf5vpgOcbxjf6OSe0nZaPd1oMzC7/hDZgeLBcMcyf1wYuOXBTBsyrFycFRS8hmloi1tIwe0GAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blofPmdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blofPmdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826D0C61067;
	Tue, 27 Aug 2024 15:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771942;
	bh=8VCkeZyD+YO9FU0uzWVTdOEooiXoUmOxZ9sEUCpeLmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blofPmdZH53e5JfAnyiV6TZdW5ydB2nY8zXbqwCG/dxIL20lGMW5LE9OlSlsh2pEc
	 mevNJMr/RSVbGBESdTjZIJdwfu4iLP0jT19qAeJoJhpx9/A/UjwkxDHWVY852u4O4b
	 bu8HAYgD2+zU7Nj5o2tAj1Md66ZnnOILGJ6KHfy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+048585f3f4227bb2b49b@syzkaller.appspotmail.com>,
	Dipanjan Das <mail.dipanjan.das@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/321] nilfs2: initialize "struct nilfs_binfo_dat"->bi_pad field
Date: Tue, 27 Aug 2024 16:35:44 +0200
Message-ID: <20240827143839.597197834@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7397031622e05ca206e2d674ec199d6bb66fc9ba ]

nilfs_btree_assign_p() and nilfs_direct_assign_p() are not initializing
"struct nilfs_binfo_dat"->bi_pad field, causing uninit-value reports when
being passed to CRC function.

Link: https://lkml.kernel.org/r/20230326152146.15872-1-konishi.ryusuke@gmail.com
Reported-by: syzbot <syzbot+048585f3f4227bb2b49b@syzkaller.appspotmail.com>
  Link: https://syzkaller.appspot.com/bug?extid=048585f3f4227bb2b49b
Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
  Link: https://lkml.kernel.org/r/CANX2M5bVbzRi6zH3PTcNE_31TzerstOXUa9Bay4E6y6dX23_pg@mail.gmail.com
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btree.c  | 1 +
 fs/nilfs2/direct.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index bd24a33fc72e1..42617080a8384 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -2224,6 +2224,7 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 	/* on-disk format */
 	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
 	binfo->bi_dat.bi_level = level;
+	memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));
 
 	return 0;
 }
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 8f802f7b0840b..893ab36824cc2 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -319,6 +319,7 @@ static int nilfs_direct_assign_p(struct nilfs_bmap *direct,
 
 	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
 	binfo->bi_dat.bi_level = 0;
+	memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));
 
 	return 0;
 }
-- 
2.43.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052050;
	b=J53M5UaC3OBR5eS5rk0MPQ9ZcEbhh9sAToWxlPFxGU4+vZ7DssTkFrSBaaPdEeM2IQgw
	 5jZ7nWYOTBHn80l93qmpP+t1vOLfN4sa+KzXt1LsuQuls1EQ18FzPrIeHIGedHb2L/Iwi
	 6HIjZUNWQFwnZ1qFulaMvWFqdVQ+DFraSqo5f5OyPkM+T8oGUbbODjwL2f2f7PKzcxfSB
	 VntZg95cs3U85lxqufHvI9JusmhWJCJRpb9atIyBVdgTb076Yj4cuKiUN/J8/reELYO08
	 xieCPL8ITDXaFUcEXSZPVHC/f9Kp3G09HMJkWAaj+JswPzk7E5rP/5LhpRMpPgkMzQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z3qbWTKEYUby4CANDHdbbYZIW08n1aVsU73uVd2ldns=;
	b=NxDUOvWDoDftjGUUPITilhP9n1XBiGQToESpud1T7pz33hv7cJuBL2nHEjAMUbjfZPDE
	 JwTaOM1ToSOFtfgGhCy9NLpjrVu7O3CrlLSF5CHkc166I1raPtLityTHI+em2BvkrulDb
	 PTKE1bgu/UDIaQA7Ij6yMl2rA+d7UMXH0ESKIB4fm1zEbAXqyCclqFNyYbM7gy/Phka7Y
	 yutTF3tVNNR/kC6eom978On6uiTAxGNJMdZtbv8MNLXHLJ/6HlRJ28W8yG1b1UvZ5VSZi
	 Np4lZzFKsNwf32xL9Etgww+1mZRoEgzOtkvCqWe1ToPJ9qNw5hLqpMtNtmquQZlbTmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qaxl12S7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6EE606A32A;
	Thu, 19 Nov 2026 01:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qaxl12S7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0FB1F000C4;
	Thu, 19 Nov 2026 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052050;
	bh=z3qbWTKEYUby4CANDHdbbYZIW08n1aVsU73uVd2ldns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qaxl12S7g0P0ABZZNqLjpHK61UqncxdDQDgwkLbvGSCS2LegIKT2/05n2infqMqTQ
	 x9NrWdXGRHpOOBPm/cfxpeW37O6KW3XtCnf09gl/utY5C+9bzkzmavVU+EKoZcnNbM
	 ExDFaD36e1nYMd41W+JLTtKsY1QzPhQBiEO4/csc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0427/2214] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed, 18 Nov 2026 15:35:03 +0100
Message-ID: <20261118150027.972476097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit cbec8610ec5aaf35df50094ff639febc23f20773 ]

Listing a directory while it is copied up causes a use-after-free of
the readdir cache.

A merge directory must never be iterated as a real upper directory:
that mode frees the cache in OVL_I(inode)->cache without looking at
its refcount, while files opened in merged mode still use it.
ovl_copy_up_workdir() publishes the upper dentry before it sets
OVL_WHITEOUTS, and ovl_dir_open() samples both without a lock, so an
open between the two stores finds the upper directory and takes it
for a real one.

With a delay between the two stores, an unprivileged process that
listed a directory during its copy-up saw only "." and "..", and its
next getdents freed the readdir cache of another descriptor.

Fix this by setting OVL_WHITEOUTS before ovl_inode_update(), so that
ovl_dir_reset() agrees with ovl_dir_open(), and by testing
OVL_TYPE_MERGE() of the path type in ovl_dir_open(), so that an open
that observes the upper dentry never iterates a merge dir as a real
dir, regardless of the order in which it observes the flag.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: test OVL_TYPE_MERGE() instead of smp_rmb() in ovl_dir_open()]
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: Adjusted context to preserve existing inode initialization and cleanup while replacing the dentry-based ovl_dir_is_real() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 2 +-
 fs/overlayfs/readdir.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 4c7ef60dbaac0..dadca83b41a69 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -711,9 +711,9 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (!c->metacopy)
 		ovl_set_upperdata(d_inode(c->dentry));
 	inode = d_inode(c->dentry);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 666cc62578f65..ed4c34366c5c0 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -942,7 +942,8 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(file->f_path.dentry);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
2.53.0




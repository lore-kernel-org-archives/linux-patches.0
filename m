Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F0E17C;
	Sun,  1 Sep 2024 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210107; cv=none; b=NOGpOpwEHF5JbfkgVltTVnauvmhk6VChvai6K5RDJSRnfkxhnTZsJyuIndSQBAzzg2csa22Tvb50PAlOhZ8scLl6oBnoCntqa4A3BlgEOyfdTAQO3bWolN3QXZdypq/KQIwYo7V2mZwvVak5TfX1SX9OrJ7odwuPzD+CirORRE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210107; c=relaxed/simple;
	bh=pqePr75mHhihpH9ptOMEfDSpiuvm1t7Vl03rmC4ZkME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmDEJaM1jpad1KMfcXeiWXQESH+KRt63K/MQNeyxnuj2SwKnKf0E3XsUkJOqAPOj/g5IfYuhIlzbwhUvwGCZ+2ACQ3K+KB4+J0fqlAUtEluyJlLoOc7/oC4utIzA3zyVlcoKSsWRRXCT6jF7KFw42zy/oB2KuD7/wXQFJiW/h90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK2vfLk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK2vfLk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D170C4CEC3;
	Sun,  1 Sep 2024 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210107;
	bh=pqePr75mHhihpH9ptOMEfDSpiuvm1t7Vl03rmC4ZkME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK2vfLk+W3IrdRhfvZTAWNKIii0fo3y9v3wSUSNRaEnb066FM1cqvs/k6AUMOnDMx
	 4KerxaxM+6c1GXg9OsiAO4+mwRBuIwEIPECBJDYxvFUcUgb0obhm2RPeFXTC7fikb1
	 NxyaWUA38QxyEZylIXpwC+ww4Us4fwlU1c2xhvVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/215] btrfs: change BUG_ON to assertion in tree_move_down()
Date: Sun,  1 Sep 2024 18:16:42 +0200
Message-ID: <20240901160826.754814448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 56f335e043ae73c32dbb70ba95488845dc0f1e6e ]

There's only one caller of tree_move_down() that does not pass level 0
so the assertion is better suited here.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 27a33dfa93212..577980b33aeb7 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6882,8 +6882,8 @@ static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen
 	u64 reada_done = 0;
 
 	lockdep_assert_held_read(&parent->fs_info->commit_root_sem);
+	ASSERT(*level != 0);
 
-	BUG_ON(*level == 0);
 	eb = btrfs_read_node_slot(parent, slot);
 	if (IS_ERR(eb))
 		return PTR_ERR(eb);
-- 
2.43.0




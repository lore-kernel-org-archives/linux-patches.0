Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B9B25D8E8;
	Tue, 11 Mar 2025 15:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705976; cv=none; b=TDVwuc39vvqPfiqhkZ7pNaiF5WkGJn0vQMlIPuuGTRgyb0HLqE1sB4o1syF+HgvITPc4skVLSHcMlRPxefpXoJ8mo19h9/5hvy40C7JexcIv18+D29eTY5DoxYcwN0qySN+XdF/WFQTBZjjjEsqBFJ/UxgSzBaBBbfvCs2jrsPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705976; c=relaxed/simple;
	bh=XzusF4GiBwsQS4HHl+sk+iMKzXVFlfqY+B5XV3mgumc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/nevUGQYRJ/nThIS291J7SiPHjyCTkiBmTMRAyfPBtyM9aoGCNfaZNsEOOIUT6Y/PZsXBuT2lGVdgj3KOMZq/oBswug/PFlYGNiSnJeWc/KA9uDx1H14DqJOzHGiISyId00f9YDZIDsSSASWH9tkWE+ATRJnJMsVXA4thOScio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ape5u7lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ape5u7lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA84C4CEE9;
	Tue, 11 Mar 2025 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705975;
	bh=XzusF4GiBwsQS4HHl+sk+iMKzXVFlfqY+B5XV3mgumc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ape5u7lmUR2YiecKxopMT2SYyGLgbEHjc1InR0Ci7nq2pQjNp5oYAj9EQJ5dSX/pJ
	 Vxx/xw0W96B2Ov6ufkH1nokoN7ARA7I5DdZ4bND1mcOCExhtarjaoyS0MZSngBVlTs
	 a5mONDtA29EyJuOCsBJufjsSqvgFOQwQ/xLSj1ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 5.4 220/328] Revert "btrfs: avoid monopolizing a core when activating a swap file"
Date: Tue, 11 Mar 2025 15:59:50 +0100
Message-ID: <20250311145723.647500084@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <koichiro.den@canonical.com>

This reverts commit 3d770d44dd5c6316913b003790998404636ec2a8.

The backport for linux-5.4.y, commit 3d770d44dd5c ("btrfs: avoid
monopolizing a core when activating a swap file"), inserted
cond_resched() in the wrong location.

Revert it now; a subsequent commit will re-backport the original patch.

Fixes: 3d770d44dd5c ("btrfs: avoid monopolizing a core when activating a swap file") # linux-5.4.y
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7679,8 +7679,6 @@ noinline int can_nocow_extent(struct ino
 			ret = -EAGAIN;
 			goto out;
 		}
-
-		cond_resched();
 	}
 
 	btrfs_release_path(path);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AA52DF9F;
	Tue, 20 Feb 2024 21:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464191; cv=none; b=kjLkUH32+UfUMrkq0F9QYEtcL5212OW+igRv7qHMhBHYYREKSlmn1H3Fn5k7lTU5RZXyUPaFmCIPPc1Hu5Fz+zr1X0rcMe3onxMComt+S23zcNw8MG07U3o0sVVnS95x4FvJ5WOvERKou071fSDGqAtlBnIrH+l1pNEHjEpAMn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464191; c=relaxed/simple;
	bh=SPy5WVlY37WOhhL748uMy9ubr34yOH/n1BcVjtXzM34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWpeT1EIUzz1pU8UwhO8YrpuNzAGI2+04n+QHF8jthaQEd0TifRWFJpmxO6urMcYrGQ624wny8bLsqO3cM2V/bAgmSxQcx+bcPvr9TI8zCTGDpVjHBN2ootKtxd7fZQWBnSuCnoKZ9qECMmOADK8N+3KWPtYhTH9C1HXqY3msVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nExRwAM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nExRwAM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31387C433C7;
	Tue, 20 Feb 2024 21:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464191;
	bh=SPy5WVlY37WOhhL748uMy9ubr34yOH/n1BcVjtXzM34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nExRwAM5mIuPMfhTi3ZsLUF4xQ5U64FlAxEhZpN4dFXLmkfQyUfRO4VAkBh7xsgBU
	 DixDRpalVpmxRWGA3D6SPpb3p0nFlmaE7kt3Y5p7jR/7kiTJlq0AYTM0kKizYfq+Zj
	 cdZe6LQNlXLnz8uO++gl3eh49aaz3IActp+KmjBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kernel test robot <lkp@intel.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 272/331] eventfs: Fix kerneldoc of eventfs_remove_rec()
Date: Tue, 20 Feb 2024 21:56:28 +0100
Message-ID: <20240220205646.433425913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 9037caa09ed345b35325200f0e4acf5a94ae0a65 upstream.

The eventfs_remove_rec() had some missing parameters in the kerneldoc
comment above it. Also, rephrase the description a bit more to have a bit
more correct grammar.

Link: https://lore.kernel.org/linux-trace-kernel/20231030121523.0b2225a7@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode");
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310052216.4SgqasWo-lkp@intel.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -796,9 +796,11 @@ static void free_ei(struct rcu_head *hea
 /**
  * eventfs_remove_rec - remove eventfs dir or file from list
  * @ei: eventfs_inode to be removed.
+ * @head: the list head to place the deleted @ei and children
+ * @level: prevent recursion from going more than 3 levels deep.
  *
- * This function recursively remove eventfs_inode which
- * contains info of file or dir.
+ * This function recursively removes eventfs_inodes which
+ * contains info of files and/or directories.
  */
 static void eventfs_remove_rec(struct eventfs_inode *ei, struct list_head *head, int level)
 {



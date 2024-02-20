Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39065151CE1;
	Tue, 20 Feb 2024 21:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464166; cv=none; b=Gd7XVlMwalgdLMviRD3rIxdAwlGkdmyG152YsM+V3oRV1NjZpqUNY38YsEubEKsjyticjXr1s/8I1FJp2YFN1h/1wtOvVxQcJQ/J6M1MD6H8o4BbaXWmn7qIijLWcgfhMMHBDkxzmFUyNsueImtiBQK5A76+rYhk4XS3wmkDKmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464166; c=relaxed/simple;
	bh=KsDlZlcLJ2T208cYLo/27uSFPxNkEIqlxCA314mUJM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7pC4rNeY/KfrMPj+i6re/xXqkRhHQOvtkWYtihWYCYoWG0gXv9mFI2+bAQZNS0PqvjP7iu0yWg7ovkEKNHsd8nJKkUPxYtoVlj8pTjdgNcCFXNoKDNJuWBkOUI7MDySw/apDTe/pJF2jfiU/Juuk/Vv0Nv5Nf7Qd3U1s1y8lto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdcG4sCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdcG4sCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C9FC433C7;
	Tue, 20 Feb 2024 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464165;
	bh=KsDlZlcLJ2T208cYLo/27uSFPxNkEIqlxCA314mUJM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdcG4sCkqwAYr7QfYRVwA/cWUK2l1eKmey5ARPRfUZgHVHkEWOnrry4PMgChSJ2Xr
	 oAuM3dvVxW9F7EWmIRgUgbo3jgm5XgQ82Nvc2NHdo5XLczsTXONgmBlNLCa4OaQm5z
	 ALMIfQs6bW2j0peSS1VQDiW8YbmGVkYswfa7Xzpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 270/331] eventfs: Fix typo in eventfs_inode union comment
Date: Tue, 20 Feb 2024 21:56:26 +0100
Message-ID: <20240220205646.367402482@linuxfoundation.org>
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

commit 29e06c10702e81a7d0b75020ca514d2f2962704a upstream.

It's eventfs_inode not eventfs_indoe. There's no deer involved!

Link: https://lore.kernel.org/linux-trace-kernel/20231024131024.5634c743@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -37,7 +37,7 @@ struct eventfs_inode {
 	/*
 	 * Union - used for deletion
 	 * @del_list:	list of eventfs_inode to delete
-	 * @rcu:	eventfs_indoe to delete in RCU
+	 * @rcu:	eventfs_inode to delete in RCU
 	 * @is_freed:	node is freed if one of the above is set
 	 */
 	union {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803AB14F9DA;
	Tue, 20 Feb 2024 21:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464295; cv=none; b=DpCaC+T6VFZ6VHIQTJtGceUWuRkqeqaMvwakSRpD0zfnqaSWiGQGq6FlIGdUrpB7wp46VTqJ/pxZ8e13Ie0uIIwT5AxDEpOJQh4XMtXNpV2hSnzhLaMBF4nd8GkcY6codPd8iWLFswYhGk2MUrRwZSoRAM3cLPd6Hc7Qol3q330=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464295; c=relaxed/simple;
	bh=l0T+lY4ulc4x7nPSqTq7GiV0roy+PCaZm3+HYBUCOxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZHL/GJQXKy7ps+83R7wDtjwmHwYJxLZYnUkSmkPGWCl+oe6zCRgzPwsBTBsH1XxrlEm8bTgHOYA6BgDkUc2ZQuSJVrltNd6imS3yXwnbooOG+V1y6v5ebqDaY+UghEtJDv3RJgT/madu+B7MAszcMSE9qVEcGxgBOV5wczYQ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Btfveso7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Btfveso7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35A9C433C7;
	Tue, 20 Feb 2024 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464295;
	bh=l0T+lY4ulc4x7nPSqTq7GiV0roy+PCaZm3+HYBUCOxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Btfveso7/KKVsVbcG2an+HWBA7caoDrNuNPhn2a6vp4kqYsf0kmkXP3uW7KCoG924
	 GJETE6XDQ19BOtliREfUOs41fnlwGqdMDlVqNOAa9J2dVR+nJ9k/ztHgSztYc9Jf5Z
	 M0D4PsRNxyrb9m2thKT3572X8BPMlCBLygyDMlZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 313/331] eventfs: Remove fsnotify*() functions from lookup()
Date: Tue, 20 Feb 2024 21:57:09 +0100
Message-ID: <20240220205648.036774059@linuxfoundation.org>
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

commit 12d823b31fadf47c8f36ecada7abac5f903cac33 upstream.

The dentries and inodes are created when referenced in the lookup code.
There's no reason to call fsnotify_*() functions when they are created by
a reference. It doesn't make any sense.

Link: https://lore.kernel.org/linux-trace-kernel/20240201002719.GS2087318@ZenIV/
Link: https://lore.kernel.org/linux-trace-kernel/20240201161617.166973329@goodmis.org

Cc: stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Fixes: a376007917776 ("eventfs: Implement functions to create files and dirs when accessed");
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -366,7 +366,6 @@ static struct dentry *lookup_file(struct
 	dentry->d_fsdata = get_ei(parent_ei);
 
 	d_add(dentry, inode);
-	fsnotify_create(dentry->d_parent->d_inode, dentry);
 	return NULL;
 };
 
@@ -408,7 +407,6 @@ static struct dentry *lookup_dir_entry(s
 	inc_nlink(inode);
 	d_add(dentry, inode);
 	inc_nlink(dentry->d_parent->d_inode);
-	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
 	return NULL;
 }
 



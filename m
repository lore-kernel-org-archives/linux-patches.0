Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7E214F9C8;
	Tue, 20 Feb 2024 21:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465076; cv=none; b=aN77pjfkBZehA9CjIZFZdM5Aq35RFs9lLd2bZxYoDYeFW9HDMGdh7ebC99x/16cycbjOu9gPmOkaCgTDqtKkdyuvLMOeacaigzX5rK3hnN/CzVmEyFD2A/lZIewmfflf2HxnbMw/hdSnA2bKyfuJWhC0gHwR7tgprWsXxYrENbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465076; c=relaxed/simple;
	bh=9fjxhADOWULJ+PFIekKlJoDYDF6uTK0GbjbOM93lhEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omJOI6IpeEcLU2KuWj/Y88PbptbkWVuaQKIgkLeYWPeoGd1I2M8oc5Xqbx968XjUmqCOzLA3tkAkmLARIKmEZhk9U+RL1+iceJUz8bKR+s3b+h3N2L6+J+y6lPd1Zb1SIfFPlswsR1SprgHtKWVKqMHrGl/+VOp32lQjZ1g0Z9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hpmrAbGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hpmrAbGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824B9C433F1;
	Tue, 20 Feb 2024 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465076;
	bh=9fjxhADOWULJ+PFIekKlJoDYDF6uTK0GbjbOM93lhEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpmrAbGX9KUg4Rgahu/DpAPrW59sXF/AQZd6Wu+5ltO32vOoADvxjwjWUZxKpdjTF
	 q1IOfljtkFynCv9HMEWZheWf/HuAbNXZZy0weV0Eho481DimognZz7DKnqd8yHM88o
	 AAx+rUqmceG3StB+eAyZlv8Nr3uiCfeZa0YVkuUM=
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
Subject: [PATCH 6.7 198/309] eventfs: Remove fsnotify*() functions from lookup()
Date: Tue, 20 Feb 2024 21:55:57 +0100
Message-ID: <20240220205639.380093301@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 



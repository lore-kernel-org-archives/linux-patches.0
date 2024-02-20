Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269781509B1;
	Tue, 20 Feb 2024 21:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464229; cv=none; b=TgnVrVHnBiPnAtZG4hb4ceZfelub4axsiVM7uRE5LMa5hLTLgbVgazOlUpaRkma3y4tq/mudsrcbuhjhPNqGH/wYIq+TKkscOwA7Y4WL0NCfHhkKWO/CNJgYFwxt4Ci8nYGtFLtywZ1ep1PyTB3pSLky015zWaaL/afWvWogHKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464229; c=relaxed/simple;
	bh=/VH+qZG+Wub3dIiC8lXhohAxzpiEU9HIw55A4HX8HCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSEWI4DQanKPOYXakpZQ/or7kjguLFR3XhEzH3wtQ/iEFRc3OGC1ot9VEhf3Yurku5rxNp+iSGdN0aDrzE/hxxoTfgvp7Deuu3ezUs767rsSIyxkHcqhQGyHR9E4TdsOeMZ4UIAS3lOvKcJbNF+4Y/VF6xKiATebUW8dwJ8/kmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRmcPjev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRmcPjev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4940C43390;
	Tue, 20 Feb 2024 21:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464229;
	bh=/VH+qZG+Wub3dIiC8lXhohAxzpiEU9HIw55A4HX8HCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRmcPjevvDjGp0wsTe0mnQKlJOA7j+k2NE1bjKCLn7LpaYyf4V8cZOPoVoufGwRu5
	 U8eG3eXEgyt77iw6oUpHSupC0dsVHWqItyZ0X4EQZ5D44Rj7ljJocsvi925KielfL0
	 F8zXJGCIXihcvHc08ESFn7oAPdfr3vYV0gPzY6cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 291/331] eventfs: Fix bitwise fields for "is_events"
Date: Tue, 20 Feb 2024 21:56:47 +0100
Message-ID: <20240220205647.155931353@linuxfoundation.org>
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

commit fd56cd5f6d76e93356d9520cf9dabffe1e3d1aa0 upstream.

A flag was needed to denote which eventfs_inode was the "events"
directory, so a bit was taken from the "nr_entries" field, as there's not
that many entries, and 2^30 is plenty. But the bit number for nr_entries
was not updated to reflect the bit taken from it, which would add an
unnecessary integer to the structure.

Link: https://lore.kernel.org/linux-trace-kernel/20240102151832.7ca87275@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 7e8358edf503e ("eventfs: Fix file and directory uid and gid ownership")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -63,7 +63,7 @@ struct eventfs_inode {
 	};
 	unsigned int			is_freed:1;
 	unsigned int			is_events:1;
-	unsigned int			nr_entries:31;
+	unsigned int			nr_entries:30;
 };
 
 static inline struct tracefs_inode *get_tracefs(const struct inode *inode)



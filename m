Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F088BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18292C433EF;
	Tue, 28 Mar 2023 15:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016290;
	bh=BfKRnnwGCG8C2YQtFfWz5276vsj4Phc+F0VcTfw4CMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0p6CsTnpqIqOQgFXYJ13/Q4XdzGY0TfOpwOg86uo9+LBBEFokuBcrkYMkhPQ5+KOe
	 SiUFJAU+PqhStnHPKYwFhI1ZqE/X+8a8NNwl2eqr01ID1kg0gVX5kwGcMCsYINuAeZ
	 eZ0l49d3udrt+GIIkR/5Jyp7NPkgrkeIytQaSMEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 103/146] cifs: print session id while listing open files
Date: Tue, 28 Mar 2023 16:43:12 +0200
Message-Id: <20230328142606.973548042@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

commit 175b54abc443b6965e9379b71ec05f7c73c192e9 upstream.

In the output of /proc/fs/cifs/open_files, we only print
the tree id for the tcon of each open file. It becomes
difficult to know which tcon these files belong to with
just the tree id.

This change dumps ses id in addition to all other data today.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifs_debug.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -173,7 +173,7 @@ static int cifs_debug_files_proc_show(st
 
 	seq_puts(m, "# Version:1\n");
 	seq_puts(m, "# Format:\n");
-	seq_puts(m, "# <tree id> <persistent fid> <flags> <count> <pid> <uid>");
+	seq_puts(m, "# <tree id> <ses id> <persistent fid> <flags> <count> <pid> <uid>");
 #ifdef CONFIG_CIFS_DEBUG2
 	seq_printf(m, " <filename> <mid>\n");
 #else
@@ -190,8 +190,9 @@ static int cifs_debug_files_proc_show(st
 					cfile = list_entry(tmp2, struct cifsFileInfo,
 						     tlist);
 					seq_printf(m,
-						"0x%x 0x%llx 0x%x %d %d %d %pd",
+						"0x%x 0x%llx 0x%llx 0x%x %d %d %d %pd",
 						tcon->tid,
+						ses->Suid,
 						cfile->fid.persistent_fid,
 						cfile->f_flags,
 						cfile->count,



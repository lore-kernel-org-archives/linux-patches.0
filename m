Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C62E25392F;
	Tue, 29 Apr 2025 17:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949287; cv=none; b=V73ybwmuYJl64nT5/wxkuZLe1OaEsQO6vc5U8aGteI+jkM6PPr+LRY3WSs0LR1zs2OQ6FzvPHNLEEl7XPXnMrlsI3MA68B25ewKRafMiLn9b6YjzEAZcnLe9Do0EGWdohH2tf3rkE6EEjMM7C6txJwzLTYL56NXqNtPrgT1geuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949287; c=relaxed/simple;
	bh=tgQukymdsI5znZszaY9qaUUDonaK04D53Edu+It52SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4KJhiNCUcQepb++jjf2h4wSc4+bnJzO/juwf4e+BCPm3PlDfpiohu1ZbMMvBZHpoRcE1GMXqWM8NHOcIB94iAZFORfWMr9ADdRxuXs0r0TM4CJRkml9oUd5LkxdpxO9qAxKWNkTnAxmnqBsWZbtbIv70XZxIVLjZMIo/JmNz8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUQ8ad7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUQ8ad7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F49C4CEE3;
	Tue, 29 Apr 2025 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949286;
	bh=tgQukymdsI5znZszaY9qaUUDonaK04D53Edu+It52SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUQ8ad7ol0nUI8kcGPzXFyKtNPC9oYnwYOzNCHVebo9GKoaQUKBUCMP5L9k5R1KUM
	 zp0Msta1heMbHn4GO50ilDMp6Zubn+lNcsXfQaW/E2uDTJBHb3e4pRISJtQtRmhrdS
	 5k6KGi2xeuWreo3FrEyglyJf1ZxY9e6jD/Et0x5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/373] cifs: print TIDs as hex
Date: Tue, 29 Apr 2025 18:42:27 +0200
Message-ID: <20250429161134.225447722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 71081e7ac16c93acdd18afa65daa468620bb1b64 ]

Makes these debug messages easier to read

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: b4885bd5935b ("cifs: avoid NULL pointer dereference in dbg call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c  | 2 +-
 fs/cifs/smb2misc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 96788385e1e73..51ceaf9ea3151 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1683,7 +1683,7 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		goto out;
 	}
 
-	cifs_dbg(FYI, "IPC tcon rc = %d ipc tid = %d\n", rc, tcon->tid);
+	cifs_dbg(FYI, "IPC tcon rc=%d ipc tid=0x%x\n", rc, tcon->tid);
 
 	ses->tcon_ipc = tcon;
 out:
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 89a2f38f17f37..12b6684f2d372 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -791,7 +791,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 		if (tcon->ses)
 			server = tcon->ses->server;
 
-		cifs_server_dbg(FYI, "tid=%u: tcon is closing, skipping async close retry of fid %llu %llu\n",
+		cifs_server_dbg(FYI, "tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
 				tcon->tid, persistent_fid, volatile_fid);
 
 		return 0;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289DF21ABDB;
	Tue, 29 Apr 2025 17:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947252; cv=none; b=tRQeM/LF38egw9iK87kT/1DnCF/lEzPq+qDDjtSnBXlgx1WU0UI0xNRFMehS3DE/CTPE5H4yyG4K2+qCHQEcQsuKIPc7ASHyu0rFECkIWilrOE7eHSgBwL9Sqw3d5QRwSiQ/7BM5TDvr7CaSy9jfbfHs8ox0lw3fulWZSMa0LKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947252; c=relaxed/simple;
	bh=Wo2wozmoG/11RT168NEmf60knO+dr0lJYvCuzu3Q+i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EF64oYBnSXZPpzoveUKVsLCFXzIBCMOvpxbv660NJgmW6MnZkLh2eBri1R/cQ156da6d+i6GXh8f1/J/kIboprLWRPREbd1kSD7m/q6CZjgCSpCvTbNKIXkGT7QcN0/AnvPskKdAkQOVop2L8lhE9ilEpGyIxptIIqGKAks1DWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHQbJjRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHQbJjRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38056C4CEE3;
	Tue, 29 Apr 2025 17:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947251;
	bh=Wo2wozmoG/11RT168NEmf60knO+dr0lJYvCuzu3Q+i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHQbJjRxoVEXM8EPlBN8W7GRnjJM79bv1zOXtUQTBz/3CoygfvVvKTY9FhA+Eky3r
	 HoJQCqe64bfx256i3u2nbDaHtEWhQhSFYKl160NTn5PX2a9tCFDZ2/wdIC0a5UGT7s
	 VI7Q8wlyjnfTnkVINEy+49o2fyeiEq4KTfGP605w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enzo Matsumiya <ematsumiya@suse.de>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/286] cifs: print TIDs as hex
Date: Tue, 29 Apr 2025 18:42:04 +0200
Message-ID: <20250429161116.996092228@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a3c0e6a4e4847..2c0522d97e037 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2770,7 +2770,7 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb_vol *volume_info)
 		goto out;
 	}
 
-	cifs_dbg(FYI, "IPC tcon rc = %d ipc tid = %d\n", rc, tcon->tid);
+	cifs_dbg(FYI, "IPC tcon rc=%d ipc tid=0x%x\n", rc, tcon->tid);
 
 	ses->tcon_ipc = tcon;
 out:
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 64887856331ae..d21b27e68f2a8 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -812,7 +812,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 		if (tcon->ses)
 			server = tcon->ses->server;
 
-		cifs_server_dbg(FYI, "tid=%u: tcon is closing, skipping async close retry of fid %llu %llu\n",
+		cifs_server_dbg(FYI, "tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
 				tcon->tid, persistent_fid, volatile_fid);
 
 		return 0;
-- 
2.39.5




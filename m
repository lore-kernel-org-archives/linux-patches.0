Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052135;
	b=jzxIlMhxjiIOsgBN4JOzbqJxPThVlYCRXZtbL0vXUbhfvUazrrYNZVwuEXdQgLtmfFNe
	 0yQi8t6uP2s58kp+4tfgGPB6YgGfKXyEwcc2pxYxWJEUaB8wdI31wE3cK6jlE5kGQKD1G
	 M0QtAxSGSqZ/+EDe6WakiTSHB17458q7nXn9nRBlmllU6UVwLqd5OyoKxrnruZEG5IUqt
	 XR4Yk6XX1fpHnhDZKkGLTOUOBHzdIF0Km/gbVDeQcI6QJYtF0ilfRalV+SgDehix7FcIG
	 ZuCpE2u3CkEmhs71chG+ckF56+cIx4bmLSlT64UpoMYSgGZ3cG3CTRP5x0UtSZjWT/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S5nDQl8XGEFqeT2Ef4gvHLCOXNXkwCnk6JqaZFOpVEQ=;
	b=mcXbffv+6yS/7JHaudoKRL9W5asFv5Zd3dvPMe5qNITwrFvlUzS8Q4iJDsUFGzt0Sg0W
	 JmhFhD6+pMz6BlXJwdR2v4L9JUa4LTdCImqJTxze6H+SW5XRkBvxXekLFptjJM2gHkmaK
	 b15KK5iyYdA+esdRwIjkDcFivCkoWYDLnS2N49orqfWh/+0hgvaBVaS51kz9MC0wc2v5l
	 ZSJaCIQQ8WF4zTavE5SrzrW7urkGETEWW3lt2byxILFET1/EkepBJ9IbuQhIL0ixi2ggd
	 AfYJzlFJF3kI+AdMxVlkn1pzsbwKCwCmxnWQBYnDq8Gnz9MlECmWErROFppo1w81wRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeBG1okr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DBB606A31C;
	Thu, 19 Nov 2026 01:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QeBG1okr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACE71F000C4;
	Thu, 19 Nov 2026 01:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052135;
	bh=S5nDQl8XGEFqeT2Ef4gvHLCOXNXkwCnk6JqaZFOpVEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeBG1okrQa+XMZaSaUho3Nnt4Y54/ZaGR5RCbv457gFW2jw7nUIVnsUjN3JlzFVKj
	 r4joMk+KsMnKnHoXQp7ecmbs3bx1RbSBugKTe9p1fSs8s97gBqhTiZ/FgQKzEeyc8i
	 PM/6aW5wDi5+J9itq/NcBJcubbKL9iL9K876VL5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0419/2214] smb: client: fix use-after-free infoleak via the readdir resume name
Date: Wed, 18 Nov 2026 15:34:55 +0100
Message-ID: <20261118150027.626131910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Oliva <diego@bynar.io>

[ Upstream commit 59131dd72f62b198fc9ea1489ad9d3573154f684 ]

CIFSFindNext() copies the resume name that cifs_save_resume_key()
recorded from the last entry of the previous response into its request;
psrch_inf->presume_name points into the response buffer that entry came
from, and nothing ever clears it. find_cifs_entry() records a new
name only from a response with a usable last entry, and cifs_readdir()
only from an entry it walks to, so a response that carries no entries
and leaves last_entry NULL, because CIFSFindFirst() or CIFSFindNext()
rejected LastNameOffset, refreshes neither and presume_name keeps
pointing into the previous response. That buffer has already been
released: by CIFSFindNext() before it installs the new response, or by
find_cifs_entry() when it rewinds the search, which does not drop the
name either and can then fail in initiate_cifs_search() before a new
response replaces it. The next CIFSFindNext() then copies up to
PATH_MAX - 1 bytes of the resume name out of the released buffer into
its request and sends them to the server: a use-after-free read
that leaks kernel memory to a malicious or compromised server, which
can provoke it with a single FindNext response that carries no entries
and a LastNameOffset above CIFSMaxBufSize, which is all the existing
check rejects.

With KASAN enabled, a server that answers a listing that way gives:

 CIFS: VFS: ignoring corrupt resume name
 ==================================================================
 BUG: KASAN: slab-use-after-free in CIFSFindNext+0x8ca/0x14c0
 Read of size 4080 at addr ffff88807c823f98 by task ls/83

 CPU: 0 UID: 0 PID: 83 Comm: ls Tainted: G    B               7.3.0-rc4-00457-gf14572c203d5 #69 PREEMPT(lazy)
 Tainted: [B]=BAD_PAGE
 Call Trace:
  <TASK>
  kasan_report+0xdf/0x1a0
  kasan_check_range+0x10f/0x1e0
  __asan_memcpy+0x23/0x60
  CIFSFindNext+0x8ca/0x14c0
  cifs_readdir+0xf51/0x29c0
  iterate_dir+0x1c0/0x570
  __x64_sys_getdents64+0x133/0x270
  do_syscall_64+0x109/0x5d0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

 Allocated by task 83 on cpu 1 at 13.497119s:
  cifs_buf_get+0x36/0x90
  smb_init+0x4f/0x110
  CIFSFindNext+0xf7/0x14c0
  cifs_readdir+0xf51/0x29c0

 Freed by task 83 on cpu 0 at 13.584018s:
  cifs_buf_release+0x41/0x80
  CIFSFindNext+0xfce/0x14c0
  cifs_readdir+0xf51/0x29c0

 The buggy address is located 16280 bytes inside of
  freed 16588-byte region [ffff88807c820000, ffff88807c8240cc)
 ==================================================================

The same memcpy() first reads past the end of that object while it is
still live, a slab-out-of-bounds read that the following patches
bound; that is the taint the report above carries.

SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Clear presume_name and resume_name_len whenever a new response is
installed and when the rewind path releases the search buffer, so that
the name never outlives the buffer it points into, and reset
resume_key with them, since it was taken from the same entry and would
otherwise be sent with an empty name. A response without a usable
last entry then continues the search with an empty resume name rather
than a stale one; CIFSFindNext() skips the copy of a zero-length name
so that it never runs on the NULL pointer.

The next patch in the series leaves last_entry NULL for a response
that carries no entries, and bounds LastNameOffset against the
received response rather than against CIFSMaxBufSize. Responses that
are given a last entry today then take the path fixed here, so that
patch must not be applied without this one.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: b77d753c413e ("[CIFS] Check that last search entry resume key is valid")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 11 ++++++++++-
 fs/cifs/readdir.c |  3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5b1fb3216f238..6dc0b1793cbc7 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4465,6 +4465,9 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
 	psrch_inf->index_of_last_entry = 2 /* skip . and .. */ +
 		psrch_inf->entries_in_buffer;
+	psrch_inf->presume_name = NULL;
+	psrch_inf->resume_name_len = 0;
+	psrch_inf->resume_key = 0;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
 	if (CIFSMaxBufSize < lnoff) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
@@ -4528,7 +4531,10 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	name_len = psrch_inf->resume_name_len;
 	params += name_len;
 	if (name_len < PATH_MAX) {
-		memcpy(pSMB->ResumeFileName, psrch_inf->presume_name, name_len);
+		if (name_len) {
+			memcpy(pSMB->ResumeFileName,
+			       psrch_inf->presume_name, name_len);
+		}
 		byte_count += name_len;
 		/* 14 byte parm len above enough for 2 byte null terminator */
 		pSMB->ResumeFileName[name_len] = 0;
@@ -4583,6 +4589,9 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->endOfSearch = !!parms->EndofSearch;
 	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
 	psrch_inf->index_of_last_entry += psrch_inf->entries_in_buffer;
+	psrch_inf->presume_name = NULL;
+	psrch_inf->resume_name_len = 0;
+	psrch_inf->resume_key = 0;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
 	if (CIFSMaxBufSize < lnoff) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 7c47a03afbcc3..cf099fce9ba1a 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -766,6 +766,9 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 			cfile->srch_inf.ntwrk_buf_start = NULL;
 			cfile->srch_inf.srch_entries_start = NULL;
 			cfile->srch_inf.last_entry = NULL;
+			cfile->srch_inf.presume_name = NULL;
+			cfile->srch_inf.resume_name_len = 0;
+			cfile->srch_inf.resume_key = 0;
 		}
 		rc = initiate_cifs_search(xid, file, full_path);
 		if (rc) {
-- 
2.53.0




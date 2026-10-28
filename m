Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214301;
	b=D5IEVbjEoNTYaTA7GiIvT5LepqNIp+kHDJTCUQuN/6eZYSY/eXivZ/Lhd9PnzJII1hQl
	 Hy3wwDaAV4NKqcjWPXbNwa6LORoUAQCqRJ/U1GdhQ2MP1tJrrEKnujo/cUuJPVcRtemiX
	 3mgr0Aj18UnOpkZL3VR85UDEvofHoDcvVj8NRQ7TlG5QQoy7PFPDhZFM5Fk7ZjvRp4tOB
	 LxXpj6RIalvHrmMTwgKDBJm6EiSctZSS+TJhFggr60e+cPX8X3vGEIRssaO566ve6OnMp
	 1gvWwwE6BR+JXu/MoN63mfaIE5QZiyWj7mXuCVpt10IRJhNbqnVoVLjQlFzQkUs0Bhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kv12QhfMnJ8NICfUOPLx2KTjwKLyqQrYa9ZJcLO2fPc=;
	b=00w9i3wD1yXD1KVmZz3xee+CIcz6DQ7xrJjxugMnXPXMNrKf47zh8pgtSbzQITz0ahQP
	 btATRlUCmGeHxGHXL68UyU17LfpnvXFst89/26oMakVlKmPQZ4NAgq1KzgvbSryBI/RgL
	 J6wiuHRRdBVvFKxgbQTgdcvgzByA3Z5m8VbzmVMBYvb3wWHZHI4lrrARO5T2rA+kwFfVP
	 qv1bwUwc/v1mmTs4sOhaxiJXNdIIcUV13q0mqxvXa2U/SOLUexwiCToeJTMU3KrBCSduD
	 S8TS1v2i55sIN0K4OC0fYpJFlAJQ/+Y4ib/2Wv9p55UjmK82bz94c0Nc9/O49YmOSNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qQR8io/X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C41C606A334;
	Wed, 28 Oct 2026 19:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQR8io/X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1821F01825;
	Wed, 28 Oct 2026 19:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214300;
	bh=kv12QhfMnJ8NICfUOPLx2KTjwKLyqQrYa9ZJcLO2fPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQR8io/XknAjXPJFxfytahJN9V4bvEVG6LZrMPLHrPAyUwpCu8phRHOIsauUKCwfm
	 FBCiZn8HAkAXVRDM4d/OTG6IFrY41N+B6zzzg4atOeXY340uxudJtSwFSXLxiwuNUY
	 V2JfsuQj6AfReDappPOrqTSeBCPQvh26FtLEncOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Prusakowski <jprusakowski@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0767/1887] f2fs: fix potential deadloop in prepare_compress_overwrite()
Date: Wed, 28 Oct 2026 17:47:43 +0100
Message-ID: <20261028170516.893972776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 3147ee567dd9004a49826ddeaf0a4b12865d4409 ]

Jan Prusakowski reported a kernel hang issue as below:

When running xfstests on linux-next kernel (6.14.0-rc3, 6.12) I
encountered a problem in generic/475 test where fsstress process
gets blocked in __f2fs_write_data_pages() and the test hangs.
The options I used are:

MKFS_OPTIONS  -- -O compression -O extra_attr -O project_quota -O quota /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o discard,compress_extension=* /dev/vdc /vdc

INFO: task kworker/u8:0:11 blocked for more than 122 seconds.
      Not tainted 6.14.0-rc3-xfstests-lockdep #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:0    state:D stack:0     pid:11    tgid:11    ppid:2      task_flags:0x4208160 flags:0x00004000
Workqueue: writeback wb_workfn (flush-253:0)
Call Trace:
 <TASK>
 __schedule+0x309/0x8e0
 schedule+0x3a/0x100
 schedule_preempt_disabled+0x15/0x30
 __mutex_lock+0x59a/0xdb0
 __f2fs_write_data_pages+0x3ac/0x400
 do_writepages+0xe8/0x290
 __writeback_single_inode+0x5c/0x360
 writeback_sb_inodes+0x22f/0x570
 wb_writeback+0xb0/0x410
 wb_do_writeback+0x47/0x2f0
 wb_workfn+0x5a/0x1c0
 process_one_work+0x223/0x5b0
 worker_thread+0x1d5/0x3c0
 kthread+0xfd/0x230
 ret_from_fork+0x31/0x50
 ret_from_fork_asm+0x1a/0x30
 </TASK>

The root cause is: once generic/475 starts toload error table to dm
device, f2fs_prepare_compress_overwrite() will loop reading compressed
cluster pages due to IO error, meanwhile it has held .writepages lock,
it can block all other writeback tasks.

Let's fix this issue w/ below changes:
- add f2fs_handle_page_eio() in prepare_compress_overwrite() to
detect IO error.
- detect cp_error earler in f2fs_read_multi_pages().

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Reported-by: Jan Prusakowski <jprusakowski@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 1 +
 fs/f2fs/data.c     | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 5d0c41abb4050..de64a621c729b 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1123,6 +1123,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 		f2fs_compress_ctx_add_page(cc, page);
 
 		if (!PageUptodate(page)) {
+			f2fs_handle_page_eio(sbi, page_folio(page), DATA);
 release_and_retry:
 			f2fs_put_rpages(cc);
 			f2fs_unlock_rpages(cc, i + 1);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 082e09be4e8a9..6384ac931bb7d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2241,6 +2241,12 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 	int i;
 	int ret = 0;
 
+	if (unlikely(f2fs_cp_error(sbi))) {
+		ret = -EIO;
+		from_dnode = false;
+		goto out_put_dnode;
+	}
+
 	f2fs_bug_on(sbi, f2fs_cluster_is_empty(cc));
 
 	last_block_in_file = bytes_to_blks(inode,
-- 
2.53.0




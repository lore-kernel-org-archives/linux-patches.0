Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826777;
	b=NmTHswdCecwsVU4vxusrmN78pg2SmPSLuDXjXTCOhSEBfhgk+IcwxA3EIBb7NeQO0D47
	 TNH5eY7JPPra+uiGdbOimVXxIqhVgjbUZ382IhxpHuMsuEGs+hSxNZRnnEqE/7Qd1MqCh
	 NlTNgG+TePIe/kLcBO4UuKOLrFgE9HkK+duS6MMUwHM8If74Jg6/1M+z+Ca2Qu1Mz56j9
	 raZ5NBHD+L/CtmQtGyqZee4BxxIICBbwV2+DDHNFK+6G2Uhluuf2U0EUik2jGp0Vf2tKx
	 /Oihg6PRN7uHpIx0wwr3D2UpW262UjYHZUKgJIoN5poS2DKTXQPtmTovYNcVtmb5Lbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vzja69J4e8nfnsOBPuBZx4SIhyiiF9AlxVZmB0J7CAM=;
	b=wysxv2uV9fo2h80sTA3liUEfRFH/yOrXsS8qXHW814OAzs+AoTuDmTSQadoPDvIN5v3A
	 CNujhWirvuF19IGPnZTrMVqSnXZn/E1bTHWRZGvtBPLL/5cITeuGbnsKoFcyDKpunebdb
	 vHvpCkt1cmhlgRieEaLEahKF4Yw6NnDc3zul5wwWkT22yzv8xrfgOk5xiU3SYtx3a/Wwz
	 JYBif3ckXUnOner2psfK3rj60Mm1dJV9KnnSOJ+xtrV8gTV0kZyEfAstVrTJVk7i1Npj6
	 ihp7UTcNeWD5Rnu8xomnXBGpmzYX3Riyxj7qOpAVym35T2akLsBswj+mojbyRxX+5mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGwBy5mH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94816071AC1;
	Wed,  4 Nov 2026 21:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGwBy5mH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468741F00A16;
	Wed,  4 Nov 2026 21:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826776;
	bh=vzja69J4e8nfnsOBPuBZx4SIhyiiF9AlxVZmB0J7CAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGwBy5mHdr9Pw1a6Q1iid3TtClzazArnwJcwGUCFtwPLd0Iox+yMJ7RRhjTmtXaiu
	 sJyfFnvyEJpk+A0YTQ/+dILufUB77qWPXfuBsCC6JyzaoWvTCknKT2TtjgZcnPsAw6
	 6oHV7dh4VXUPTz+y6Ih06W/D7md7oHmc92FRWgdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Seong Hyeon <ihopenre@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 006/547] ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle
Date: Wed,  4 Nov 2026 16:03:10 -0500
Message-ID: <20261104211038.574549036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Seong Hyeon <ihopenre@gmail.com>

[ Upstream commit ef85bad39cf273a8377722c9f3078294dcc2fc7a ]

An authenticated client with a writable tree connection can open a
directory with FILE_WRITE_DATA and send FSCTL_SET_ZERO_DATA on that
handle. The handler only checks fp->daccess & FILE_WRITE_DATA_LE, but on
a directory FILE_WRITE_DATA is the legitimate add-file right, so the
check passes. ksmbd_vfs_zero_data() then calls kernel_write() on the
directory file, which has no FMODE_WRITE, and __kernel_write_iter()
hits WARN_ON_ONCE(!(file->f_mode & FMODE_WRITE)), panicking a
panic_on_warn kernel.

Before commit 25e414db7033 ("ksmbd: report holes in allocated range
queries") the dense-file path used vfs_fallocate(), which rejects
directories with -EISDIR. The kernel_write() loop that replaced it has
no such check. Reject a directory handle in ksmbd_vfs_zero_data() before
writing, as ksmbd_vfs_write() already does for SMB2_WRITE.

  WARNING: fs/read_write.c:608 at __kernel_write_iter+0x74b/0x8c0
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   kernel_write+0x1ef/0x4d0
   ksmbd_vfs_zero_data+0x413/0x590
   smb2_ioctl+0x21fa/0x66a0
   handle_ksmbd_work+0x61b/0x1ff0

Fixes: 25e414db7033 ("ksmbd: report holes in allocated range queries")
Signed-off-by: Lee Seong Hyeon <ihopenre@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index c2c9aaa5de1b5..bb1cab471d4c8 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -955,6 +955,15 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
 	char *zero_buf = NULL;
 	int err;
 
+	/*
+	 * A directory handle can hold FILE_WRITE_DATA (the add-file right),
+	 * so the caller access check does not exclude it. Writing zeroes to a
+	 * directory makes no sense and kernel_write() would warn on the
+	 * directory file (no FMODE_WRITE), so reject it here.
+	 */
+	if (S_ISDIR(file_inode(fp->filp)->i_mode))
+		return -EINVAL;
+
 	smb_break_all_levII_oplock(work, fp, 1);
 	if (!work->tcon->posix_extensions) {
 		loff_t size = i_size_read(file_inode(fp->filp));
-- 
2.53.0




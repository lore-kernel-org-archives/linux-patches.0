Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060999;
	b=FOw3CvUGkyLjm/gWCE2UOobNqzJDWTepbZU3QdkTv+FVz+NrnzvofahNLE6Vz2dmUiIY
	 TNtReieiUCoicN+fAwL1tPjAhjFipUmauwRfglKc5onmMegsRX+C86RspYVTGCcDoEliA
	 /tQDxE5rrBhN8Q38bVUFicKs4vsY1oKM3/2WfdysqJUo2HMoID+nue8AN1JmchoDPmvMo
	 tdNo+QQbu0H7r9Om6VCKf2x09J1AyJI6MzeydV1xOyMvklfvNnQxGlRq3Nz73wgz8Que7
	 o04OrwlMaISjldOc2Q4mcltrCVRr3RfQCjNzGcs84jLfUfS9AYbClXiv0Ydi0IbyMWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CxB0eyWAdOK1mzUzhCCy+eXIjfh/x4I+Mc+rZIXeJhI=;
	b=DHN5iRdgh9ELA2zdhLehQjjnWq0kbb5iFI7r+fybyoRG1gvQ/FYPXiG21l+lrCqB9YJ3
	 Xam4b0mbNYDUA9gnaNqz4zQjgWbxg4wYDq1+FtNF9+nf0qKnvn1FcI9xok1bN4wJBH3z+
	 hi2jgmSbIOUKlA3bnIBIYdAjGeWQJYYmTHg0y38Qhnf/rYTW8zIfJ861IrfVfXFbOtTks
	 ZKmk94CsnAlbSMLbrD6CXMXLl/xOMmSo85WF9edkW0yMuzUj/8wd+w/25HtjZcKMDqkCI
	 fJUj3b+I5OO8dRMVZobLBDKuPnrfKZ2rNtNv4EnvvdovW4+7O0d9Am/YdTZ9WxTkt4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FX8QTqAc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BF5606D827;
	Sat,  7 Nov 2026 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FX8QTqAc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0A71F008A2;
	Sat,  7 Nov 2026 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060998;
	bh=CxB0eyWAdOK1mzUzhCCy+eXIjfh/x4I+Mc+rZIXeJhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FX8QTqAcc/WsQM6JkmFfwhCr1ETZfwGd4+BPqFCaJxmcuQpWxKWDumJKKkUuIDojP
	 0cd15MBaoe7ZGcMe6FwRObQo6BqkZEdKThrepbCXJT2gq2YJjYDWVcYwxhZsqxQYZA
	 M99itFA2GbpBGbjPzB/fgrMKj19yWjjVA00A1mp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0345/1536] ksmbd: honor byte-range locks for zero data
Date: Sat,  7 Nov 2026 08:39:21 -0500
Message-ID: <20261107135007.368695725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 8b57448a147d2378088e63cd473e7f2a967d6802 ]

FSCTL_SET_ZERO_DATA changes file allocation state and must respect
byte-range locks over the affected part of the file. Check the requested
range, clipped to EOF, before issuing the fallocate operation.

Return STATUS_FILE_LOCK_CONFLICT when the range conflicts with an
existing lock. Ranges starting past EOF are left untouched by the lock
check so they continue to succeed.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c |  7 ++++++-
 fs/smb/server/vfs.c     | 12 ++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2c74e0fd82b9a..f95487b25b664 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8621,8 +8621,13 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 			ret = ksmbd_vfs_zero_data(work, fp, off, len);
 			ksmbd_fd_put(work, fp);
-			if (ret < 0)
+			if (ret == -EAGAIN) {
+				rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
+				ret = 0;
 				goto out;
+			} else if (ret < 0) {
+				goto out;
+			}
 		}
 		break;
 	}
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 9b973d7064988..32ef9618a4af6 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1000,6 +1000,18 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
 	int err;
 
 	smb_break_all_levII_oplock(work, fp, 1);
+	if (!work->tcon->posix_extensions) {
+		loff_t size = i_size_read(file_inode(fp->filp));
+
+		if (off < size) {
+			err = check_lock_range(fp->filp, off,
+					       min(off + len, size) - 1,
+					       WRITE);
+			if (err)
+				return -EAGAIN;
+		}
+	}
+
 	saved_cred = override_creds(fp->filp->f_cred);
 	if (fp->f_ci->m_fattr & FILE_ATTRIBUTE_SPARSE_FILE_LE)
 		err = vfs_fallocate(fp->filp,
-- 
2.53.0




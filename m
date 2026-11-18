Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034333;
	b=uwZYJhog6sQYWLdoUKpNb9A0UVircolDlRf24OGeVl9c7k7P+4OKzQw6SeeuqyUMcb48
	 zminZppoY+BpNxZc8J5x2igfwAMAfzyeaO5d+mAthNzzzNcoz0GVnt8rYQKPz2avsv7UB
	 L/DqgIR6/7Z/c2iZS2VMzcfquAwC479Sp8yzYsjX8zlJSKPwWKFn55PGdq+NCcGnz447P
	 UWkpFVPYeJ7NhXIxdT9HiHbcNwFKTh5scrwxC4cxMJtsW47ccjXk4xQh3LqPlEn1wcxgf
	 /8gwKDxoco0WE9Imd3ibcc0S2SmBheBujgL1+D6jhFA3y+yVPZyEbydmWM6GQgwDROg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Z4PH4ueJjPj+mB1vdO3+5jiwbbiBJaHbcz/Kz+H8Dw=;
	b=BfueC7y6aGb0KpdswcwJKROlsMRb/S5JZAXZ0BkGrGSQliKaqiA9NTYEkns/4isZZ/ic
	 LIo01LOqPagjaP5FuA4WjZ+kUjC49DlOWYtN8i/ahNNPVnCCQZ65z/vcoyjEs6GumTJ/C
	 LjOUpNmYJUZWorodpqE156vCmXqcL6fxl7xd0NJBW04FwwewXNTmyapOIGmCWHoBsqWNw
	 CB22jXGgMHl18fgFp3SqiEUvwyrxpkFXdAeUOcsDfRutP+w4mOmh7YjVK87i1lYAMQjsO
	 gkf5FdCwMS+vZ6g8WewniE821oFelO/toJPFLKPDZg0RDMMx5sUIoKc85UC+yDVCcfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxyJHMRE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6FF606A31C;
	Wed, 18 Nov 2026 20:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxyJHMRE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD791F000C4;
	Wed, 18 Nov 2026 20:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034333;
	bh=1Z4PH4ueJjPj+mB1vdO3+5jiwbbiBJaHbcz/Kz+H8Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxyJHMRElj2+7PcMWBLYLyfMsdgSHcycHZRaja6wxIz7Yu+IBBupaFlVDM0G6+KQI
	 Rcyfk4kZmW62UZgXCL2tJMTcI7f2cVBK1GFcRkM06uNkE8xfdFL4lFku+ontSXUk+W
	 9pR1LdIw+nJ73AoOJJfYxjoFBTnaglE1TL2NS/Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0291/3318] ksmbd: honor byte-range locks for zero data
Date: Wed, 18 Nov 2026 15:15:13 +0100
Message-ID: <20261118150324.341425172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b22780a5bde75..07cd069d2ec47 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8601,8 +8601,13 @@ int smb2_ioctl(struct ksmbd_work *work)
 
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
index 9b0accb224721..86cd9e0481cd4 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -996,6 +996,18 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
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




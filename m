Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043541;
	b=WC4fM0RoEAD+sJ06OM/Y1hZPuCRxANVivghnIljDYs/tLTXEDUR481SukSLhOpR0s0uk
	 If8vvuv0tscInll/JbvoKWBBm+MtdjYSrEsoajsIC6PApNzhoBSvas0akPnyigrmVpiGr
	 CK6AIYLO97x4yZKfvwjmpn+Cssscfhf0G37gbHwPJj7mqiuy8jGdCGLG/uxaEfMbdOS8B
	 PzdVtWu9o50gYInVeEvZnFdrBSmjNNRL+ZInTAcpqFNySrMvBRsGrlGyC629VV4KFqaHS
	 i5bMRr5QL+Ol6Qt9g33DT28+/kMNR90wLK81gl0CEe4aMmMRK1VWgO7Pz+AZo+iohVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i6LBmMqF/zHRUWXwzpjSs7/1nnnkn64JhRvCyVtUr/o=;
	b=0BWr/Dz1YDlAX2NobBcWzCaJwmjgdrtPKtQsDYKMIPD9PryeemaecxKhvd8tl825EQ4B
	 us8+xntUchG7PskoT7+S/vsycRYGRVXHEiON4Mx4AX1C81MakgykPc+7pEKAR4OSTjkvt
	 pB6ftomWcON5Trk1v8K/wK4dUDXO86iZQShLyKAxA7m1f0Yta9KUmhmZAg4DB+tiAxGpw
	 VRGn6KPDfCOVnvRGg117KgZM8U9DZDacW5uBnj/yMWBPIbD3QWNcXi92FKxB88UKW6Iz2
	 7z4MHroql+s5kg8aGcInQhCiBpBUz+PrmD6cd5kWyU3eZ9IZnmMRIYoFa4CX9oVvwsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDbRxkJf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942D9606A32A;
	Wed, 18 Nov 2026 23:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDbRxkJf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEC91F000C4;
	Wed, 18 Nov 2026 23:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043541;
	bh=i6LBmMqF/zHRUWXwzpjSs7/1nnnkn64JhRvCyVtUr/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDbRxkJfpTBN4LBsAKHpg/gHDJLl4kS4XkXWorIdivJtUcpiVZOUKhG0XMY6sVvVB
	 7ZdttGP0K01LSTq4Dt5636KdeW9MpnmxtlobPET+IZldmGDWjv7+PLjLJ3z1RxXSCZ
	 SsqPnPrM1c6L4DiCX6EQ6nd1fGxIu8fGeSmTxBow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0248/2857] ksmbd: honor byte-range locks for zero data
Date: Wed, 18 Nov 2026 15:21:22 +0100
Message-ID: <20261118150210.370487923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 2a7b5fb185dda..0ad2e442e78eb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8158,8 +8158,13 @@ int smb2_ioctl(struct ksmbd_work *work)
 
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
index a1ab487d2c09a..5b335743c43b9 100644
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




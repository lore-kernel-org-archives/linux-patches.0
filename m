Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830935;
	b=jHQ34OQdztmfbO2u/N1BHXw7NWoL/QNm2JLTHJbJ2GmsXIVb2Bqu8WsYm0sDJp5rbkNY
	 GqMZWo6FEOYwA4c8evAaWFRMcYXYffR9v/xTmtfyuh7cAjNeEJjAJmvZ/fvFmJoxk9xbO
	 +ww6WiYhybTe13jYTAhB6y3T6ALivMWy0vvR1Vjx3fN6c0/s5HBxJzX/yhkKGUOPMiAVW
	 7uNX2tPvc0N084p5HJl9DSxoPzLrU6wzN14ptLR7XkNOBmi6x47UaoX+Rpueo+1Ezkzv+
	 lT7iLPKxyhUW9Y+5OG850EMX8vMJdmFb5YKg8JGgCBSoeeEGldKYk2dR6G7FDSg1Ntw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fO8PHXeXu4k9pvdseydPbQm39rkX0cw39Lxnhmd30hA=;
	b=OkHJnqoXsrETLBXux94fLEAMeUQufbdJeZ4M5LqvjfJzcnswg7NCT3jDPGZlv2X1ohOZ
	 4WNft0dxbGqC6oMSCdurqaAqATZdVxBdS0MQy+mwInQ6SgGiFPY+EJWoDztyrYXPCWb+C
	 Heh4bomo5svs7DIp9VKwkrSbay2nKWVUX2/1Oxlrfp0hMfl0Mc1falD/5W1nVNR1Desrx
	 may5ZApSF1Ot+gty+Pok2BSQrS4ULs0mYJG7UljP/KRgeEAmhrgrGkUe7QbN3soLOo/+r
	 jaFVIzpDu5zbz+mmDG1JW5uil/FUvS2t4S/qo+g9qezHOdShigPSSM9WwAQ6ZMk1Lcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxS6KSP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E346606A858;
	Wed,  4 Nov 2026 22:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxS6KSP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86ED1F0093A;
	Wed,  4 Nov 2026 22:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830935;
	bh=fO8PHXeXu4k9pvdseydPbQm39rkX0cw39Lxnhmd30hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxS6KSP+VeDPZtU8hg4fBLd/jENhM/vrwemUnV9voQcTI5k5xFJBC8z0v85jBMf17
	 FTmdIFK6UatxSjStU6mAEmcRlxEqOf0xbCpjo9orjdhTAvdolPIytmMkmapzN94V2l
	 x5i1PQ1tM57rtqj0PGabt2FIVeX6Bx3CwTjCJAdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0411/1005] ksmbd: honor byte-range locks for zero data
Date: Wed,  4 Nov 2026 16:02:24 -0500
Message-ID: <20261104211055.592866706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 84fcd84d6a666..86535283b49a6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8670,8 +8670,13 @@ int smb2_ioctl(struct ksmbd_work *work)
 
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
index 47c289ad9c3dc..f894092901bc5 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1003,6 +1003,18 @@ int ksmbd_vfs_zero_data(struct ksmbd_work *work, struct ksmbd_file *fp,
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




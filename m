Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034328;
	b=A4/k+yHrn+fbfdo3irBUZF8wV7Eg0hOXYfE/fPO4pTsAbRX49GOs3aT1869YqWOS4j52
	 QE2k6uvBKn2g8FPka+i4pfY3yMtzYFMJwomou0TepMZLNOclvFu6FHROI5N8uA2KBVgbb
	 YoWa2SSlOBTJaPyefjiBY/BRYDkgbGAS6yitdgEtVHt0P7swmcFs3oR9OedgdMLhOrPts
	 DYklRDiZa+3Azvj7TgchtBbPyqTLt9BXnxTtIlztq6gNTJyArwdfwRBo44q06LRwzB6k9
	 KG6f6ucrLkz3CzP7zCMdfl68RME2YboVSHlr92dvsUuOcPCRsdqe2GTMcR1J6HYrmRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Tm0o1yb91oei2xVXiY9ix+wRyQJ/V/oeVjRoErhrKA=;
	b=pIcBLsoS5JPvlQWObZRYkaSFlYmjugIAic5y+8U2QruuQIcOnIt5ig+pR75AAm0Z/4Mg
	 Xvwhoh26AalDycyggTQm7SUFFE8Ke58KzB7knRgu5J8N1JupyFQr7gsaMJ/+ITxprkvDl
	 9jJNTbChCCcD7kVcjMKSPz3P4fL8pU6sw2I8b0K3IrFUYTVKJiKbfGcOjwDvO3svEbY9S
	 jwyoG+K7sbEl8zIn3yzfmchbYubtxMEzMCm3XNpfGbuubxSs/14iwpM19TdGewlUO8BHZ
	 SbQ3T9lsLYC0dBk+MlUjuazC0WEErhuxmi98S9pUJAsymyHMaWoMtcuUAiNQyy2nEuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xBlyxXOK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0965606A31C;
	Wed, 18 Nov 2026 20:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xBlyxXOK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423611F000C4;
	Wed, 18 Nov 2026 20:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034327;
	bh=3Tm0o1yb91oei2xVXiY9ix+wRyQJ/V/oeVjRoErhrKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBlyxXOKbp8Do8hHpQ2BvoWN+cWjwapZTftjQWf3CXu+fr/RRTB/pBFs4IGnLmIkM
	 ZERtA6zHABfCoPp+x899napNDeWEX/lnN2bgh9Kf8jUthbfvEQHNeIbsvo9LCaskmv
	 iYV/HFQ/624RZGK/YYztoNkAYQdEqeaWhRHCThcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0289/3318] ksmbd: return buffer too small for short security queries
Date: Wed, 18 Nov 2026 15:15:11 +0100
Message-ID: <20261118150324.264219097@linuxfoundation.org>
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

[ Upstream commit 2103add92a02505bdd536ba6fce7f64a427222a2 ]

SMB2 QUERY_INFO security requests with an output buffer too small for
the self-relative security descriptor header can fall through descriptor
construction and be reported as STATUS_INVALID_INFO_CLASS.

After validating the file handle, reject buffers shorter than struct
smb_ntsd with STATUS_BUFFER_TOO_SMALL before building the descriptor.

This fixes smb2.getinfo.qsec_buffercheck.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d52e1f1aeff59..986513090276b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5865,6 +5865,12 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	if (!fp)
 		return -ENOENT;
 
+	if (le32_to_cpu(req->OutputBufferLength) < sizeof(struct smb_ntsd)) {
+		rsp->hdr.Status = STATUS_BUFFER_TOO_SMALL;
+		ksmbd_fd_put(work, fp);
+		return -ENOSPC;
+	}
+
 	idmap = file_mnt_idmap(fp->filp);
 	inode = file_inode(fp->filp);
 	ksmbd_acls_fattr(&fattr, idmap, inode);
-- 
2.53.0




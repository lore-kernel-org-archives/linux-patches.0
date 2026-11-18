Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046114;
	b=MNDJXGMZsD70BPWo0Y9L9iamCAAqrDihEovVu7t9G6gpRxAW9+bhyyWwtRSmfBxvD2sj
	 lBYh51OWgQFd4xG3iWYltAfpRg8Odbgfc07GgWBF5TPX/bmnOYZdWwOwymSke0rxcyXi3
	 e5EFwh2CHaZ6tMdpcAr5Q7Pvo5fT6HBYBwfBuEunQ8/XpmuIZeHRYhHxjIpq6TpK1iZHr
	 Gfl7uTCbbvvXkPUTJJIr5qU6I4i1l76EIvr5qbwtJXYw4qnlHMbFw9vsoBg7P3pQpLTb9
	 Z4SgMx/BhPA0t6iUrdaT/gOCJlUNBxOGNgR/rRn6VUbSeM7+UsKMvmDdysmb7asnV7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Au2Mt07FjGG5hk/+FYTagFAytGwXRZLN01eC/8Y3gkE=;
	b=draE3qIlJL4ZxEJnAFGjYX+/Qe5iquMsekhcr0ZCqAw9kRNnuSBsUeDUXmHamSo4I3wx
	 3jCuQOWP0FYt2QNGvMdShFap/ixbSaKkr5qOT0Qz7oSzRQn/qtquoOJtvupmuG3Hw1N8A
	 SMiuKgbQTTSp0GvSA7KQTSfdq7ZUpOXe07rVc+giRTb7V95qkodUk0l3RCI9tgToHBCvL
	 8NMewpxjReYHv5ddRo+b2ppPwMinx71eZflb9znOy2SSn2V7M8kcIEJxwflCfn1L/1Zfc
	 Q6SU9IMr7kKuhxr4/RZf1oDRjXybCgSO0JYKOWrfSYHSTDGLxO8PwNoa2gQsqXp86/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T/ozHyDq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101AD606A31C;
	Wed, 18 Nov 2026 23:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T/ozHyDq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1CD1F000C4;
	Wed, 18 Nov 2026 23:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046113;
	bh=Au2Mt07FjGG5hk/+FYTagFAytGwXRZLN01eC/8Y3gkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/ozHyDqskWQD2OK1FAHNqqJcnnwVxPDtD4EN5/GqW42IBqQl523376lmTy7Cv4P8
	 YrJB7ZHTpxGGSmQ8CAmg3oKI4OkAY6xaUSYkDh9Qag1cGl9SuU7enRsLrDWhdUb0c8
	 Hp2GDfCSx43H/8GvQt0BlYC5t62hJmYBWKhGTXMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1124/2857] smb: client: bound POSIX lock data area by response length
Date: Wed, 18 Nov 2026 15:35:58 +0100
Message-ID: <20261118150242.083016293@linuxfoundation.org>
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

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

[ Upstream commit 8fc9af68c57156ff64769f30e831553cd03b3000 ]

CIFSSMBPosixLock() receives a TRANS2 response whose server-provided
DataOffset and DataCount are not required by validate_t2() to describe an
interval inside the response. A server can therefore make the client read a
cifs_posix_lock beyond the response buffer and return those kernel bytes
through F_GETLK.

Use smbCalcSize() to obtain the full response length after any multipart
TRANS2 reassembly, then reject data areas that extend past it before
dereferencing them.

Fixes: fc94cdb94462 ("[CIFS] Fix new POSIX Locking for setting lock_type correctly on unlock")
Reported-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: subtracted 4 bytes from smbCalcSize() and replaced smb_EIO2() tracing with plain -EIO ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 531502df79970..a64a1f44300c4 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2052,6 +2052,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
+		unsigned int rsp_len;
 		__u16 data_offset;
 		__u16 data_count;
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -2062,10 +2063,16 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 		data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 		data_count  = le16_to_cpu(pSMBr->t2.DataCount);
+		rsp_len = smbCalcSize(&pSMBr->hdr) - 4;
 		if (data_count < sizeof(struct cifs_posix_lock)) {
 			rc = -EIO;
 			goto plk_err_exit;
 		}
+		if (data_offset > rsp_len ||
+		    data_count > rsp_len - data_offset) {
+			rc = -EIO;
+			goto plk_err_exit;
+		}
 		parm_data = (struct cifs_posix_lock *)
 			((char *)&pSMBr->hdr.Protocol + data_offset);
 		if (parm_data->lock_type == cpu_to_le16(CIFS_UNLCK))
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590814;
	b=cGzXCNMtjgvTyUDifxMSFd+tHD8FO+fHm1YRC4/AK7BMidJZFL+g2MrvJc+Bpf+fGHmu
	 IrwKMs8bF45oCe33ZbTLl5zR0mVQWiSTSdtA9VJQOUeelGCa4jVaM+zK0HGG1KjOlMMdD
	 84bUReWaWUeu6Xg50c795psRMNK0x1Y0ZekAHf9a/mxvoKtcBstP9LMZDwwbBjVtCzV0Y
	 eNbR+qQD3SnEsxWNl/RW3vBxw9kBjuVMMKCP8gANsBNb2/sWAaPAyu7XIhXZ3LOSFUKo4
	 EI/0YyIL6/UAaLxv9E5Pl3cidUawUg5iZQYC8dXYFLGRPJ6Mi6T1wOmZwD84UBmiekA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eDWn+vu4QjKKYjQjx8jn4hmljKjuaTSPTHK0mExH5j8=;
	b=vuiaxEKOHxNlu3xl+4A7gWiVXVov3Ye4Rpfz7emGi5OVONg2uo8WcWYgV2vzyfpzlila
	 PIBPh1Monl3ZHJTTJCrcxXHG1fOLgKZa1QeQrPHjQxxuYwxzmO3C/1Viln09n0RwL0jzF
	 h5eUT8uYwZlQhgu/KTG4V7PaMgVk0zkzedTTwnwnti1TcCMYwjQAS/GnKObVv2tWy17g7
	 gm7n4oqG8uyL2UnxswWkXTVumt80s2+F7LOpdnZ2TRWzaDma7DUGNfPo0jASc2m6byRO0
	 APfZuyJ+76SVT72Bly6gNhxCZ+F2AESyWaEJU/UFfFFGjVa+qYP96lP7TlTVNzXroqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWHw4oHx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D509E606D485;
	Fri, 13 Nov 2026 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWHw4oHx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ACA1F000C4;
	Fri, 13 Nov 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590814;
	bh=eDWn+vu4QjKKYjQjx8jn4hmljKjuaTSPTHK0mExH5j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWHw4oHxwVi86Bjc2rx7SsyGckjHo98WAd87gx5uLhqS+dCmUf/rsii4ds9FuVbxp
	 5AMYXPsjvsotUph+rtHLLLevSS5bojYPZGWTRflwkjsHF7zp0jRDTI40s1HvqBUgpY
	 LH3DZDN9n0zpcqOdwzNQyK2j9u2Ox2JZBtm5iLVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/670] smb: client: bound POSIX lock data area by response length
Date: Fri, 13 Nov 2026 10:43:07 -0500
Message-ID: <20261113153811.974030655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Subtracted the four-byte RFC1001 prefix from smbCalcSize() and replaced unavailable smb_EIO2() tracing with -EIO. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 1c2b73bdef6cb..8062b0328e07d 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2092,6 +2092,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
+		unsigned int rsp_len;
 		__u16 data_offset;
 		__u16 data_count;
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -2102,10 +2103,16 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
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




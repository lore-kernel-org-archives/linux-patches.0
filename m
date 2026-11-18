Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058833;
	b=j6eWit42xX0KLLcC5NUlliHTENLD/1YnWWYc6PKF3bY82b4PtbomzZc9aZtMcYY0wMtW
	 HVWTJAoWpKMEvxztwo7U4Q/deU40c/JxX4lJy2AgVFvTp+U+GMg4zIUDhC8Vir75n2/e7
	 dajS6Qc+m3S1Gv40AVX+SVlW02fQuRDKNwTK9uNZAfRgmZVBrm+VYBhVsCBX5Gfqm5L5W
	 svQyl4V6MyUyfok6WTv/rVsmhevh3ZtE3XoXtmQ5x6jk3dNGUeylugKcCJjsO1PbB/xFD
	 Sei9Rz1v8GHGx3b8JJoqegcAKd/aEg2GRlY0gyNI/QBxGt1CCcrUEHZy3+mI0Vgr0GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IWMybl0FNhrDpyysBlA4VNKWxPtuxJmEAf9F0QiaEVU=;
	b=m3kw9gXsfTYW4yK0akT+wr9Fh9HwG4Ar/TzaPCn7Yo5rFHkIrKkNhABk5opGee171qP1
	 R0wHuEqM/2uzeiekZcEqkQkrpjKixaDJlY7VxhtbFRDiqlxtQkfPJgulosC+fFmS9JqBi
	 dVJoXkqs7Z3U4oHmkXnSuyS7mzJtTVUQfu41SyxaLM8TPCV9gImHysFRPprOAwY8wkcLv
	 biezlmB7WPiZtFCnPZ6BIZVSBOPU7IqkliGRUHgezF5c1fv3JKoUsLBTM3zKPIu75UBvP
	 THX2rHhBiv7ZSQO19TH2mJqEyh0mK/+4EySaEoCJXUEMiF8v+bt/uxTdDE1KAANN4qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J3mQqTb/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CDB606A332;
	Thu, 19 Nov 2026 03:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J3mQqTb/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879331F000C4;
	Thu, 19 Nov 2026 03:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058833;
	bh=IWMybl0FNhrDpyysBlA4VNKWxPtuxJmEAf9F0QiaEVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3mQqTb/K9MRRzAsiqo6oGh8KvFtjiNF41nP2excNRzOlzwtTcwZ1Zk6GZcJkdeq3
	 eEgh2PxFI5Xncs6JHWZxLmT6WQ7cnox0kMc5Ej9J1AL/B+9S8tKYx5QvQq+JHKEn0z
	 GaczQja8++rlsIFglAlt2Hgs/gZ4S04oPLhPk6Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0628/1848] smb: client: bound POSIX lock data area by response length
Date: Wed, 18 Nov 2026 15:44:26 +0100
Message-ID: <20261118145941.845586213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted response validation to subtract the 4-byte header from smbCalcSize() and use plain -EIO instead of traced errors ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d61effb5fef37..3de0c2ae3d510 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2592,6 +2592,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
+		unsigned int rsp_len;
 		__u16 data_offset;
 		__u16 data_count;
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -2602,10 +2603,16 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
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




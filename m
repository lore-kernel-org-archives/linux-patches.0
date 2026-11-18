Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053052;
	b=TKaB5HU+5q/ma3wK3N3XfCojgqYtXki2nKb4CnwL/bCv3Pz32IpRnMA2uafk3ICYGd9U
	 6P9GjjyC2AGyb4Q2xHV/+8ABhjcXVEEAavfLCxUdZLJOYKGojaYjcUBWzOdewkKF44VEm
	 ijzEjJLkSgecvIJ6iyCGg/aJ2jAPDbpAeInESMCII/aKXGnKZ+w/Xac22ZQv9YaZlo0EV
	 L/+3ZAwQFBZEhwiMlQLYKF6s5KNGgy8iBv64luH0yoJmAZoGSFBtC510BeYh08uI15j5O
	 8UIDJxE+BKMJ07NdNQgSH1zczaZI/Fft3QNwVhwg9sIpCzHm3yTGJil8IvAdFz9B2bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wA3ClDiP6+HF/B2NDJbCntx2F3c0JevwB3bJ6NgsEvY=;
	b=cteodE7dlAE+1sYtli+c48s2UQMX7PIGa9xQAwh8vaQokdEfe77dVHgPIWFEYHSum7J6
	 MFgJcUWnVmh1oyIS6FHeHpXgezBTg0Ub8wIAObdXytvGktsJKsUhr8rhC9SStAIfPQ5Hf
	 GeK5C1FBSCJ8uP2+bl677oiPEUszNbkqcNOaKzCTNWNGurl97GehEsGXDSdGSdPl5sSdg
	 g6/f73n/H3ECBKKXnOir4in8GI9fTSBFwYggw1eXNAJIX1kgqqJwdpF2l95JrDyQJVMVS
	 FUdJHRam0wFtqO+6GxRrjQUm/2xB2AR3KMDq8UkMxJ5KGIx33uxdqrUR+LZeqZljjCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAvitQGD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EE2606A31C;
	Thu, 19 Nov 2026 01:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAvitQGD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C531F000C5;
	Thu, 19 Nov 2026 01:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053051;
	bh=wA3ClDiP6+HF/B2NDJbCntx2F3c0JevwB3bJ6NgsEvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAvitQGDvWrGVzAsX38AFQ3vC2BBmZZAamSaYZiDgX/Xhv5aGHDB4SpHngRzzlHuZ
	 k7yuMh1nQL8XbX9c4L++3q/lVpccbhOC1l7gnKCmf/TF9qFcCGR8rlAZcV8obZ82hP
	 36uNoKtpDDfJZ/nerO5aIVWo3G6ypXY6NCqG0Rko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0780/2214] smb: client: bound POSIX lock data area by response length
Date: Wed, 18 Nov 2026 15:40:56 +0100
Message-ID: <20261118150042.827987877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Subtracted the four-byte transport prefix from smbCalcSize() to match protocol-relative offsets. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2a085d4e99c5d..11f526118409b 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2481,6 +2481,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
+		unsigned int rsp_len;
 		__u16 data_offset;
 		__u16 data_count;
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -2491,10 +2492,16 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
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




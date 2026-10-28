Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210865;
	b=laYVIgEH+bZJBvXIHJAJauyGn0ltwQFBOQpWgTZAnAR2IlTcxbtGUKCBf4HEh8SnYTuK
	 ro/afvMn1LFijwofEsl3UVtDwcWiRzJhQPpSP+ZRErrocSPal1z3zUEsc4P2Ne9Y1/CgU
	 ud8jYEMRABMq2uLirsmYzWTl9kxuHJVRAaq8HTcEnUoNqhB5v1z6TgiD7REJgCebLRoDN
	 2vnh3MZ4l9h1jKGNijuTpZ09EYUPH8PJV83zRPyXXLqaM94JFW08Cq2kIEFJmfR+2kjBI
	 F9zvCju0W7umiLqpUhckl4TxCge13KGSKpsdj5nFFyp3xq/Isjskk0kLjH3ngmz5ibw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MUr5MvBSWm1yQxrVg/145mfzAvJkoF8A72wdnaCscj4=;
	b=S9pHlK45x6vvYnWLNdQXVeH6fcdDZYEKM7DoSkFFLQR+5vXLJ36+j9Urq/80UCAn2e/C
	 h2TL84Yrard7vBKOgXRcOmgM62/kQEETUyM0G3gjs3VW6xOcwkhNbg5KpdwqznBaImDob
	 8ST31hxm5KUaKyxTGp8wB3R/E2EmhQe+yr1J+dzUBQJ3sqa7NHTi1dL9HklpXdgvEN7yk
	 bYnUrpQEFGTWn184FrSdp8QcKHCdCnji5ImsZCuGbuHho4hJSsFre584byFTCgTm4IBF/
	 LfVCM4LOZwZNCvNGk810YMBJHCYYpJbSD2DacLV/yQRpw7o3Y5B5TI6QTN2PB5aUCgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcAs2XuA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45D606A336;
	Wed, 28 Oct 2026 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcAs2XuA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35101F01828;
	Wed, 28 Oct 2026 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210865;
	bh=MUr5MvBSWm1yQxrVg/145mfzAvJkoF8A72wdnaCscj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcAs2XuALjNAYFcMqM+XukIEvylq8Hy2B0PD/TzzQXlebYOVY666TOJFolq2/ApVD
	 FIuERvDO+VEtxtlp1Q5NiTmGp9VYtQwmahiPIZzVu79fx2aTinn/Os+A+RIx6XKEsC
	 JN/LMbyqd7eoZX+DeTpiNOBEEGzYjw5hSeKQ0vTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/571] smb: client: close handle after create-context parsing failure
Date: Wed, 28 Oct 2026 17:54:39 +0100
Message-ID: <20261028170011.150078169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit 566820af017e81497fb5e9d3ad6e7ffe2828bc8b ]

SMB2_open() accounts a successful CREATE response as a remote open before
parsing its create contexts.  If smb2_parse_contexts() rejects malformed
context data, SMB2_open() returns without closing the handle, leaving the
server-side handle open and num_remote_opens elevated.

Close the handle after a post-CREATE context parsing failure so the error
path releases the remote resource and balances the open count.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8ed13e21a8480..2c7bcb768a64f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3034,6 +3034,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
 				 oparms->fid->lease_key, oplock, file_info, posix);
+	if (rc)
+		SMB2_close(xid, tcon, oparms->fid->persistent_fid,
+			   oparms->fid->volatile_fid);
 
 	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
 			     oparms->create_options, oparms->desired_access);
-- 
2.53.0




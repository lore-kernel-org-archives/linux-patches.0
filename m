Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060996;
	b=vIltFARriG9uMBWa/4S/GhhUNwwr+dZuCvaPwE79+Mfp5DAxMduoNlF+NtWd3kZvaN5A
	 d926IGSpGumA1ZDxW1adJf3uNPiBSlJmxmVr0qJH8fbtqr2IAjNiVGP/pfrMKLy3r1Tp6
	 nvUnI8b7ZH/Yl8ohqlg+H88AIllsYWD+kDq8l5ug9/tL1uu1ww/lrGvto/kRMh63gp2yH
	 EE8kQYTpCHUbEs1K3Ch7SjAsdecE9KW10xzXfY8KjvHYS4pOjqD7rupOo7FkAYTWektKo
	 7ToQGqpFy0D1/Cpq4GwddesDnagjvWHHYtJi+2Fwdr6R9K3utgjdMcfq6OBP2rUkRQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mj4SnWIfhsH3h6bnZbq/79454WUcfLr9Vwmm/Qr3rAc=;
	b=JhskdOLvwpbwYrHFW8GnTtRRFEQJuEqfX0SrqzZKZ/Oz5dtrKlwoqku8UrkC7eikJguV
	 ZPSC10BuxcfkrFBr8We3P8++GhsczmVT7Ua37Yr26pvV4HU/DkCFMOLHjjm4CYJOfszf9
	 TsHBoLjYoD/Ji0UNoEpaJXsI5mfjBwHYmgwsFJi5WigLWXDYWjoJJu99z9G6uu3RMxF5O
	 M2SXguplXgA5FpG9oLRwDvFeEup396JprO1AFMLYrHtNFBTLp8YMWMWlcJcOUaZBlsNUI
	 mj8TqhuqX+of5eza0j9RyOSbJpTNhWBo6G/xgnQ2dIPvrmEzmaJJ0+J3OLkDZp201ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6WaHUPr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1636606EE8E;
	Sat,  7 Nov 2026 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6WaHUPr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2F31F008A7;
	Sat,  7 Nov 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060996;
	bh=Mj4SnWIfhsH3h6bnZbq/79454WUcfLr9Vwmm/Qr3rAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6WaHUPraFOU+I8ezK5CxGGFiU0qrp1bdJbegF5drW/04IK7aDbMDR9kqqZ/2ZWfZ
	 1PexbJy0dtfnAhUTy09ryK7Y82F+qKQctN/o/WxfTMjXGig+s7ap+H9WC6kmpQ3AQt
	 631FxdccpWH0X/tdkTyAlGU/Y53MwkSTzlIBbU/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0343/1536] ksmbd: return buffer too small for short security queries
Date: Sat,  7 Nov 2026 08:39:19 -0500
Message-ID: <20261107135007.315972976@linuxfoundation.org>
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
index 678db1aaeba55..3ff76c851cc40 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5893,6 +5893,12 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
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




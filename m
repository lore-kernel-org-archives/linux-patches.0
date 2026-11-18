Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058943;
	b=Z84t8ybI5z0u4PmdEv/0KoxjWqYSjprN2Bmyi1bEY/mb/EgP2KY+2aSesiDeosV5iyQU
	 laAf2RbjJyV/P7CGtFkS9j2E3kdW18GKgoLoDYgpzvGe2/oezD2W0qCt7QrOmnmj5bBHm
	 pP753aFTSotFoMtGD+Ox8gTGUR+JByQwDtZN/grM5/kLN6T+bMSk4c/v5AeDFO/VwWMAy
	 xi3BDiRv7my/gGG+MbC/nihxDqtHWjpOy33PjRlkQmNfOAf3RxOniiJiNX0+AUK6BW/ND
	 naM93PyGsedRQ9AUQlZbUMlX4gjfCyRQJgLpz54xZTQL3RAGrY06OX0VQWi2radhWPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=haM/CGSDw+LJu/adlKo+CoJsb+ANa4t6MOLEks4jfwQ=;
	b=mkT8nQeNzxg03SHeL8HuQEsUFhZBYiUaVqD7cf8JNM97IgyE7fD7Lcgh6xLqF3oOvA3f
	 yayo5l7tQXbclyphhAu6AOcE2HWN8OaNtS+hXntCVdc8qIIVgUNZKV53fzRRr1TB8OK9E
	 Xt2cBCZamq/opkFAperwRdSkSJVI1dgWhQ4wz0/U0vvaoOZsOPJmNGSlcH1sX11gzR97R
	 nkQ6pE9zDjGyTr1mmwRYgYSkRZIaF3r1OiNWwSBq+PV6pJ4Yr/CuWdkdXJrr4WKqCAT3X
	 C96yhjyuqKs4LjbyqJ95PMhxRUu00ZFSgSDZvXMXrrQrXtzIH9i4VPCasC0zRjij6Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPdUOqy7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE518606A325;
	Thu, 19 Nov 2026 03:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPdUOqy7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F6C1F000C6;
	Thu, 19 Nov 2026 03:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058942;
	bh=haM/CGSDw+LJu/adlKo+CoJsb+ANa4t6MOLEks4jfwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPdUOqy7+wnT7vMFSpkdG3i4ykpCd7XTz78yfZXbIToAtwhD5QIP7m7tZnb8jbgqw
	 n5r+98+wXH/wdN4B49VJ5BRqylsGtUi+UulK1ONooyB2J61MMntZeCRXTbzwMX7Te8
	 T6IPWOmkv6hji8Axpccn/3TffbLwJ+W2LcI0l7YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0624/1848] smb: client: validate SMB1 EA list bounds before parsing
Date: Wed, 18 Nov 2026 15:44:22 +0100
Message-ID: <20261118145941.550151524@linuxfoundation.org>
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

[ Upstream commit ddc7a7e1eeb116ccaf010a6f1fb6ab927f3f888d ]

CIFSSMBQAllEAs() checks the server-provided EA list length by adding it
to the response pointer. On 32-bit systems, a positive length can wrap
the pointer and pass the comparison. The parser then walks outside the
received response while reading the next FEA header.

A response with a list length of 0x40000000 reproduces this as a native
i386 page fault and kernel panic from listxattr() against an SMB1
server.

Check that the EA list starts within the SMB byte area before reading
its header. Keep its length unsigned and compare it with the bytes left
in the response without pointer addition.

SMB1 is not negotiated by default and requires an explicit vers=1.0
mount.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: replaced smb_EIO2() calls with direct -EIO assignments ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifssmb.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c867e31980785..d61effb5fef37 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -6197,9 +6197,11 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int bytes_returned;
 	int list_len;
+	u32 ea_list_len;
 	struct fealist *ea_response_data;
 	struct fea *temp_fea;
 	char *temp_ptr;
+	char *byte_area;
 	char *end_of_smb;
 	__u16 params, byte_count, data_offset;
 	unsigned int ea_name_len = ea_name ? strlen(ea_name) : 0;
@@ -6276,9 +6278,18 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	ea_response_data = (struct fealist *)
 				(((char *) &pSMBr->hdr.Protocol) + data_offset);
 
-	list_len = le32_to_cpu(ea_response_data->list_len);
-	cifs_dbg(FYI, "ea length %d\n", list_len);
-	if (list_len <= 8) {
+	byte_area = pByteArea(&pSMBr->hdr);
+	end_of_smb = byte_area + get_bcc(&pSMBr->hdr);
+	if ((char *)ea_response_data < byte_area ||
+	    (char *)ea_response_data >
+	    end_of_smb - sizeof(ea_response_data->list_len)) {
+		rc = -EIO;
+		goto QAllEAsOut;
+	}
+
+	ea_list_len = le32_to_cpu(ea_response_data->list_len);
+	cifs_dbg(FYI, "%s: ea length: %u\n", __func__, ea_list_len);
+	if (ea_list_len <= 8) {
 		cifs_dbg(FYI, "empty EA list returned from server\n");
 		/* didn't find the named attribute */
 		if (ea_name)
@@ -6287,12 +6298,12 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* make sure list_len doesn't go past end of SMB */
-	end_of_smb = (char *)pByteArea(&pSMBr->hdr) + get_bcc(&pSMBr->hdr);
-	if ((char *)ea_response_data + list_len > end_of_smb) {
+	if (ea_list_len > end_of_smb - (char *)ea_response_data) {
 		cifs_dbg(FYI, "EA list appears to go beyond SMB\n");
 		rc = -EIO;
 		goto QAllEAsOut;
 	}
+	list_len = ea_list_len;
 
 	/* account for ea list len */
 	list_len -= 4;
-- 
2.53.0



